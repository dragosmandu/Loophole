//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: CHHapticEvent+Ext.swift
//  Creation: 4/9/21 2:15 PM
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

public extension CHHapticEvent
{
    // MARK: - Constants & Variables
    
    static var fallHapticEventDuration: Double = 0.2
    static var fallHapticEventIntensity: Float = 0.6
    static var fallHapticEventSharpness: Float = 0.3
    
    static var riseHapticEventDuration: Double = 0.3
    static var riseHapticEventIntensity: Float = 1
    static var riseHapticEventSharpness: Float = 0.4
    
    static var clickHapticEventDuration: Double = 0.3
    static var clickHapticEventIntensity: Float = 0.8
    static var clickHapticEventSharpness: Float = 0.2
    
    /// Event to create a haptic pattern that feels like a fall.
    static var fallHapticEvent: CHHapticEvent
    {
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: fallHapticEventIntensity)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: fallHapticEventSharpness)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0, duration: fallHapticEventDuration)
        
        return event
    }
    
    /// Event to create a haptic pattern that feels like a rise.
    static var riseHapticEvent: CHHapticEvent
    {
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: riseHapticEventIntensity)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: riseHapticEventSharpness)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0, duration: riseHapticEventDuration)
        
        return event
    }
    
    /// Event to create a haptic pattern that may be used for clicks.
    static var clickHapticEvent: CHHapticEvent
    {
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: clickHapticEventIntensity)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: clickHapticEventSharpness)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0, duration: clickHapticEventDuration)
        
        return event
    }
}

