//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.3
//			
//  File Name: AdjustableStickerProperties.swift
//  Creation: 5/11/21 10:47 AM
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

public class AdjustableStickerProperties: NSObject, ObservableObject
{
    /// Default start font size.
    public static var defaultFontSize: CGFloat = 100
    public static var defaultMinFontSize: CGFloat = 80
    public static var defaultMaxFontSize: CGFloat = 300
    
    public static var defaultFont: Font = .system(size: defaultFontSize)
    public static var defaultPosition: CGPoint = .zero
    public static var defaultRotationAngle: Angle = .zero
    
    @Published public var sticker: Sticker? = nil
    @Published public var fontSize: CGFloat = AdjustableStickerProperties.defaultFontSize
    @Published public var font: Font = AdjustableStickerProperties.defaultFont
    @Published public var position: CGPoint = AdjustableStickerProperties.defaultPosition
    @Published public var rotationAngle: Angle = AdjustableStickerProperties.defaultRotationAngle
    @Published public var index: Int = 0
    
    public var id: String = UUID().uuidString
    
    public required override init()
    {
        
    }
}

extension AdjustableStickerProperties: NSCopying
{
    // MARK: - Equatable, NSCopying
    
    public static func == (lhs: AdjustableStickerProperties, rhs: AdjustableStickerProperties) -> Bool
    {
        return lhs.id == rhs.id &&
            lhs.font == rhs.font &&
            lhs.position == rhs.position &&
            lhs.rotationAngle == rhs.rotationAngle &&
            lhs.sticker == rhs.sticker &&
            lhs.index == rhs.index
    }
    
    public func copy(with zone: NSZone? = nil) -> Any
    {
        let copy = type(of: self).init()
        
        copy.id = self.id
        copy.sticker = self.sticker
        copy.fontSize = self.fontSize
        copy.index = self.index
        copy.font = self.font
        copy.position = self.position
        copy.rotationAngle = self.rotationAngle
        
        return copy
    }
}
