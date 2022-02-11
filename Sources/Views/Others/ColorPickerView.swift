//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: ColorPickerView.swift
//  Creation: 4/13/21 9:22 AM
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

public struct ColorPickerView: View
{
    public static var animationSpeed: Double = 3
    public static var colorsSaturation: Double = 0.7
    
    /// The extra offset ratio needed for the drag to detect a black or a white color.
    /// (-) for white (+) for black.
    public static var whiteBlackExtraOffsetRatio: CGFloat = 0.1
    
    public static var maxColorsHue = 299
    public static var maxGraysBrightness = 99
    
    private var colors: [Color]
    {
        let colorsHueVals = Array(0...ColorPickerView.maxColorsHue)
        
        let colors: [Color] = colorsHueVals.map
        {
            return .init(hue: Double($0) / Double(ColorPickerView.maxColorsHue), saturation: ColorPickerView.colorsSaturation, brightness: 1.0, opacity: 1.0)
        }
        
        return colors
    }
    
    private var grays: [Color]
    {
        let graysBrightnessVals = Array(0...ColorPickerView.maxGraysBrightness).reversed()
        
        let grays: [Color] = graysBrightnessVals.map
        {
            return .init(hue: 0, saturation: 0, brightness: Double($0) / (Double(ColorPickerView.maxGraysBrightness) + 1), opacity: 1.0)
        }
        
        return grays
    }
    
    private var animation: Animation
    {
        Animation
            .spring()
            .speed(ColorPickerView.animationSpeed)
    }
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @State private var selectedColor: Color = .white
    @State private var isDragging: Bool = false
    @State private var startLocation: CGFloat = .zero
    @State private var dragOffset: CGSize = .zero
    
    @Binding private var selectedColorProperties: ColorProperties
    
    
    public init(selectedColorProperties: Binding<ColorProperties>)
    {
        _selectedColorProperties = selectedColorProperties
    }
    
    public var body: some View
    {
        GeometryReader
        { proxy in
            let circleDiameter = proxy.size.width * 0.9
            let circleLineWidth = circleDiameter * 0.1
            
            ZStack(alignment: .top)
            {
                LinearGradient(gradient: Gradient(colors: grays + colors), startPoint: .top, endPoint: .bottom)
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .cornerRadius(proxy.size.height / 2)
                
                let circleMinScale: CGFloat = 1
                let circleMaxScale: CGFloat = 1.35
                let circleOffsetX = isDragging ? -circleDiameter * circleMaxScale : 0
                let circleOffsetY = getCircleOffsetY(pickerHeight: proxy.size.height, circleDiameter: circleDiameter + circleLineWidth)
                
                Circle()
                    .foregroundColor(currentColorIn(pickerHeight: proxy.size.height))
                    .frame(width: circleDiameter, height: circleDiameter, alignment: .center)
                    .overlay(
                        Circle()
                            .strokeBorder(colorScheme.white, lineWidth: circleLineWidth)
                    )
                    .scaleEffect(isDragging ? circleMaxScale : circleMinScale)
                    .shadow()
                    .offset(x: circleOffsetX, y: circleOffsetY)
                    .animation(animation)
            }
            .contentShape(Rectangle())
            .gesture(dragGestureIn(pickerHeight: proxy.size.height))
            .onChange(of: selectedColorProperties)
            { selectedColorProperties in
                let currentSelectedColorProperties: ColorProperties = .init(dragOffset: dragOffset, startLocation: startLocation, color: selectedColor)
                
                if selectedColorProperties != currentSelectedColorProperties
                {
                    dragOffset = selectedColorProperties.dragOffset
                    startLocation = selectedColorProperties.startLocation
                    selectedColor = selectedColorProperties.color
                }
            }
            .onAppear
            {
                if selectedColorProperties.color == colorScheme.black
                {
                    selectedColorProperties.dragOffset.height = proxy.size.height + proxy.size.height * ColorPickerView.whiteBlackExtraOffsetRatio
                }
                
                dragOffset = selectedColorProperties.dragOffset
                selectedColor = selectedColorProperties.color
                startLocation = selectedColorProperties.startLocation
            }
        }
    }
    
    private func getCircleOffsetY(pickerHeight: CGFloat, circleDiameter: CGFloat) -> CGFloat
    {
        let position = normalizeGestureIn(pickerHeight: pickerHeight)
        
        if position < circleDiameter / 2
        {
            return 0
        }
        
        if position > pickerHeight - circleDiameter / 2
        {
            return pickerHeight - circleDiameter * 0.9
        }
        
        return position - circleDiameter / 2
    }
    
    private func dragGestureIn(pickerHeight: CGFloat) -> _EndedGesture<_ChangedGesture<DragGesture>>
    {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged
            { value in
                if isDragging == false
                {
                    CHHapticEngine.sharedEngine?.play(.fallHapticPattern)
                }
                
                dragOffset = value.translation
                startLocation = value.startLocation.y
                selectedColor = currentColorIn(pickerHeight: pickerHeight)
                isDragging = true
                
                selectedColorProperties.dragOffset = dragOffset
                selectedColorProperties.startLocation = startLocation
                selectedColorProperties.color = selectedColor
            }
            .onEnded
            { _ in
                isDragging = false
            }
    }
    
    private func normalizeGestureIn(pickerHeight: CGFloat) -> CGFloat
    {
        let offset = startLocation + dragOffset.height
        let maxY = max(0, offset)
        let minY = min(maxY, pickerHeight)
        
        return minY
    }
    
    private func currentColorIn(pickerHeight: CGFloat) -> Color
    {
        let minY = normalizeGestureIn(pickerHeight: pickerHeight)
        let graysColorsRatio = CGFloat((colors.count + grays.count) / 100)
        
        if minY < pickerHeight / graysColorsRatio
        {
            return .init(hue: 0, saturation: 0, brightness: 1 - 2 * Double(minY) / 100.0, opacity: 1.0)
        }
        
        let pickerHeightColors = pickerHeight / graysColorsRatio
        let hue = Double((minY - pickerHeightColors) / (pickerHeight - pickerHeightColors))
        
        return .init(hue: hue, saturation: ColorPickerView.colorsSaturation, brightness: 1.0, opacity: 1.0)
    }
}

public extension ColorPickerView
{
    // MARK: - ColorProperties + Equatable
    
    struct ColorProperties: Equatable
    {
        public var dragOffset: CGSize = .zero
        public var startLocation: CGFloat = .zero
        public var color: Color = .white
        
        public static func == (lhs: ColorProperties, rhs: ColorProperties) -> Bool
        {
            return lhs.dragOffset == rhs.dragOffset &&
                lhs.startLocation == rhs.startLocation &&
                lhs.color == rhs.color
        }
    }
}
