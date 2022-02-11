//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.3
//			
//  File Name: AdjustableStickerView.swift
//  Creation: 5/11/21 10:25 AM
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

public struct AdjustableStickerView: View
{
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @ObservedObject public var stickerProperties: AdjustableStickerProperties = .init()
    
    @State private var font: Font = AdjustableStickerProperties.defaultFont
    @State private var currentPosition: CGPoint = AdjustableStickerProperties.defaultPosition
    @State private var currentRotationAngle: Angle = AdjustableStickerProperties.defaultRotationAngle
    @State private var fontSize: CGFloat = AdjustableStickerProperties.defaultFontSize
    
    @State private var previousRotationAngle: Angle? = nil
    @State private var previousFontSize: CGFloat? = nil
    @State private var previousPosition: CGPoint? = nil
    
    /// Any rotation, position or font size change will set this value to true.
    @State private var isAdjustingSticker: Bool = false
    @State private var isHidden: Bool = false
    
    @Binding private var adjustableStickerViews: [AdjustableStickerView]
    
    public init(adjustableStickerViews: Binding<[AdjustableStickerView]>, sticker: Sticker)
    {
        _adjustableStickerViews = adjustableStickerViews
        
        stickerProperties.sticker = sticker
    }
    
    public var body: some View
    {
        if !isHidden
        {
            GeometryReader
            { proxy in
                if let sticker = stickerProperties.sticker
                {
                    ZStack(alignment: .topTrailing)
                    {
                        StickerView(font: $font, sticker: sticker)
                            .fixedSize(horizontal: true, vertical: true)
                            .margin(.all, factor: 1)
                        
                        DeleteOverlayElementButtonView(isDisabled: $isAdjustingSticker)
                        {
                            isHidden = true // Hidding the sticker in order to delete it from array.
                            
                            for (index, adjustableStickerView) in adjustableStickerViews.enumerated()
                            {
                                if adjustableStickerView.stickerProperties == stickerProperties
                                {
                                    adjustableStickerViews.remove(at: index)
                                }
                            }
                        }
                    }
                    .background(colorScheme.black.opacity(0.001))
                    .rotationEffect(currentRotationAngle, anchor: .center)
                    .position(currentPosition)
                    .onTapGesture { }
                    .simultaneousGesture(dragGesture)
                    .simultaneousGesture(magnificationGesture)
                    .simultaneousGesture(rotationGesture)
                    .onAppear
                    {
                        if currentPosition == .zero
                        {
                            
                            let startPosition = CGPoint(x: proxy.size.width / 2, y: proxy.size.height / 2)
                            
                            currentPosition = startPosition
                            stickerProperties.position = startPosition
                        }
                    }
                    .transition()
                }
            }
            .onAppear
            {
                if stickerProperties.sticker == nil
                {
                    isHidden = true
                }
            }
            .transition()
        }
    }
}

extension AdjustableStickerView: Hashable
{
    // MARK: - Hashable
    
    public func hash(into hasher: inout Hasher)
    {
        hasher.combine(stickerProperties.id)
    }
    
    public static func == (lhs: AdjustableStickerView, rhs: AdjustableStickerView) -> Bool
    {
        return lhs.stickerProperties.id == rhs.stickerProperties.id
    }
}

extension AdjustableStickerView
{
    // MARK: - Gestures
    
    private var dragGesture: _EndedGesture<_ChangedGesture<DragGesture>>
    {
        DragGesture(minimumDistance: 1, coordinateSpace: .global)
            .onChanged
            { value in
                if !isAdjustingSticker
                {
                    isAdjustingSticker = true
                }
                
                if previousPosition == nil
                {
                    previousPosition = currentPosition
                }
                
                let newPositionX = previousPosition!.x + value.translation.width
                let newPositionY = previousPosition!.y + value.translation.height
                
                currentPosition = CGPoint(x: newPositionX, y: newPositionY)
            }
            .onEnded
            { _ in
                previousPosition = nil
                stickerProperties.position = currentPosition
                isAdjustingSticker = false
            }
    }
    
    private var rotationGesture: _EndedGesture<_ChangedGesture<RotationGesture>>
    {
        RotationGesture(minimumAngleDelta: .init(degrees: 0))
            .onChanged
            { angle in
                if !isAdjustingSticker
                {
                    isAdjustingSticker = true
                }
                
                if previousRotationAngle == nil
                {
                    previousRotationAngle = currentRotationAngle
                }
                
                
                let roundedPreviousRotationDeg = previousRotationAngle!.degrees.roundWith(fractionDigits: 3)
                let roundedDeg = angle.degrees.roundWith(fractionDigits: 3)
                var newRotationAngle: Angle = .init(degrees: roundedPreviousRotationDeg + roundedDeg)
                let remainder = newRotationAngle.degrees.truncatingRemainder(dividingBy: 90)
                
                if remainder <= 5 && remainder >= -5
                {
                    newRotationAngle = .init(degrees: newRotationAngle.degrees - remainder) // Snaps in clockwise.
                }
                else if remainder >= 85 || remainder <= -85
                {
                    let remainder = 90 - abs(remainder)
                    
                    if newRotationAngle.degrees > 0
                    {
                        newRotationAngle = .init(degrees: newRotationAngle.degrees + remainder) // Snaps in counter-clockwise when -.
                    }
                    else
                    {
                        newRotationAngle = .init(degrees: newRotationAngle.degrees - remainder) // Snaps in counter-clockwise when +.
                    }
                }
                
                currentRotationAngle = newRotationAngle
            }
            .onEnded
            { _ in
                previousRotationAngle = nil
                stickerProperties.rotationAngle = currentRotationAngle
                isAdjustingSticker = false
            }
    }
    
    private var magnificationGesture: _EndedGesture<_ChangedGesture<MagnificationGesture>>
    {
        MagnificationGesture(minimumScaleDelta: 0)
            .onChanged
            { (value) in
                if !isAdjustingSticker
                {
                    isAdjustingSticker = true
                }
                
                if previousFontSize == nil
                {
                    previousFontSize = fontSize
                }
                
                let newFontSize = previousFontSize! * value
                
                if newFontSize >= AdjustableStickerProperties.defaultMinFontSize && newFontSize <= AdjustableStickerProperties.defaultMaxFontSize
                {
                    let newFont: Font = .system(size: newFontSize)
                    
                    stickerProperties.fontSize = newFontSize
                    fontSize = newFontSize
                    font = newFont
                }
            }
            .onEnded
            { _ in
                previousFontSize = nil
                stickerProperties.font = font
                isAdjustingSticker = false
            }
    }
}
