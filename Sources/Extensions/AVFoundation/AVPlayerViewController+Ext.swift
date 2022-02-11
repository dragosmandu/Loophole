//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: AVPlayerViewController+Ext.swift
//  Creation: 4/19/21 2:42 PM
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
import AVKit
import CoreHaptics

public extension AVPlayerViewController
{
    private func configurePlayer()
    {
        player?.allowsExternalPlayback = true
        player?.automaticallyWaitsToMinimizeStalling = true
        player?.preventsDisplaySleepDuringVideoPlayback = true
        player?.currentItem?.preferredMaximumResolution = .zero
    }
    
    private func configureAudioSession()
    {
        let audioSharedInstance = AVAudioSession.sharedInstance()
        
        do
        {
            try audioSharedInstance.setCategory(.playback, options: [.mixWithOthers])
        }
        catch
        {
            debugPrint("Failed to set audio category with error: ", error.localizedDescription)
        }
    }
    
    private func resetVideoIfNeeded()
    {
        guard let currentTimeSec = player?.currentTime().seconds, let currentItemDurationSec = player?.currentItem?.duration.seconds
        else
        {
            return
        }
        
        if currentTimeSec >= currentItemDurationSec
        {
            let seekTime = CMTime(seconds: 0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            
            player?.seek(to: seekTime, toleranceBefore: .zero, toleranceAfter: .zero)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        showsPlaybackControls = false
        videoGravity = .resizeAspectFill
        
        configurePlayer()
        configureAudioSession()
        setGestures()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        resetVideoIfNeeded()
        
        player?.play()
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        player?.pause()
    }
}

extension AVPlayerViewController
{
    // MARK: - Gestures
    
    private func setGestures()
    {
        view.addGestureRecognizer(videoGravityToggleGesture)
        view.addGestureRecognizer(playPauseToggleGesture)
    }
    
    private var videoGravityToggleGesture: UIPinchGestureRecognizer
    {
        let gesture = UIPinchGestureRecognizer(target: self, action: #selector(didToggleVideoGravity))
        
        return gesture
    }
    
    @objc private func didToggleVideoGravity(_ gesture: UIPinchGestureRecognizer)
    {
        if gesture.state == .ended
        {
            if gesture.scale > MagnificationGesture.mediaContentModeFillMinMagnitude && videoGravity != .resizeAspectFill
            {
                CATransaction.begin()
                CATransaction.setDisableActions(true) // Disable animations.
                
                videoGravity = .resizeAspectFill
                CHHapticEngine.sharedEngine?.play(.riseHapticPattern)
                
                CATransaction.commit()
            }
            else if gesture.scale < MagnificationGesture.mediaContentModeFitMinMagnitude && videoGravity != .resizeAspect
            {
                CATransaction.begin()
                CATransaction.setDisableActions(true) // Disable animations.
                
                videoGravity = .resizeAspect
                CHHapticEngine.sharedEngine?.play(.fallHapticPattern)
                
                CATransaction.commit()
            }
        }
    }
    
    private var playPauseToggleGesture: UILongPressGestureRecognizer
    {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didTogglePlayPause))
        
        gesture.minimumPressDuration = 0.15
        gesture.numberOfTapsRequired = 0
        gesture.numberOfTouchesRequired = 1
        gesture.allowableMovement = .infinity
        
        return gesture
    }
    
    @objc private func didTogglePlayPause(_ gesture: UILongPressGestureRecognizer)
    {
        switch gesture.state
        {
            case .began:
                player?.pause()
            case .ended:
                if let currentTimeSec = player?.currentTime().seconds, let currentItemDurationSec = player?.currentItem?.duration.seconds, currentTimeSec >= currentItemDurationSec
                {
                    player?.seek(to: .zero)
                }
                
                player?.play()
            default:
                break
        }
    }
}
