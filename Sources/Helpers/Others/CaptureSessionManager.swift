//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: CaptureSessionManager.swift
//  Creation: 4/9/21 1:01 PM
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

class CaptureSessionManager
{
    private var observations: [NSKeyValueObservation] = []
    
    private(set) var currentCapturePosition: AVCaptureDevice.Position
    private(set) var backVideoInput: AVCaptureDeviceInput?
    private(set) var frontVideoInput: AVCaptureDeviceInput?
    private(set) var currentCaptureOutput: AVCaptureOutput?
    
    let session: AVCaptureSession = .init()
    let previewLayer: AVCaptureVideoPreviewLayer = .init()
    let sessionQueue: DispatchQueue = .init(label: Bundle.main.bundleIdentifier! + "-" + "CaptureSessionQueue")
    
    init(currentCapturePosition: AVCaptureDevice.Position = .back)
    {
        self.currentCapturePosition = currentCapturePosition
        
        configureInputs()
        configureSession()
        configurePreviewLayer()
        
        setObservers()
    }
}

private extension CaptureSessionManager
{
    // MARK: - Configuration
    
    private func configureInputs()
    {
        do
        {
            try configureBackCamera()
            try configureFrontCamera()
        }
        catch
        {
            debugPrint(error)
        }
    }
    
    private func configureBackCamera() throws
    {
        if let backVideoCamera = defaultCameraFor(devicePosition: .back)
        {
            self.backVideoInput = try AVCaptureDeviceInput(device: backVideoCamera)
        }
    }
    
    private func configureFrontCamera() throws
    {
        if let frontVideoCamera = defaultCameraFor(devicePosition: .front)
        {
            self.frontVideoInput = try AVCaptureDeviceInput(device: frontVideoCamera)
        }
    }
    
    private func configureSession()
    {
        sessionQueue.async
        {
            self.session.beginConfiguration()
            
            self.session.sessionPreset = .hd1280x720
            self.session.usesApplicationAudioSession = true
            self.session.automaticallyConfiguresApplicationAudioSession = true
            self.session.automaticallyConfiguresCaptureDeviceForWideColor = false
            self.updateVideoInput()
            
            self.session.commitConfiguration()
        }
    }
    
    private func configurePreviewLayer()
    {
        previewLayer.session = session
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.masksToBounds = true
        previewLayer.opacity = 0 // Should be set to 1 when the session is running.
    }
    
    private func defaultCameraFor(devicePosition: AVCaptureDevice.Position) -> AVCaptureDevice?
    {
        var defaultCamera: AVCaptureDevice? = nil
        
        if let dualCamera = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: devicePosition)
        {
            defaultCamera = dualCamera
        }
        else if let wideAngleCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: devicePosition)
        {
            defaultCamera = wideAngleCamera
        }
        
        if let defaultCamera = defaultCamera
        {
            do
            {
                try defaultCamera.lockForConfiguration()
                
                if defaultCamera.isLowLightBoostSupported
                {
                    defaultCamera.automaticallyEnablesLowLightBoostWhenAvailable = true
                }
                
                if defaultCamera.isSmoothAutoFocusSupported
                {
                    defaultCamera.isSmoothAutoFocusEnabled = true
                }
                
                setContinuousCalibrationFor(captureDevice: defaultCamera)
                
                defaultCamera.automaticallyAdjustsVideoHDREnabled = true
                defaultCamera.isSubjectAreaChangeMonitoringEnabled = true
                
                defaultCamera.unlockForConfiguration()
                
                return defaultCamera
            }
            catch
            {
                debugPrint(error)
            }
        }
        
        return defaultCamera
    }
    
    private func setObservers()
    {
        let isRunningObservation = session.observe(\.isRunning)
        { (session, _) in
            if session.isRunning
            {
                self.showPreviewLayer()
            }
            else
            {
                self.hidePreviewLayer()
            }
        }
        
        observations.append(isRunningObservation)
        
        let isInterruptedObservation = session.observe(\.isInterrupted)
        { (session, _) in
            if session.isInterrupted
            {
                self.hidePreviewLayer()
            }
            else
            {
                self.showPreviewLayer()
            }
        }
        
        observations.append(isInterruptedObservation)
    }
    
    // MARK: - Updates
    
    private func updateVideoInput()
    {
        if self.currentCapturePosition == .back
        {
            self.setBackVideoInput()
        }
        else
        {
            self.setFrontVideoInput()
        }
    }
    
    private func setBackVideoInput()
    {
        guard let backVideoInput = backVideoInput, let frontVideoInput = frontVideoInput
        else
        {
            return
        }
        
        session.removeInput(frontVideoInput)
        if session.canAddInput(backVideoInput)
        {
            session.addInput(backVideoInput)
        }
    }
    
    private func setFrontVideoInput()
    {
        guard let backVideoInput = backVideoInput, let frontVideoInput = frontVideoInput
        else
        {
            return
        }
        
        session.removeInput(backVideoInput)
        if session.canAddInput(frontVideoInput)
        {
            session.addInput(frontVideoInput)
        }
    }
    
    private func updateCaptureOutputOrientation()
    {
        if let currentCaptureOutput = currentCaptureOutput, let connection = currentCaptureOutput.connection(with: .video)
        {
            if connection.isVideoOrientationSupported
            {
                connection.videoOrientation = .portrait
            }
            
            if connection.isVideoMirroringSupported
            {
                connection.isVideoMirrored = currentCapturePosition == .front
            }
        }
    }
    
    private func setCalibrationPointOfInterestFor(captureDevice: AVCaptureDevice, pointOfInterest: CGPoint)
    {
        if captureDevice.isFocusPointOfInterestSupported
        {
            captureDevice.focusPointOfInterest = pointOfInterest
        }
        
        if captureDevice.isExposurePointOfInterestSupported
        {
            captureDevice.exposurePointOfInterest = pointOfInterest
        }
    }
    
    private func setContinuousCalibrationFor(captureDevice: AVCaptureDevice)
    {
        if captureDevice.isFocusModeSupported(.continuousAutoFocus)
        {
            captureDevice.focusMode = .continuousAutoFocus
        }
        
        if captureDevice.isExposureModeSupported(.continuousAutoExposure)
        {
            captureDevice.exposureMode = .continuousAutoExposure
        }
        
        if captureDevice.isWhiteBalanceModeSupported(.continuousAutoWhiteBalance)
        {
            captureDevice.whiteBalanceMode = .continuousAutoWhiteBalance
        }
    }
}

