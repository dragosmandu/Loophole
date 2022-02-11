//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: CGImageSource+Ext.swift
//  Creation: 4/9/21 1:30 PM
//
//  Company: Thecircle LLC 
//  Contact: dev@thecircle.xyz
//  Website: https://thecircle.xyz
//  Author: Dragos-Costin Mandu
//
//  Copyright © 2021 Thecircle LLC. All rights reserved.
//
//


import ImageIO

public extension CGImageSource
{
    // MARK: - Methods
    
    /// Resizing the image at given index in current CGImageSource.
    /// - Parameters:
    ///   - thumbnailMaxPixelSize: The maximum width and height in pixels of a thumbnail.
    ///   - index: The index that specifies the location of the image. The index is zero-based.
    /// - Returns: The downsampled CGImage.
    ///
    /// If the maximum size isn't provided, the maximum size may be as the original.
    ///
    func downsample(thumbnailMaxPixelSize: CGFloat? = nil, imageIndex: Int = 0) -> CGImage?
    {
        var downsampleOptions =
            [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceShouldCacheImmediately: true,
                kCGImageSourceCreateThumbnailWithTransform: true
            ] as CFDictionary
        
        if let thumbnailMaxPixelSize = thumbnailMaxPixelSize
        {
            downsampleOptions = [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceShouldCacheImmediately: true,
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceThumbnailMaxPixelSize: thumbnailMaxPixelSize
            ] as CFDictionary
        }
        
        return CGImageSourceCreateThumbnailAtIndex(self, imageIndex, downsampleOptions)
    }
}

