//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: AnimatedTapGestureModifier.swift
//  Creation: 4/9/21 7:51 PM
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

public struct AnimatedTapGestureModifier: ViewModifier
{
    /// The minimum scale of a View when tapped.
    public static var minScale: CGFloat = 0.97
    
    /// The maximum scale of a View when is not tapped.
    public static var maxScale: CGFloat = 1
    
    public static var animationDelay: Double = 0
    public static var animationSpeed: Double = 1.2
    public static var tapCount: Int = 1
    
    private var animation: Animation
    {
        Animation
            .spring()
            .delay(AnimatedTapGestureModifier.animationDelay)
            .speed(AnimatedTapGestureModifier.animationSpeed)
    }
    
    /// Keeps track of the current content scale.
    @State private var scale: CGFloat = AnimatedTapGestureModifier.maxScale
    
    private let isActive: Bool
    private let onTapAction: () -> Void
    
    /// Adds a tap gesture with an animation on  the content View.
    /// - Parameter onTapAction: Action called when the content tap animation ended.
    init(isActive: Bool, onTapAction: @escaping () -> Void)
    {
        self.isActive = isActive
        self.onTapAction = onTapAction
    }
    
    public func body(content: Content) -> some View
    {
        Group
        {
            if isActive
            {
                content
                    .scaleEffect(scale)
                    .onTapGesture(count: AnimatedTapGestureModifier.tapCount)
                    {
                        withAnimation(animation)
                        {
                            scale = AnimatedTapGestureModifier.minScale
                        }
                    }
                    .onChange(of: scale)
                    { _ in
                        if scale == AnimatedTapGestureModifier.minScale
                        {
                            withAnimation(animation)
                            {
                                scale = AnimatedTapGestureModifier.maxScale
                            }
                        }
                        else if scale == AnimatedTapGestureModifier.maxScale
                        {
                            onTapAction()
                        }
                    }
            }
            else
            {
                content
            }
        }
    }
}