extension CaptureSessionManager
{
    var currentVideoInput: AVCaptureDeviceInput?
    {
        if currentCapturePosition == .back
        {
            return backVideoInput
        }
        
        return frontVideoInput
    }
    
    // MARK: - Updates
    
    func startSession()
    {
        sessionQueue.async
        {
            self.session.startRunning()
        }
    }
    
    func stopSession()
    {
        sessionQueue.async
        {
            self.session.stopRunning()
        }
    }
    
    func updatePreviewLayerFrame(newFrame: CGRect)
    {
        self.previewLayer.frame = newFrame       
    }
    
    func updateTorchMode(newTorchMode: AVCaptureDevice.TorchMode)
    {
        sessionQueue.async
        {
            if let currentDevice = self.currentVideoInput?.device, currentDevice.isTorchAvailable, currentDevice.isTorchModeSupported(newTorchMode)
            {
                do
                {
                    try currentDevice.lockForConfiguration()
                    
                    currentDevice.torchMode = newTorchMode
                    
                    currentDevice.unlockForConfiguration()
                }
                catch
                {
                    debugPrint(error)
                }
            }
        }
    }
    
    func updateSessionPreset(newSessionPreset: AVCaptureSession.Preset)
    {
        sessionQueue.async
        {
            self.session.beginConfiguration()
            self.session.sessionPreset = newSessionPreset
            self.session.commitConfiguration()
        }
    }
    
    /// Switches the video input depending on the current capture position.
    func switchVideoInput()
    {
        sessionQueue.async
        {
            
            // Hide the preview layer until the input has changed for a smooth transition.
            self.hidePreviewLayer()
            
            defer
            {
                self.showPreviewLayer()
            }
            
            self.session.beginConfiguration()
            
            self.currentCapturePosition = self.currentCapturePosition == .back ? .front : .back
            self.updateVideoInput()
            self.updateCaptureOutputOrientation()
            
            self.session.commitConfiguration()
        }
    }
    
    /// Triggers a calibration (focus + white balance + exposure) in the given point of interest.
    func calibrateFor(captureDevice: AVCaptureDevice, pointOfInterest: CGPoint)
    {
        if pointOfInterest != .zero
        {
            sessionQueue.async
            {
                do
                {
                    try captureDevice.lockForConfiguration()
                    
                    self.setCalibrationPointOfInterestFor(captureDevice: captureDevice, pointOfInterest: pointOfInterest)
                    
                    self.setContinuousCalibrationFor(captureDevice: captureDevice)
                    
                    captureDevice.unlockForConfiguration()
                }
                catch
                {
                    debugPrint(error)
                }
            }
        }
    }
    
    func addOutput(captureOutput: AVCaptureOutput)
    {
        sessionQueue.async
        {
            self.session.beginConfiguration()
            
            if self.session.canAddOutput(captureOutput)
            {
                self.session.addOutput(captureOutput)
                self.currentCaptureOutput = captureOutput
                self.updateCaptureOutputOrientation()
            }
            
            self.session.commitConfiguration()
        }
    }
    
    func showPreviewLayer()
    {
        DispatchQueue.main.async
        {
            self.previewLayer.removeAllAnimations()
            
            let animation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
            
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = 0.65
            animation.repeatCount = 0
            animation.autoreverses = false
            animation.isRemovedOnCompletion = false
            animation.fillMode = .forwards
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
            self.previewLayer.add(animation, forKey: nil)
        }
    }
    
    func hidePreviewLayer()
    {
        DispatchQueue.main.async
        {
            self.previewLayer.removeAllAnimations()
            self.previewLayer.opacity = 0
        }
    }
}
