//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: CaptureSessionController.swift
//  Creation: 4/9/21 1:03 PM
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

public class CaptureSessionController: UIViewController
{
    private(set) var captureSessionManager: CaptureSessionManager!
    
    private let calibrationIndicator: CalibrationIndicatorView = .init()
    private var observations: [NSKeyValueObservation] = []
    private var initialZoomScale: CGFloat = 0
    
    var isRecording: Bool
    
    /// - Returns: A basic capture session controller.
    public init(currentCapturePosition: AVCaptureDevice.Position = .back, isRecording: Bool = false)
    {
        self.isRecording = isRecording
        
        super.init(nibName: nil, bundle: nil)
        
        captureSessionManager = .init(currentCapturePosition: currentCapturePosition)
    }
    
    required init?(coder: NSCoder)
    {
        self.isRecording = false
        
        super.init(coder: coder)
    }
    
    deinit
    {
        for observation in observations
        {
            observation.invalidate()
        }
    }
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        configurePreviewLayer()
        configureCalibrationIndicator()
        
        addGestures()
    }
    
    public override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        captureSessionManager.startSession()
    }
    
    public override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        captureSessionManager.stopSession()
    }
}

extension CaptureSessionController
{
    // MARK: - Configuration
    
    /// Sets the capture session preview layer to the current view layer.
    private func configurePreviewLayer()
    {
        captureSessionManager.updatePreviewLayerFrame(newFrame: view.frame)
        view.layer.addSublayer(captureSessionManager.previewLayer)
        
        if let connection = captureSessionManager.previewLayer.connection
        {
            connection.automaticallyAdjustsVideoMirroring = true
            
            if connection.isVideoStabilizationSupported
            {
                connection.preferredVideoStabilizationMode = .auto
            }
        }
    }
    
    private func configureCalibrationIndicator()
    {
        if let captureDevice = captureSessionManager.backVideoInput?.device
        {
            calibrationIndicator.observe(captureDevice: captureDevice)
        }
        
        if let captureDevice = captureSessionManager.frontVideoInput?.device
        {
            calibrationIndicator.observe(captureDevice: captureDevice)
        }
        
        view.addSubview(calibrationIndicator)
    }
}

private extension CaptureSessionController
{
    // MARK: - Gestures + Observers
    
    private func addGestures()
    {
        view.addGestureRecognizer(switchCameraGesture)
        view.addGestureRecognizer(tapToCalibrateGesture)
        view.addGestureRecognizer(pinchToZoomGesture)
    }
    
    private var switchCameraGestureName: String
    {
        return "SwitchCameraGestureName"
    }
    
    private var switchCameraGesture: UITapGestureRecognizer
    {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didSwitchCamera))
        
        gesture.delegate = self
        gesture.name = switchCameraGestureName
        gesture.numberOfTapsRequired = 2
        gesture.numberOfTouchesRequired = 1
        
        return gesture
    }
    
    @objc private func didSwitchCamera(_ gesture: UITapGestureRecognizer)
    {
        if gesture.state == .ended && captureSessionManager.session.isRunning && !isRecording
        {
            captureSessionManager.switchVideoInput()
        }
    }
    
    private var tapToCalibrateGestureName: String
    {
        return "TapToCalibrateGestureName"
    }
    
    private var tapToCalibrateGesture: UITapGestureRecognizer
    {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didCalibrate))
        
        gesture.delegate = self
        gesture.name = tapToCalibrateGestureName
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        
        return gesture
    }
    
    @objc private func didCalibrate(_ gesture: UITapGestureRecognizer)
    {
        if gesture.state == .ended && captureSessionManager.session.isRunning
        {
            guard let captureDevice = captureSessionManager.currentVideoInput?.device
            else
            {
                return
            }
            
            let tapLocation = gesture.location(in: gesture.view)
            let pointOfInterest = captureSessionManager.previewLayer.captureDevicePointConverted(fromLayerPoint: tapLocation)
            
            DispatchQueue.main.async
            {
                self.calibrationIndicator.center = tapLocation
                self.calibrationIndicator.didTapToCalibrate = true
                self.captureSessionManager.calibrateFor(captureDevice: captureDevice, pointOfInterest: pointOfInterest)
            }
        }
    }
    
    private var pinchToZoomGesture: UIPinchGestureRecognizer
    {
        let gesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinchToZoom))
        
        return gesture
    }
    
    @objc private func didPinchToZoom(_ gesture: UIPinchGestureRecognizer)
    {
        guard let currentDevice = captureSessionManager.currentVideoInput?.device, captureSessionManager.session.isRunning
        else
        {
            return
        }
        
        switch gesture.state
        {
            case .began:
                initialZoomScale = currentDevice.videoZoomFactor
                
            case .changed:
                let availableZoomScaleRange = currentDevice.minAvailableVideoZoomFactor...currentDevice.maxAvailableVideoZoomFactor
                let zoomUpperBound = min(gesture.scale * initialZoomScale, availableZoomScaleRange.upperBound)
                let resolvedScale = max(availableZoomScaleRange.lowerBound, zoomUpperBound)
                
                do
                {
                    try currentDevice.lockForConfiguration()
                    defer
                    {
                        currentDevice.unlockForConfiguration()
                    }
                    
                    currentDevice.videoZoomFactor = resolvedScale
                }
                catch
                {
                    debugPrint(error)
                }
                
            default: return
        }
    }
}

