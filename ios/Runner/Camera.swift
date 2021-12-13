//
//  Camera.swift
//  rootally-mediapipe
//
//  Created by Shrey Gupta on 28/10/21.
//
import AVKit
import UIKit

// swiftlint:disable trailing_whitespace
// swiftlint:disable force_try
// swiftlint:disable line_length
// swiftlint:disableline_length

protocol CameraDelegate: AnyObject {
    func didCaptureOutput(pixelBuffer: CVImageBuffer?)
}

class Camera: NSObject {
    // MARK: - Properties
    weak var delegate: CameraDelegate?
    
    let device: AVCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)!
    let session: AVCaptureSession = .init()
    
    lazy var input: AVCaptureDeviceInput = try! AVCaptureDeviceInput(device: device)
    
    let videoDataOutput: AVCaptureVideoDataOutput = .init()
    
    var assetWriter: AVAssetWriter?
    
    var assetWriterInput: AVAssetWriterInput?
//    var audioWriterInput: AVAssetWriterInput?
    
//    var audioDataOutput: AVCaptureAudioDataOutput?
    
    var videoRecordCompletionBlock: ((URL?, String?) -> Void)?
    var videoRecordUrl: URL?
    
    var sessionAtSourceTime: CMTime?
    var isRecording = false
    
    // MARK: - Lifecycle
    override init() {
        super.init()
        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        
        session.sessionPreset = .vga640x480
        session.addInput(input)
        session.addOutput(videoDataOutput)
        
        videoDataOutput.setSampleBufferDelegate(self, queue: .main)
        
        if #available(iOS 13.0, *) {
            session.connections[0].videoOrientation = .landscapeRight
            session.connections[0].isVideoMirrored = true
            
        } else {
            // Fallback on earlier versions
            videoDataOutput.connection(with: .video)?.videoOrientation = .landscapeRight
            videoDataOutput.connection(with: .video)?.isVideoMirrored = true
        }
    }
    
    func start() {
        session.startRunning()
    }
    
    func stop() {
        stopRecording(shouldSave: false)
        session.stopRunning()
    }
    
    // MARK: - Recording Helper Functions
    func startRecording(completion: @escaping (URL?, String?) -> Void) {
//        guard !isRecording else { return }
//
//        isRecording = true
//        sessionAtSourceTime = nil
//        setUpWriter()
//        print(isRecording)
//
//        videoRecordCompletionBlock = completion
    }
    
    func stopRecording(shouldSave: Bool) {
//        guard isRecording else { return }
//        guard let assetWriter = assetWriter else { return }
//        guard let assetWriterInput = assetWriterInput else { return }
//
//        isRecording = false
//        assetWriterInput.markAsFinished()
//
//        assetWriter.finishWriting { [weak self] in
//            self?.sessionAtSourceTime = nil
//        }
//
//        videoRecordCompletionBlock?(self.videoRecordUrl, nil)
    }
    
    func canWrite() -> Bool {
        return isRecording && assetWriter != nil && assetWriter?.status == .writing
    }
    
    // MARK: - Helper Functions
    func setUpWriter() {
        do {
            videoRecordUrl = videoFileLocation()
            assetWriter = try AVAssetWriter(outputURL: videoRecordUrl!, fileType: AVFileType.mov)
            
            // add video input
            assetWriterInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: [
                AVVideoCodecKey: AVVideoCodecType.h264,
                AVVideoWidthKey: 640,
                AVVideoHeightKey: 480,
                AVVideoCompressionPropertiesKey: [AVVideoAverageBitRateKey: 2300000]
            ])
            
            guard let assetWriter = assetWriter else { return }
            guard let assetWriterInput = assetWriterInput else { return }
            
            assetWriterInput.expectsMediaDataInRealTime = true
            
            if assetWriter.canAdd(assetWriterInput) {
                assetWriter.add(assetWriterInput)
            }
            
//            // audio
//            audioWriterInput = AVAssetWriterInput(mediaType: .audio, outputSettings: nil)
//            guard let audioWriterInput = audioWriterInput else { return }
//
//            audioWriterInput.expectsMediaDataInRealTime = true
//
//            if assetWriter.canAdd(audioWriterInput) {
//                assetWriter.add(audioWriterInput)
//            }
            
            assetWriter.startWriting()
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
    func videoFileLocation() -> URL {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let videoOutputUrl = URL(fileURLWithPath: documentsPath.appendingPathComponent("testing")).appendingPathExtension("mov")
        do {
            if FileManager.default.fileExists(atPath: videoOutputUrl.path) {
                try FileManager.default.removeItem(at: videoOutputUrl)
                print("file removed!")
            }
        } catch {
            print(error)
        }
        
        return videoOutputUrl
    }
}

// MARK: - Delegate AVCaptureVideoDataOutputSampleBufferDelegate
extension Camera: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        delegate?.didCaptureOutput(pixelBuffer: pixelBuffer)
//
//        guard let assetWriter = assetWriter else { return }
//        guard let assetWriterInput = assetWriterInput else { return }
////        guard let audioWriterInput = audioWriterInput else { return }
//        
//        let writable = canWrite()
//
//        if writable, sessionAtSourceTime == nil {
//            sessionAtSourceTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
//            assetWriter.startSession(atSourceTime: sessionAtSourceTime!)
//        }
//
//        if output == self.videoDataOutput {
//            connection.videoOrientation = .landscapeRight
//
//            if connection.isVideoMirroringSupported {
//                connection.isVideoMirrored = true
//            }
//        }
//
//        if writable, output == self.videoDataOutput, (assetWriterInput.isReadyForMoreMediaData) {
//            assetWriterInput.append(sampleBuffer)
//        }
//
////        else if writable, output == audioDataOutput, (audioWriterInput.isReadyForMoreMediaData) {
////            audioWriterInput.append(sampleBuffer)
////        }
    }
}
