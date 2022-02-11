//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: AdjustableTextFieldView.swift
//  Creation: 4/11/21 11:53 AM
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

struct AdjustableTextFieldView: View
{
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @ObservedObject public var textProperties: AdjustableTextFieldTextProperties = .init()
    @ObservedObject private var keyboard: Keyboard = .init()
    
    @State private var text: String = AdjustableTextFieldTextProperties.defaultText
    @State private var font: Font = AdjustableTextFieldTextProperties.defaultFont
    @State private var foregroundColorProperties: ColorPickerView.ColorProperties = AdjustableTextFieldTextProperties.defaultForegroundColorProperties
    @State private var currentPosition: CGPoint = AdjustableTextFieldTextProperties.defaultPosition
    @State private var currentRotationAngle: Angle = AdjustableTextFieldTextProperties.defaultRotationAngle
    @State private var fontSize: CGFloat = AdjustableTextFieldTextProperties.defaultFontSize
    @State private var animation: Animation? = nil
    
    @State private var previousRotationAngle: Angle? = nil
    @State private var previousFontSize: CGFloat? = nil
    @State private var previousPosition: CGPoint? = nil
    @State private var isHidden: Bool = false
    @State private var isFocused: Bool = false
    
    @Binding private var adjustableTextFieldViews: [AdjustableTextFieldView]
    @Binding private var didFocusAdjustableTextField: Bool
    
    /// Any rotation, position or font size change will set this value to true.
    @State private var isAdjustingTextField: Bool = false
    
    public init(adjustableTextFieldViews: Binding<[AdjustableTextFieldView]>, didFocusAdjustableTextField: Binding<Bool>)
    {
        _adjustableTextFieldViews = adjustableTextFieldViews
        _didFocusAdjustableTextField = didFocusAdjustableTextField
    }
    
    public var body: some View
    {
        if !isHidden
        {
            GeometryReader
            { proxy in
                Group
                {
                    let isFocusedPosition = CGPoint(x: proxy.size.width / 2, y: proxy.size.height - (keyboard.rect.height + fontSize / 2 + MarginModifier.marginSize))
                    let position = isFocused ? isFocusedPosition : currentPosition
                    let rotation = isFocused ? .zero : currentRotationAngle
                    
                    ZStack(alignment: .topTrailing)
                    {
                        TextFieldView(text: $text, font: $font, foregroundColor: .constant(foregroundColorProperties.color), placeholder: "")
                        { isFocused in
                            onChangeFocusAction(isFocused)
                        }
                        onCommitAction:
                        {
                            onCommitAction()
                        }
                        .fixedSize(horizontal: isFocused ? false : true, vertical: true)
                        .margin(.horizontal, factor: isFocused ? 0 : 2)
                        
                        // Margin for color picker. Text field 1 factor, color picker 1 factor.
                        .margin(.trailing, factor: isFocused ? 2 : 0)
                        
                        if !isFocused
                        {
                            DeleteOverlayElementButtonView(isDisabled: $isAdjustingTextField)
                            {
                                isHidden = true
                                cleanTextField()
                                didFocusAdjustableTextField = false
                            }
                        }
                    }
                    
                    // Padding to avoid the color picker.
                    .padding(.trailing, isFocused ? Constant.fontSize * 1.35 : 0.0)
                    .background(colorScheme.black.opacity(0.001))
                    .rotationEffect(rotation, anchor: .center)
                    .position(position)
                    .animation(animation)
                    .onTapGesture { }
                    .simultaneousGesture(isFocused ? nil : dragGesture)
                    .simultaneousGesture(isFocused ? nil : magnificationGesture)
                    .simultaneousGesture(isFocused ? nil : rotationGesture)
                    .onChange(of: text)
                    { text in
                        if textProperties.text != text
                        {
                            textProperties.text = text
                        }
                    }
                    .onChange(of: foregroundColorProperties)
                    { foregroundColorProperties in
                        if textProperties.foregroundColorProperties != foregroundColorProperties
                        {
                            textProperties.foregroundColorProperties = foregroundColorProperties
                        }
                    }
                    .onChange(of: textProperties.foregroundColorProperties)
                    { foregroundColorProperties in
                        if self.foregroundColorProperties != foregroundColorProperties
                        {
                            self.foregroundColorProperties = foregroundColorProperties
                        }
                    }
                    .onAppear
                    {
                        if currentPosition == .zero
                        {
                            
                            let startPosition = CGPoint(x: proxy.size.width / 2, y: proxy.size.height / 2)
                            
                            currentPosition = startPosition
                            textProperties.position = startPosition
                        }
                    }
                }
                .background(backgroundBlockerView)
                
                if isFocused
                {
                    colorPickerViewIn(proxy: proxy)
                        .transition()
                }
            }
            .transition()
        }
    }
    
