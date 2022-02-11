//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: FramesIndicatorView.swift
//  Creation: 4/10/21 10:04 AM
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

struct FramesIndicatorView: View
{
    private var animation: Animation
    {
        let maxDuration: Double = 0.3
        let duration = currentCaptureDelay / 2
        
        return .easeInOut(duration: duration > maxDuration ? maxDuration : duration)
    }
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @State private var previousFrameCounter: Int = 0
    @State private var scale: CGFloat = 1
    
    @Binding private var currentFramesCounter: Int
    @Binding private var currentCaptureDelay: Double
    
    /// - Parameter currentFramesCounter: The total current number of frames taken.
    init(currentFramesCounter: Binding<Int>, currentCaptureDelay: Binding<Double>)
    {
        _currentFramesCounter = currentFramesCounter
        _currentCaptureDelay = currentCaptureDelay
    }
    
    var body: some View
    {
        if currentFramesCounter > 0
        {
            HStack
            {
                if previousFrameCounter != currentFramesCounter
                {
                    let minScale: CGFloat = 1
                    let maxScale: CGFloat = 2
                    let shadowCollor = colorScheme.black.opacity(0.2)
                    let shadowRadius: CGFloat = 5
                    let shadowX: CGFloat = 0
                    let shadowY: CGFloat = 0
                    
                    Text("\(currentFramesCounter)")
                        .scaleEffect(scale)
                        .onAppear
                        {
                            scale = maxScale
                        }
                        .observeAnimation(for: scale)
                        { _ in }
                        endedHandler:
                        {
                            previousFrameCounter = currentFramesCounter
                            scale = minScale
                        }
                        .shadow(color: shadowCollor, radius: shadowRadius, x: shadowX, y: shadowY)
                        .animation(animation)
                }
            }
            .font(Constant.font)
            .foregroundColor(colorScheme.white)
            .transition()
        }
    }
}
