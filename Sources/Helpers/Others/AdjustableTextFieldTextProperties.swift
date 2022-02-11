//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.3
//			
//  File Name: AdjustableTextFieldTextProperties.swift
//  Creation: 5/11/21 10:35 AM
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

class AdjustableTextFieldTextProperties: NSObject, ObservableObject
{
    /// Default start font size.
    public static var defaultFontSize: CGFloat = 50
    public static var defaultMinFontSize: CGFloat = 30
    public static var defaultMaxFontSize: CGFloat = 300
    
    /// Default start font weight.
    public static var defaultFontWeight: Font.Weight = .semibold
    public static var defaultUIFontWeight: UIFont.Weight = .semibold
    public static var defaultFontDesign: Font.Design = .rounded
    public static var defaultUIFontDesign: UIFontDescriptor.SystemDesign = .rounded
    
    public static var defaultText: String = "Text"
    public static var defaultFont: Font = .system(size: defaultFontSize, weight: defaultFontWeight, design: defaultFontDesign)
    public static var defaultForegroundColorProperties: ColorPickerView.ColorProperties = .init()
    public static var defaultPosition: CGPoint = .zero
    public static var defaultRotationAngle: Angle = .zero
    
    @Published public var text: String = AdjustableTextFieldTextProperties.defaultText
    @Published public var fontSize: CGFloat = AdjustableTextFieldTextProperties.defaultFontSize
    @Published public var font: Font = AdjustableTextFieldTextProperties.defaultFont
    @Published public var foregroundColorProperties: ColorPickerView.ColorProperties = AdjustableTextFieldTextProperties.defaultForegroundColorProperties
    @Published public var position: CGPoint = AdjustableTextFieldTextProperties.defaultPosition
    @Published public var rotationAngle: Angle = AdjustableTextFieldTextProperties.defaultRotationAngle
    @Published public var isFocused: Bool = false
    @Published public var index: Int = 0
    
    public var id: String = UUID().uuidString
    
    public required override init()
    {
        
    }
}

extension AdjustableTextFieldTextProperties: NSCopying
{
    // MARK: - Equatable, NSCopying
    
    public static func == (lhs: AdjustableTextFieldTextProperties, rhs: AdjustableTextFieldTextProperties) -> Bool
    {
        return lhs.id == rhs.id &&
            lhs.font == rhs.font &&
            lhs.foregroundColorProperties == rhs.foregroundColorProperties &&
            lhs.position == rhs.position &&
            lhs.rotationAngle == rhs.rotationAngle &&
            lhs.text == rhs.text &&
            lhs.index == rhs.index
    }
    
    public func copy(with zone: NSZone? = nil) -> Any
    {
        let copy = type(of: self).init()
        
        copy.id = self.id
        copy.text = self.text
        copy.fontSize = self.fontSize
        copy.font = self.font
        copy.index = self.index
        copy.foregroundColorProperties = foregroundColorProperties
        copy.position = self.position
        copy.rotationAngle = self.rotationAngle
        copy.isFocused = self.isFocused
        
        return copy
    }
}
