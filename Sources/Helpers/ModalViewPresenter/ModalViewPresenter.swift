//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: ModalViewPresenter.swift
//  Creation: 4/9/21 8:03 PM
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

public struct ModalViewPresenter
{
    public static var presentAnimationDuration: Double = 0.4
    public static var dismissAnimationDuration: Double = 0.2
    
    static var presentAnimation: Animation
    {
        Animation
            .spring(response: presentAnimationDuration, dampingFraction: 0.8, blendDuration: 0)
            .delay(0)
            .speed(1)
    }
    
    static var dismissAnimation: Animation
    {
        Animation
            .easeIn(duration: dismissAnimationDuration)
            .delay(0)
            .speed(1)
    }
    
    public enum PresentationStart
    {
        case unknown
        case top
        case bottom
        case center
    }
    
    // Calculates the new opacity of the content blocker.
    static func getContentBlockerOpacity(currentOffset: CGFloat, startOffset: CGFloat) -> Double
    {
        let maxContentBlockerOpacity = CGFloat(ModalViewPresenter.Modifier.maxContentBlockerOpacity)
        let newContentBlockerOpacity = maxContentBlockerOpacity - abs(maxContentBlockerOpacity / startOffset * currentOffset)
        
        return Double(newContentBlockerOpacity)
    }
}

