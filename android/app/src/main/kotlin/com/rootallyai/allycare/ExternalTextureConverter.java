// Copyright 2019 The MediaPipe Authors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package com.rootallyai.allycare;

import android.annotation.SuppressLint;
import android.graphics.SurfaceTexture;
import android.graphics.SurfaceTexture.OnFrameAvailableListener;
import android.opengl.GLES20;
import android.util.Log;

import com.google.mediapipe.components.TextureFrameConsumer;
import com.google.mediapipe.components.TextureFrameProducer;
import com.google.mediapipe.framework.AppTextureFrame;
import com.google.mediapipe.framework.GlSyncToken;
import com.google.mediapipe.glutil.GlThread;
import com.google.mediapipe.glutil.ShaderUtil;

import java.lang.Thread.UncaughtExceptionHandler;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.List;
import java.util.Queue;

import javax.microedition.khronos.egl.EGLContext;

public class ExternalTextureConverter implements TextureFrameProducer {
  private static final String TAG = "ExternalTextureConv";
  private static final int DEFAULT_NUM_BUFFERS = 2;
  private static final String THREAD_NAME = "ExternalTextureConverter";
  private final RenderThread thread;
  private Throwable startupException;

  public ExternalTextureConverter(EGLContext parentContext, int numBuffers) {
    this.startupException = null;
    this.thread = this.makeRenderThread(parentContext, numBuffers);
    this.thread.setName("ExternalTextureConverter");
    Object threadExceptionLock = new Object();
    this.thread.setUncaughtExceptionHandler((t, e) -> {
      synchronized(threadExceptionLock) {
        this.startupException = e;
        threadExceptionLock.notify();
      }
    });
    this.thread.start();

    try {
      boolean success = this.thread.waitUntilReady();
      if (!success) {
        synchronized(threadExceptionLock) {
          while(this.startupException == null) {
            threadExceptionLock.wait();
          }
        }
      }
    } catch (InterruptedException var8) {
      Thread.currentThread().interrupt();
      Log.e("ExternalTextureConv", "thread was unexpectedly interrupted: " + var8.getMessage());
      throw new RuntimeException(var8);
    }

    this.thread.setUncaughtExceptionHandler((UncaughtExceptionHandler)null);
    if (this.startupException != null) {
      this.thread.quitSafely();
      throw new RuntimeException(this.startupException);
    }
  }

  public void setFlipY(boolean flip) {
    this.thread.setFlipY(flip);
  }

  public void setRotation(int rotation) {
    this.thread.setRotation(rotation);
  }

  public void setTimestampOffsetNanos(long offsetInNanos) {
    this.thread.setTimestampOffsetNanos(offsetInNanos);
  }

  public ExternalTextureConverter(EGLContext parentContext) {
    this(parentContext, 2);
  }

  public ExternalTextureConverter(EGLContext parentContext, SurfaceTexture texture, int targetWidth, int targetHeight) {
    this(parentContext);
    this.thread.setSurfaceTexture(texture, targetWidth, targetHeight);
  }

  public void setUncaughtExceptionHandler(UncaughtExceptionHandler handler) {
    this.thread.setUncaughtExceptionHandler(handler);
  }

  public void setSurfaceTexture(SurfaceTexture texture, int width, int height) {
    if (texture == null || width != 0 && height != 0) {
      this.thread.getHandler().post(() -> this.thread.setSurfaceTexture(texture, width, height));
    } else {
      throw new RuntimeException("ExternalTextureConverter: setSurfaceTexture dimensions cannot be zero");
    }
  }

  public void setSurfaceTextureAndAttachToGLContext(SurfaceTexture texture, int width, int height) {
    if (texture == null || width != 0 && height != 0) {
      this.thread.getHandler().post(() -> this.thread.setSurfaceTextureAndAttachToGLContext(texture, width, height));
    } else {
      throw new RuntimeException("ExternalTextureConverter: setSurfaceTexture dimensions cannot be zero");
    }
  }

  public void setConsumer(TextureFrameConsumer next) {
    this.thread.setConsumer(next);
  }

  public void addConsumer(TextureFrameConsumer consumer) {
    this.thread.addConsumer(consumer);
  }

  public void removeConsumer(TextureFrameConsumer consumer) {
    this.thread.removeConsumer(consumer);
  }

