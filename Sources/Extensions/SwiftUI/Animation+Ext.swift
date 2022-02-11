//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: Animation+Ext.swift
//  Creation: 4/9/21 2:20 PM
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

public extension Animation
{
    // MARK: - Constants & Variables
    
    static var viewInsertionDuration: Double = 0.2
    static var viewInsertionDelay: Double = 0
    static var viewInsertionSpeed: Double = 1
    
    static var viewRemovalDuration: Double = 0.15
    static var viewRemovalDelay: Double = 0
    static var viewRemovalSpeed: Double = 1
    
    /// An animation to be used for a View insertion.
    static var viewInsertionAnimation: Animation
    {
        return Animation
            .easeOut(duration: viewInsertionDuration)
            .delay(viewInsertionDelay)
            .speed(viewInsertionSpeed)
    }
    
    /// An animation to be used for a View removal.
    static var viewRemovalAnimation: Animation
    {
        return Animation
            .easeIn(duration: viewRemovalDuration)
            .delay(viewRemovalDelay)
            .speed(viewRemovalSpeed)
    }
}

public extension Animation
{
    // MARK: - Methods
    
    /// Repeats the current animation until isAnimating is false.
    /// - Parameters:
    ///   - isAnimating: Shows if the current animation is repeating or not.
    ///   - autoreverses: If false, the animation will restart each time has ended.
    /// - Returns: A forever repeating animation if when isAnimating is true, the current animation otherwise.
    func repeatWhile(_ isAnimating: Bool, autoreverses:  Bool) -> Animation
    {
        if isAnimating
        {
            return self.repeatForever(autoreverses: true)
        }
        else
        {
            return self
        }
    }
}



