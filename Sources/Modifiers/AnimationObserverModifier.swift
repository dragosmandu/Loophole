//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: AnimationObserverModifier.swift
//  Creation: 4/9/21 8:08 PM
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

public struct AnimationObserverModifier<Value>: AnimatableModifier where Value: VectorArithmetic
{
    public var animatableData: Value
    {
        didSet
        {
            // Notifies the change of the observed value.
            changed()
            
            // Will check if the observed value has reached the target, and notifies if it did.
            ended()
        }
    }
    
    private var targetValue: Value
    
    private var changedHandler: (_ currentValue: Value) -> Void
    private var endedHandler: () -> Void
    
    /// - Parameters:
    ///   - observedValue: The value to observe, changed by an animation.
    ///   - changedHandler: Notifies, with the current value of the observed value, when the observed value changed.
    ///   - endedHandler: Notifies when the observed value has reached the target value.
    init(observedValue: Value, changedHandler: @escaping (_ currentValue: Value) -> Void, endedHandler: @escaping () -> Void)
    {
        self.animatableData = observedValue
        self.changedHandler = changedHandler
        self.endedHandler = endedHandler
        targetValue = observedValue
    }
    
    public func body(content: Content) -> some View
    {
        content
    }
    
    private func changed()
    {
        DispatchQueue.main.async
        {
            self.changedHandler(animatableData)
        }
    }
    
    private func ended()
    {
        guard animatableData == targetValue else { return }
        
        DispatchQueue.main.async
        {
            self.endedHandler()
        }
    }
}

