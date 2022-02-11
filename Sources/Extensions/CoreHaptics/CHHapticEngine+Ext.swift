//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: CHHapticEngine+Ext.swift
//  Creation: 4/9/21 2:14 PM
//
//  Company: Thecircle LLC 
//  Contact: dev@thecircle.xyz
//  Website: https://thecircle.xyz
//  Author: Dragos-Costin Mandu
//
//  Copyright © 2021 Thecircle LLC. All rights reserved.
//
//


import CoreHaptics

public extension CHHapticEngine
{
    // MARK: - Constants & Variables
    
    /// A shared instance of a CHHapticEngine. Use it wisely.
    static var sharedEngine: CHHapticEngine? = try? .init()
}

public extension CHHapticEngine
{
    // MARK: - Methods
    
    /// Tries to play the given haptic pattern, if supported.
    /// - Parameter pattern: The CHHapticPattern to be played.
    func play(_ pattern: CHHapticPattern?)
    {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics
        else
        {
            return
        }
        
        if let pattern = pattern
        {
            do
            {
                let player = try makePlayer(with: pattern)
                
                start
                { (error) in
                    if let error = error
                    {
                        debugPrint(error)
                        return
                    }
                    
                    do
                    {
                        try player.start(atTime: 0)
                    }
                    catch let error
                    {
                        debugPrint(error)
                    }
                    
                    // Stops the engine when the player finished playing pattern.
                    self.notifyWhenPlayersFinished
                    { (error) -> FinishedAction in
                        if let error = error
                        {
                            debugPrint(error)
                        }
                        
                        return .stopEngine
                    }
                }
            }
            catch
            {
                debugPrint(error)
            }
        }
    }
}


