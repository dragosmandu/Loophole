//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: CameraControllerRepresentable.swift
//  Creation: 4/9/21 1:05 PM
//
//  Company: Thecircle LLC 
//  Contact: dev@thecircle.xyz
//  Website: https://thecircle.xyz
//  Author: Dragos-Costin Mandu
//
//  Copyright © 2021 Thecircle LLC. All rights reserved.
//
//


import SwiftUI
import AVFoundation
import VideoToolbox

struct CameraControllerRepresentable: UIViewControllerRepresentable
{
    @Binding private var currentCapturePosition: AVCaptureDevice.Position
    @Binding private var torchMode: AVCaptureDevice.TorchMode
    @Binding private var isRecording: Bool
    @Binding private var isReversed: Bool
    @Binding private var frameFileURLs: [URL]
    @Binding private var captureDelay: Double
    @Binding private var isHDQuality: Bool
    
    init(currentCapturePosition: Binding<AVCaptureDevice.Position>, torchMode: Binding<AVCaptureDevice.TorchMode>, isRecording: Binding<Bool>, isReversed: Binding<Bool>, frameFileURLs: Binding<[URL]>, captureDelay: Binding<Double>, isHDQuality: Binding<Bool>)
    {
        _currentCapturePosition = currentCapturePosition
        _torchMode = torchMode
        _isRecording = isRecording
        _isReversed = isReversed
        _frameFileURLs = frameFileURLs
        _captureDelay = captureDelay
        _isHDQuality = isHDQuality
    }
    
    func makeCoordinator() -> Coordinator
    {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> CaptureSessionController
    {
        return context.coordinator.controller
    }
    
    func updateUIViewController(_ controller: CaptureSessionController, context: Context)
    {
        if currentCapturePosition != controller.captureSessionManager.currentCapturePosition
        {
            DispatchQueue.main.async
            {
                currentCapturePosition = controller.captureSessionManager.currentCapturePosition
            }
        }
        
        if controller.captureSessionManager.session.sessionPreset == .hd1280x720 && !isHDQuality
        {
            controller.captureSessionManager.updateSessionPreset(newSessionPreset: .vga640x480)
        }
        else if controller.captureSessionManager.session.sessionPreset == .vga640x480 && isHDQuality
        {
            controller.captureSessionManager.updateSessionPreset(newSessionPreset: .hd1280x720)
        }
        
        if isRecording
        {
            DispatchQueue.main.async
            {
                context.coordinator.captureFrames()
            }
        }
    }
}

extension CameraControllerRepresentable
{
    // MARK: - Coordinator
    
    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate
    {
        private var canCaptureFrame: Bool = false
        
        // Timer to let the recorder capture a frame every delay s.
        private var captureTimer: Timer
        {
            .scheduledTimer(withTimeInterval: parent.captureDelay, repeats: true)
            { [weak self] timer in
                guard let `self` = self
                else
                {
                    return
                }
                
                // Stop taking frames, even if the we didn't have max frames.
                if !self.parent.isRecording
                {
                    self.canCaptureFrame = false
                    self.controller.isRecording = false
                    self.controller.captureSessionManager.updateTorchMode(newTorchMode: .off)
                    timer.invalidate()
                }
                else
                {
                    self.canCaptureFrame = true
                }
            }
        }
        
        let parent: CameraControllerRepresentable
        let controller: CaptureSessionController!
        let videoOutput: AVCaptureVideoDataOutput!
        
        init(parent: CameraControllerRepresentable)
        {
            self.parent = parent
            
            controller = .init(currentCapturePosition: parent.currentCapturePosition, isRecording: parent.isRecording)
            videoOutput = .init()
            
            super.init()
            
            configureVideoOutput()
            controller.captureSessionManager.addOutput(captureOutput: videoOutput)
            controller.captureSessionManager.updateTorchMode(newTorchMode: .off)
            
        }
        
        private func configureVideoOutput()
        {
            videoOutput.alwaysDiscardsLateVideoFrames = true
            videoOutput.automaticallyConfiguresOutputBufferDimensions = false
            videoOutput.setSampleBufferDelegate(self, queue: controller.captureSessionManager.sessionQueue)
        }
        
        func captureFrames()
        {
            if !controller.isRecording
            {
                self.controller.captureSessionManager.updateTorchMode(newTorchMode: self.parent.torchMode)
                self.controller.isRecording = true
                self.captureTimer.fire()
            }
        }
        
        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection)
        {
            guard CMSampleBufferDataIsReady(sampleBuffer)
            else
            {
                return
            }
            
            if parent.isRecording && canCaptureFrame
            {
                canCaptureFrame = false
                
                let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
                
                if let pixelBufferCopy = pixelBuffer?.copy
                {
                    if parent.frameFileURLs.count < Constant.maxRecordedFrames
                    {
                        var cgImage: CGImage?
                        
                        VTCreateCGImageFromCVPixelBuffer(pixelBufferCopy, options: nil, imageOut: &cgImage)
                        
                        if let cgImage = cgImage, let jpegData = cgImage.jpegData
                        {
                            if let frameURL = FileManager.createFile(contentType: .jpeg, data: jpegData, directory: .cachesDirectory, domainMask: .userDomainMask)
                            {
                                parent.frameFileURLs.append(frameURL)
                            }
                        }
                    }
                }
                
                if parent.frameFileURLs.count == Constant.maxRecordedFrames
                {
                    parent.isRecording = false
                    controller.isRecording = false
                    controller.captureSessionManager.updateTorchMode(newTorchMode: .off)
                    captureTimer.invalidate()
                }
            }
        }
    }
}