    private func onCommitAction()
    {
        if text.contains(" ")
        {
            let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
            
            self.text = trimmedText
        }
        
        if text.isEmpty
        {
            cleanTextField()
            isHidden = true
        }
        
        self.isFocused = false
        didFocusAdjustableTextField = false
        textProperties.isFocused = false
    }
    
    private func onChangeFocusAction(_ isFocused: Bool)
    {
        if isHidden
        {
            return
        }
        
        if isFocused
        {
            bringCurrentTextFieldViewInFront()
            animation = .viewInsertionAnimation
        }
        else
        {
            animation = .viewRemovalAnimation
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Animation.viewRemovalDelay + Animation.viewRemovalDuration)
            {
                animation = nil
            }
        }
        
        if isFocused && text == AdjustableTextFieldTextProperties.defaultText
        {
            text = .empty // Removes all the text when focused.
        }
        else if text.isEmpty
        {
            cleanTextField()
            isHidden = true
        }
        
        self.isFocused = isFocused
        didFocusAdjustableTextField = isFocused
        textProperties.isFocused = isFocused
    }
    
    private var backgroundBlockerView: some View
    {
        Group
        {
            if isFocused
            {
                colorScheme.black
                    .transparent()
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture
                    {
                        self.hideKeyboard()
                    }
                    .transition()
            }
        }
    }
    
    private func colorPickerViewIn(proxy: GeometryProxy) -> some View
    {
        let colorPickerWidth = Constant.fontSize * 1.35
        let colorPickerHeight = proxy.size.height - keyboard.rect.height - 2 * MarginModifier.marginSize
        
        return HStack(alignment: .center, spacing: 0)
        {
            Spacer()
            
            ColorPickerView(selectedColorProperties: $foregroundColorProperties)
                .frame(width: colorPickerWidth, height: colorPickerHeight, alignment: .center)
                .animation(.spring())
        }
        .margin(.all)
    }
    
    private func cleanTextField()
    {
        adjustableTextFieldViews = adjustableTextFieldViews.filter
        {
            
            // Removes current text field.
            !($0.textProperties.id == textProperties.id)
        }
    }
    
    private func bringCurrentTextFieldViewInFront()
    {
        
        // Returns the text field views with a different index than the current text field view.
        adjustableTextFieldViews = adjustableTextFieldViews.filter
        {
            if $0.textProperties.index != textProperties.index
            {
                
                // The text field views with a higher index then the current text field view index will move down with 1 index as we remove the current one.
                if $0.textProperties.index > textProperties.index
                {
                    $0.textProperties.index -= 1
                }
                
                return true
            }
            
            return false
        }
        adjustableTextFieldViews.append(self)
        textProperties.index = adjustableTextFieldViews.count - 1
    }
}

extension AdjustableTextFieldView: Hashable
{
    // MARK: - Hashable
    
    public func hash(into hasher: inout Hasher)
    {
        hasher.combine(textProperties.id)
    }
    
    public static func == (lhs: AdjustableTextFieldView, rhs: AdjustableTextFieldView) -> Bool
    {
        return lhs.textProperties.id == rhs.textProperties.id
    }
}

extension AdjustableTextFieldView
{
    // MARK: - Gestures
    
    private var dragGesture: _EndedGesture<_ChangedGesture<DragGesture>>
    {
        DragGesture(minimumDistance: 1, coordinateSpace: .global)
            .onChanged
            { value in
                if !isAdjustingTextField
                {
                    isAdjustingTextField = true
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
                textProperties.position = currentPosition
                isAdjustingTextField = false
            }
    }
    
    private var rotationGesture: _EndedGesture<_ChangedGesture<RotationGesture>>
    {
        RotationGesture(minimumAngleDelta: .init(degrees: 0))
            .onChanged
            { angle in
                if !isAdjustingTextField
                {
                    isAdjustingTextField = true
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
                textProperties.rotationAngle = currentRotationAngle
                isAdjustingTextField = false
            }
    }
    
    private var magnificationGesture: _EndedGesture<_ChangedGesture<MagnificationGesture>>
    {
        MagnificationGesture(minimumScaleDelta: 0)
            .onChanged
            { (value) in
                if !isAdjustingTextField
                {
                    isAdjustingTextField = true
                }
                
                if previousFontSize == nil
                {
                    previousFontSize = fontSize
                }
                
                let newFontSize = previousFontSize! * value
                
                if newFontSize >= AdjustableTextFieldTextProperties.defaultMinFontSize && newFontSize <= AdjustableTextFieldTextProperties.defaultMaxFontSize
                {
                    let newFont: Font = .system(size: newFontSize, weight: AdjustableTextFieldTextProperties.defaultFontWeight, design: AdjustableTextFieldTextProperties.defaultFontDesign)
                    
                    textProperties.fontSize = newFontSize
                    fontSize = newFontSize
                    font = newFont
                }
            }
            .onEnded
            { _ in
                previousFontSize = nil
                textProperties.font = font
                isAdjustingTextField = false
            }
    }
}