extension CaptureSessionController: UIGestureRecognizerDelegate
{
    // MARK: - Delegates
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        if gestureRecognizer.name == tapToCalibrateGestureName && otherGestureRecognizer.name == switchCameraGestureName
        {
            return true
        }
        
        return false
    }
}

private extension CaptureSessionController
{
    // MARK: - CalibrationIndicatorView
    
    class CalibrationIndicatorView: UIView
    {
        public var circleLayer: CAShapeLayer = .init()
        public var didTapToCalibrate: Bool = false
        private var observations: [NSKeyValueObservation] = []
        
        private(set) var isCalibrating: Bool = false
        
        init()
        {
            let size = CGSize(width: Constant.circleDiameter + Constant.circleBorderLineWidth, height: Constant.circleDiameter + Constant.circleBorderLineWidth)
            let frame: CGRect = .init(origin: .zero, size: size)
            
            super.init(frame: frame)
            
            layer.opacity = 0
            backgroundColor = .clear
            
            configureCircleLayer()
        }
        
        required init?(coder: NSCoder)
        {
            super.init(coder: coder)
        }
        
        deinit
        {
            for observation in observations
            {
                observation.invalidate()
            }
        }
        
        private func configureCircleLayer()
        {
            let circlePath = UIBezierPath(ovalIn: frame)
            
            circleLayer.path = circlePath.cgPath
            circleLayer.fillColor = UIColor.clear.cgColor
            circleLayer.strokeColor = UIColor.white.cgColor
            circleLayer.lineWidth = Constant.circleBorderLineWidth
            
            layer.addSublayer(circleLayer)
        }
        
        /// Sets observers for focus, white balance and exposure calibration and shows the indicator when at least one of the calibrators is active.
        func observe(captureDevice: AVCaptureDevice)
        {
            let isAdjustingFocusObservation = captureDevice.observe(\.isAdjustingFocus)
            { (captureDevice, _) in
                if captureDevice.isAdjustingFocus && self.didTapToCalibrate && !self.isCalibrating
                {
                    self.isCalibrating = true
                    self.didAppear()
                }
                else if !captureDevice.isAdjustingFocus && !captureDevice.isAdjustingExposure && !captureDevice.isAdjustingWhiteBalance && self.isCalibrating
                {
                    self.didTapToCalibrate = false
                    self.isCalibrating = false
                    self.didDisappear()
                }
            }
            
            observations.append(isAdjustingFocusObservation)
            
            let isAdjustingExposureObservation = captureDevice.observe(\.isAdjustingExposure)
            { (captureDevice, _) in
                if captureDevice.isAdjustingExposure && self.didTapToCalibrate && !self.isCalibrating
                {
                    self.isCalibrating = true
                    self.didAppear()
                }
                else if !captureDevice.isAdjustingFocus && !captureDevice.isAdjustingExposure && !captureDevice.isAdjustingWhiteBalance && self.isCalibrating
                {
                    self.didTapToCalibrate = false
                    self.isCalibrating = false
                    self.didDisappear()
                }
            }
            
            observations.append(isAdjustingExposureObservation)
            
            let isAdjustingWhiteBalanceObservation = captureDevice.observe(\.isAdjustingWhiteBalance)
            { (captureDevice, _) in
                if captureDevice.isAdjustingWhiteBalance && self.didTapToCalibrate && !self.isCalibrating
                {
                    self.isCalibrating = true
                    self.didAppear()
                }
                else if !captureDevice.isAdjustingFocus && !captureDevice.isAdjustingExposure && !captureDevice.isAdjustingWhiteBalance && self.isCalibrating
                {
                    self.didTapToCalibrate = false
                    self.isCalibrating = false
                    self.didDisappear()
                }
            }
            
            observations.append(isAdjustingWhiteBalanceObservation)
        }
        
        private func didAppear()
        {
            layer.opacity = 0
            transform = .identity
            layer.removeAllAnimations()
            
            UIView.animate(withDuration: 0.65, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .curveEaseInOut)
            {
                self.layer.opacity = 1
                self.transform = .init(scaleX: 0.85, y: 0.85)
            }
        }
        
        private func didDisappear()
        {
            UIView.animate(withDuration: 0.35, delay: 0.35, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut)
            {
                self.layer.opacity = 0
            } completion:
            { (finished) in
                if finished
                {
                    self.transform = .identity
                    self.layer.removeAllAnimations()
                }
            }
        }
    }
}

