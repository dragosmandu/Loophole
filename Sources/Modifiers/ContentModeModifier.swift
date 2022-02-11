//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: ContentModeModifier.swift
//  Creation: 4/9/21 2:13 PM
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
import CoreHaptics

public struct ContentModeModifier: ViewModifier
{
    @Binding private var contentMode: ContentMode
    
    private let isActive: Bool
    
    /// Sets a magnification gesture that changes the content mode relative to the pinch magnitude. The gesture disappears when isActive is false.
    public init(contentMode: Binding<ContentMode>, isActive: Bool)
    {
        _contentMode = contentMode
        self.isActive = isActive
    }
    
    public func body(content: Content) -> some View
    {
        content
            .gesture(isActive ? magnificationGesture : nil)
    }
    
    private var magnificationGesture: _EndedGesture<MagnificationGesture>
    {
        MagnificationGesture()
            .onEnded
            { (value) in
                let magnitude = value.magnitude
                
                if magnitude > MagnificationGesture.mediaContentModeFillMinMagnitude
                {
                    if contentMode != .fill
                    {
                        contentMode = .fill
                        
                        #if os(iOS)
                        CHHapticEngine.sharedEngine?.play(.riseHapticPattern)
                        #endif
                    }
                }
                else if magnitude < MagnificationGesture.mediaContentModeFitMinMagnitude
                {
                    if contentMode != .fit
                    {
                        contentMode = .fit
                        
                        #if os(iOS)
                        CHHapticEngine.sharedEngine?.play(.fallHapticPattern)
                        #endif
                    }
                }
            }
    }
}

