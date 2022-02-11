//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.3
//			
//  File Name: AdjustablePhotoProperties.swift
//  Creation: 5/17/21 11:51 AM
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
import PhotosUI

public class AdjustablePhotoProperties: NSObject, ObservableObject
{
    /// Default start length size.
    public static var defaultLengthSize: CGFloat = defaultMinLengthSize
    public static var defaultMinLengthSize: CGFloat = 80
    public static var defaultMaxLengthSize: CGFloat = UIScreen.minScreenLength
    
    public static var defaultPosition: CGPoint = .zero
    public static var defaultRotationAngle: Angle = .zero
    
    @Published public var photo: PHAsset? = nil
    @Published public var lengthSize: CGFloat = AdjustablePhotoProperties.defaultLengthSize
    @Published public var position: CGPoint = AdjustablePhotoProperties.defaultPosition
    @Published public var rotationAngle: Angle = AdjustablePhotoProperties.defaultRotationAngle
    @Published public var index: Int = 0
    
    public var id: String = UUID().uuidString
    
    public required override init()
    {
        
    }
}

extension AdjustablePhotoProperties: NSCopying
{
    // MARK: - Equatable, NSCopying
    
    public static func == (lhs: AdjustablePhotoProperties, rhs: AdjustablePhotoProperties) -> Bool
    {
        return lhs.id == rhs.id &&
            lhs.photo == rhs.photo &&
            lhs.lengthSize == rhs.lengthSize &&
            lhs.position == rhs.position &&
            lhs.rotationAngle == rhs.rotationAngle &&
            lhs.index == rhs.index
    }
    
    public func copy(with zone: NSZone? = nil) -> Any
    {
        let copy = type(of: self).init()
        
        copy.id = self.id
        copy.photo = self.photo
        copy.lengthSize = self.lengthSize
        copy.index = self.index
        copy.position = self.position
        copy.rotationAngle = self.rotationAngle
        
        return copy
    }
}