  public void close() {
    if (this.thread != null) {
      this.thread.quitSafely();

      try {
        this.thread.join();
      } catch (InterruptedException var2) {
        Thread.currentThread().interrupt();
        Log.e("ExternalTextureConv", "thread was unexpectedly interrupted: " + var2.getMessage());
        throw new RuntimeException(var2);
      }
    }
  }

  protected RenderThread makeRenderThread(EGLContext parentContext, int numBuffers) {
    return new RenderThread(parentContext, numBuffers);
  }

  protected static class RenderThread extends GlThread implements OnFrameAvailableListener {
    private static final long NANOS_PER_MICRO = 1000L;
    private volatile SurfaceTexture surfaceTexture = null;
    private final List<TextureFrameConsumer> consumers;
    private final Queue<PoolTextureFrame> framesAvailable = new ArrayDeque();
    private int framesInUse = 0;
    private final int framesToKeep;
    private ExternalTextureRenderer renderer;
    private long nextFrameTimestampOffset = 0L;
    private long timestampOffsetNanos = 0L;
    private long previousTimestamp = 0L;
    private boolean previousTimestampValid = false;
    protected int destinationWidth = 0;
    protected int destinationHeight = 0;
    private boolean first = true;

    public RenderThread(EGLContext parentContext, int numBuffers) {
      super(parentContext);
      this.framesToKeep = numBuffers;
      this.renderer = new ExternalTextureRenderer();
      this.consumers = new ArrayList();
    }

    public void setFlipY(boolean flip) {
      this.renderer.setFlipY(flip);
    }

    public void setRotation(int rotation) {
      this.renderer.setRotation(rotation);
    }

    public void setSurfaceTexture(SurfaceTexture texture, int width, int height) {
      if (this.surfaceTexture != null) {
        this.surfaceTexture.setOnFrameAvailableListener((OnFrameAvailableListener)null);
      }

      this.surfaceTexture = texture;
      if (this.surfaceTexture != null) {
        this.surfaceTexture.setOnFrameAvailableListener(this);
      }

      this.destinationWidth = width;
      this.destinationHeight = height;
    }

    public void setSurfaceTextureAndAttachToGLContext(SurfaceTexture texture, int width, int height) {
      this.setSurfaceTexture(texture, width, height);
      int[] textures = new int[1];
      GLES20.glGenTextures(1, textures, 0);
      if (!first) {
        surfaceTexture.detachFromGLContext();
      } else {
        first = false;
      }
      this.surfaceTexture.attachToGLContext(textures[0]);
      this.surfaceTexture.updateTexImage();
    }

    public void setConsumer(TextureFrameConsumer consumer) {
      synchronized(this.consumers) {
        this.consumers.clear();
        this.consumers.add(consumer);
      }
    }

    public void addConsumer(TextureFrameConsumer consumer) {
      synchronized(this.consumers) {
        this.consumers.add(consumer);
      }
    }

    public void removeConsumer(TextureFrameConsumer consumer) {
      synchronized(this.consumers) {
        this.consumers.remove(consumer);
      }
    }

    public void onFrameAvailable(SurfaceTexture surfaceTexture) {
      this.handler.post(() -> this.renderNext(surfaceTexture));
    }

    public void prepareGl() {
      super.prepareGl();
      GLES20.glClearColor(0.0F, 0.0F, 0.0F, 1.0F);
      this.renderer.setup();
    }

    public void releaseGl() {
      this.setSurfaceTexture((SurfaceTexture)null, 0, 0);

      while(!this.framesAvailable.isEmpty()) {
        teardownFrame((AppTextureFrame)this.framesAvailable.remove());
      }

      this.renderer.release();
      super.releaseGl();
    }

    public void setTimestampOffsetNanos(long offsetInNanos) {
      this.timestampOffsetNanos = offsetInNanos;
    }

    @SuppressLint("WrongConstant")
    protected void renderNext(SurfaceTexture fromTexture) {
      if (fromTexture == this.surfaceTexture) {
        synchronized(this.consumers) {
          boolean frameUpdated = false;

          for (TextureFrameConsumer consumer : this.consumers) {
            AppTextureFrame outputFrame = this.nextOutputFrame();
            this.updateOutputFrame(outputFrame);
            frameUpdated = true;
            if (consumer != null) {
              if (Log.isLoggable("ExternalTextureConv", 2)) {
                Log.v("ExternalTextureConv", String.format("Locking tex: %d width: %d height: %d", outputFrame.getTextureName(), outputFrame.getWidth(), outputFrame.getHeight()));
              }

              outputFrame.setInUse();
              consumer.onNewFrame(outputFrame);
            }
          }

          if (!frameUpdated) {
            AppTextureFrame outputFrame = this.nextOutputFrame();
            this.updateOutputFrame(outputFrame);
          }

        }
      }
    }

