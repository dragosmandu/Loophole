//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: CHHapticPattern+Ext.swift
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

public extension CHHapticPattern
{
    // MARK: - Constants & Variables
    
    /// A haptic pattern that feels like popping out.
    static var fallHapticPattern: CHHapticPattern?
    {
        var fallHapticPattern: CHHapticPattern?
        let fallHapticEvent = CHHapticEvent.fallHapticEvent
        
        fallHapticEvent.relativeTime = 0
        
        do
        {
            fallHapticPattern = try CHHapticPattern(events: [fallHapticEvent], parameters: [])
        }
        catch
        {
            debugPrint(error)
        }
        
        return fallHapticPattern
    }
    
    /// A haptic pattern that feels like popping in.
    static var riseHapticPattern: CHHapticPattern?
    {
        var riseHapticPattern: CHHapticPattern?
        let riseHapticEvent = CHHapticEvent.riseHapticEvent
        
        riseHapticEvent.relativeTime = 0
        
        do
        {
            riseHapticPattern = try CHHapticPattern(events: [riseHapticEvent], parameters: [])
        }
        catch
        {
            debugPrint(error)
        }
        
        return riseHapticPattern
    }
    
    /// Should be used for clicks.
    static var clickHapticPattern: CHHapticPattern?
    {
        var clickHapticPattern: CHHapticPattern?
        let clickHapticEvent = CHHapticEvent.clickHapticEvent
        
        clickHapticEvent.relativeTime = 0
        
        do
        {
            clickHapticPattern = try CHHapticPattern(events: [clickHapticEvent], parameters: [])
        }
        catch
        {
            debugPrint(error)
        }
        
        return clickHapticPattern
    }
    
    /// A haptic pattern that feels like an on switch.
    static var onHapticPattern: CHHapticPattern?
    {
        var onHapticPattern: CHHapticPattern?
        let fallHapticEvent = CHHapticEvent.fallHapticEvent
        let riseHapticEvent = CHHapticEvent.riseHapticEvent
        
        fallHapticEvent.relativeTime = 0
        riseHapticEvent.relativeTime = CHHapticEvent.fallHapticEventDuration
        
        do
        {
            onHapticPattern = try CHHapticPattern(events: [fallHapticEvent, riseHapticEvent], parameters: [])
        }
        catch
        {
            debugPrint(error)
        }
        
        return onHapticPattern
    }
    
    /// A haptic pattern that feels like an off switch.
    static var offHapticPattern: CHHapticPattern?
    {
        var offHapticPattern: CHHapticPattern?
        let riseHapticEvent = CHHapticEvent.riseHapticEvent
        let fallHapticEvent = CHHapticEvent.fallHapticEvent
        
        riseHapticEvent.relativeTime = 0
        fallHapticEvent.relativeTime = CHHapticEvent.riseHapticEventDuration
        
        do
        {
            offHapticPattern = try CHHapticPattern(events: [riseHapticEvent, fallHapticEvent], parameters: [])
        }
        catch
        {
            debugPrint(error)
        }
        
        return offHapticPattern
    }
}

