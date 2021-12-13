package com.rootallyai.allycare

import android.app.Activity
import android.util.Log
import android.content.Context
import android.view.View
import com.rootallyai.allycarebl.PosenetViewModel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugin.common.PluginRegistry

class NativeViewFactory(val activity: Activity,val binaryMessenger: BinaryMessenger,val viewModel: PosenetViewModel) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        Log.d("Check:","Inside NativeViewFactory")
        val creationParams = args as Map<String?, Any?>?
        return NativeView(activity,binaryMessenger,viewModel,context, viewId, creationParams)
    }


}