    private static void teardownFrame(AppTextureFrame frame) {
      GLES20.glDeleteTextures(1, new int[]{frame.getTextureName()}, 0);
    }

    private PoolTextureFrame createFrame() {
      int destinationTextureId = ShaderUtil.createRgbaTexture(this.destinationWidth, this.destinationHeight);
      Log.d("ExternalTextureConv", String.format("Created output texture: %d width: %d height: %d", destinationTextureId, this.destinationWidth, this.destinationHeight));
      this.bindFramebuffer(destinationTextureId, this.destinationWidth, this.destinationHeight);
      return new PoolTextureFrame(destinationTextureId, this.destinationWidth, this.destinationHeight);
    }

    private AppTextureFrame nextOutputFrame() {
      PoolTextureFrame outputFrame;
      synchronized(this) {
        outputFrame = (PoolTextureFrame)this.framesAvailable.poll();
        ++this.framesInUse;
      }

      if (outputFrame == null) {
        outputFrame = this.createFrame();
      } else if (outputFrame.getWidth() == this.destinationWidth && outputFrame.getHeight() == this.destinationHeight) {
        this.waitUntilReleased(outputFrame);
      } else {
        this.waitUntilReleased(outputFrame);
        teardownFrame(outputFrame);
        outputFrame = this.createFrame();
      }

      return outputFrame;
    }

    protected synchronized void poolFrameReleased(PoolTextureFrame frame) {
      this.framesAvailable.offer(frame);
      --this.framesInUse;
      int keep = Math.max(this.framesToKeep - this.framesInUse, 0);

      while(this.framesAvailable.size() > keep) {
        PoolTextureFrame textureFrameToRemove = (PoolTextureFrame)this.framesAvailable.remove();
        this.handler.post(() -> teardownFrame(textureFrameToRemove));
      }

    }

    private void updateOutputFrame(AppTextureFrame outputFrame) {
      this.bindFramebuffer(outputFrame.getTextureName(), this.destinationWidth, this.destinationHeight);
      this.renderer.render(this.surfaceTexture);
      long textureTimestamp = (this.surfaceTexture.getTimestamp() + this.timestampOffsetNanos) / 1000L;
      if (this.previousTimestampValid && textureTimestamp + this.nextFrameTimestampOffset <= this.previousTimestamp) {
        this.nextFrameTimestampOffset = this.previousTimestamp + 1L - textureTimestamp;
      }

      outputFrame.setTimestamp(textureTimestamp + this.nextFrameTimestampOffset);
      this.previousTimestamp = outputFrame.getTimestamp();
      this.previousTimestampValid = true;
    }

    @SuppressLint("WrongConstant")
    private void waitUntilReleased(AppTextureFrame frame) {
      try {
        if (Log.isLoggable("ExternalTextureConv", 2)) {
          Log.v("ExternalTextureConv", String.format("Waiting for tex: %d width: %d height: %d timestamp: %d", frame.getTextureName(), frame.getWidth(), frame.getHeight(), frame.getTimestamp()));
        }

        frame.waitUntilReleased();
        if (Log.isLoggable("ExternalTextureConv", 2)) {
          Log.v("ExternalTextureConv", String.format("Finished waiting for tex: %d width: %d height: %d timestamp: %d", frame.getTextureName(), frame.getWidth(), frame.getHeight(), frame.getTimestamp()));
        }

      } catch (InterruptedException var3) {
        Thread.currentThread().interrupt();
        Log.e("ExternalTextureConv", "thread was unexpectedly interrupted: " + var3.getMessage());
        throw new RuntimeException(var3);
      }
    }

    private class PoolTextureFrame extends AppTextureFrame {
      public PoolTextureFrame(int textureName, int width, int height) {
        super(textureName, width, height);
      }

      public void release(GlSyncToken syncToken) {
        super.release(syncToken);
        RenderThread.this.poolFrameReleased(this);
      }

      public void release() {
        super.release();
        RenderThread.this.poolFrameReleased(this);
      }
    }
  }
}

