//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: Data+Ext.swift
//  Creation: 4/9/21 1:20 PM
//
//  Company: Thecircle LLC 
//  Contact: dev@thecircle.xyz
//  Website: https://thecircle.xyz
//  Author: Dragos-Costin Mandu
//
//  Copyright © 2021 Thecircle LLC. All rights reserved.
//
//


import Foundation
import CryptoKit
import ImageIO

public extension Data
{
    // MARK: - Constants & Variables
    
    /// The SHA1 hash string representation of the current Data.
    /// Don't use it for cryptographic meanings.
    var sha1HashString: String
    {
        let digest = Insecure.SHA1.hash(data: self)
        
        return digest.map
        {
            String(format: "%02hhx", $0)
        }
        .joined()
    }
}

public extension Data
{
    // MARK: - Methods
    
    /// Resizing the image at given index from a image source with current data.
    /// - Parameters:
    ///   - thumbnailMaxPixelSize: The maximum width and height in pixels of a thumbnail.
    ///   - index: The index that specifies the location of the image. The index is zero-based.
    /// - Returns: The downsampled CGImage.
    ///
    /// If the maximum size isn't provided, the maximum size may be as the original.
    ///
    func downsampleImage(thumbnailMaxPixelSize: CGFloat? = nil, imageIndex: Int = 0) -> CGImage?
    {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        
        guard let imageSource = CGImageSourceCreateWithData(self as CFData, imageSourceOptions)
        else
        {
            return nil
        }
        
        return imageSource.downsample(thumbnailMaxPixelSize: thumbnailMaxPixelSize, imageIndex: imageIndex)
    }
}
