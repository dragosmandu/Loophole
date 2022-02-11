//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: UIImage+Ext.swift
//  Creation: 4/9/21 1:10 PM
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
import AVFoundation
import MobileCoreServices

public extension UIImage
{
    // MARK: - Constants & Variables
    
    static var animatedImageDefaultInterFrameDelay: Double = 0.1
    static var animatedImageDefaultLoopCount: Int = 0
}

public extension UIImage
{
    // MARK: - Methods
    
    /// Creates an animated image from given CGImageSource.
    /// - Parameters:
    ///   - frameMaxPixelSize: The maximum width and height in pixels of a thumbnail.
    ///   - frameCompresionQuality: The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality).
    ///   - interFrameDelay: The delay between 2 frames. Set only when the animated image Data doesn't have a delay already.
    static func animatedImageWith(imageSource: CGImageSource, frameMaxPixelSize: CGFloat? = nil, frameCompresionQuality: CGFloat = 1, interFrameDelay: Double = UIImage.animatedImageDefaultInterFrameDelay) -> UIImage?
    {
        let count = CGImageSourceGetCount(imageSource)
        var delay = interFrameDelay
        
        if let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as Dictionary?
        {
            if let delayTime = properties[kCGImagePropertyGIFDictionary as NSString]?[kCGImagePropertyGIFDelayTime as NSString]
            {
                if let delayTime = delayTime as? NSNumber
                {
                    delay = Double(truncating: delayTime)
                }
            }
        }
        
        var frames = [UIImage]()
        let duration = Double(count) * delay
        
        for index in 0..<count
        {
            if let cgImage = imageSource.downsample(thumbnailMaxPixelSize: frameMaxPixelSize, imageIndex: index)
            {
                var uiImage = UIImage(cgImage: cgImage)
                
                if frameCompresionQuality < 1, let compressedUIImageData = uiImage.jpegData(compressionQuality: frameCompresionQuality), let compressedUIImage = UIImage(data: compressedUIImageData)
                {
                    uiImage = compressedUIImage
                }
                
                frames.append(uiImage)
            }
        }
        
        return UIImage.animatedImage(with: frames, duration: duration)
    }
    
    /// Creates an animated image from given file URL.
    /// - Parameters:
    ///   - url: The file URL where the animated image is located.
    ///   - frameMaxPixelSize: The maximum width and height in pixels of a thumbnail.
    ///   - frameCompresionQuality: The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality).
    ///   - interFrameDelay: The delay between 2 frames. Set only when the animated image Data doesn't have a delay already.
    static func animatedImageWith(url: URL, frameMaxPixelSize: CGFloat? = nil, frameCompresionQuality: CGFloat = 1, interFrameDelay: Double = UIImage.animatedImageDefaultInterFrameDelay) -> UIImage?
    {
        guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil)
        else
        {
            return nil
        }
        
        return animatedImageWith(imageSource: imageSource, frameMaxPixelSize: frameMaxPixelSize, frameCompresionQuality: frameCompresionQuality, interFrameDelay: interFrameDelay)
    }
    
    /// Creates an animated image from given Data.
    /// - Parameters:
    ///   - frameMaxPixelSize: The maximum width and height in pixels of a thumbnail.
    ///   - frameCompresionQuality: The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality).
    ///   - interFrameDelay: The delay between 2 frames. Set only when the animated image Data doesn't have a delay already.
    static func animatedImageWith(data: Data, frameMaxPixelSize: CGFloat? = nil, frameCompresionQuality: CGFloat = 1, interFrameDelay: Double = UIImage.animatedImageDefaultInterFrameDelay) -> UIImage?
    {
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil)
        else
        {
            return nil
        }
        
        return animatedImageWith(imageSource: imageSource, frameMaxPixelSize: frameMaxPixelSize, frameCompresionQuality: frameCompresionQuality, interFrameDelay: interFrameDelay)
    }
    
    /// Creates the animated image by arranging the frames (CGImageSource) in order with a given delay between them.
    /// - Parameters:
    ///   - frames: The image sources for each frame of the animated image.
    ///   - frameMaxPixelSize: The maximum width and height in pixels of each thumbnail.
    ///   - interFrameDelay: The delay between 2 frames. Set only when the animated image Data doesn't have a delay already.
    ///   - loopCount: The number of times the animated image loops. Zero means infinite.
    static func animatedImageWith(frames: [CGImageSource], frameMaxPixelSize: CGFloat? = nil, interFrameDelay: Double = UIImage.animatedImageDefaultInterFrameDelay, loopCount: Int = UIImage.animatedImageDefaultLoopCount) -> URL?
    {
        let fileProperties: CFDictionary =
            [
                kCGImagePropertyGIFDictionary as String:
                    [
                        kCGImagePropertyGIFLoopCount as String: loopCount
                    ]
            ]  as CFDictionary
        let frameProperties: CFDictionary =
            [
                kCGImagePropertyGIFDictionary as String:
                    [
                        kCGImagePropertyGIFDelayTime as String: interFrameDelay
                    ]
            ] as CFDictionary
        
        let fileURL = FileManager.createFile(contentType: .gif, directory: .cachesDirectory, domainMask: .userDomainMask)
        
        if let url = fileURL as CFURL?
        {
            if let destination = CGImageDestinationCreateWithURL(url, kUTTypeGIF, frames.count, nil)
            {
                CGImageDestinationSetProperties(destination, fileProperties)
                
                for frame in frames
                {
                    CGImageDestinationAddImageFromSource(destination, frame, 0, frameProperties)
                }
                
                if !CGImageDestinationFinalize(destination)
                {
                    return nil
                }
                
                return fileURL
            }
        }
        
        return nil
    }
    
    /// Creates the animated image by arranging the frames (Data) in order with a default delay between them, looping by loopCount.
    /// - Parameters:
    ///   - frames: The frames as Data to construct the animated image.
    ///   - frameMaxPixelSize: The maximum width and height in pixels of each thumbnail.
    ///   - interFrameDelay: The delay between 2 frames. Set only when the animated image Data doesn't have a delay already.
    ///   - loopCount: The number of times the animated image loops. Zero means infinite.
    static func animatedImageWith(frames: [Data], frameMaxPixelSize: CGFloat? = nil, interFrameDelay: Double = UIImage.animatedImageDefaultInterFrameDelay, loopCount: Int = UIImage.animatedImageDefaultLoopCount) -> URL?
    {
        var imageSources: [CGImageSource] = []
        
        for frameData in frames
        {
            if let imageSource = CGImageSourceCreateWithData(frameData as CFData, nil)
            {
                imageSources.append(imageSource)
            }
        }
        
        return animatedImageWith(frames: imageSources, frameMaxPixelSize: frameMaxPixelSize, interFrameDelay: interFrameDelay, loopCount: loopCount)
    }
    
    /// Creates the animated image by arranging the frames (CGImage) in order with a default delay between them, looping by loopCount.
    /// - Parameters:
    ///   - frames: The frames as CGImage to construct the animated image.
    ///   - frameMaxPixelSize: The maximum width and height in pixels of each thumbnail.
    ///   - interFrameDelay: The delay between 2 frames. Set only when the animated image Data doesn't have a delay already.
    ///   - loopCount: The number of times the animated image loops. Zero means infinite.
    static func animatedImageWith(frames: [CGImage], frameMaxPixelSize: CGFloat? = nil, interFrameDelay: Double = UIImage.animatedImageDefaultInterFrameDelay, loopCount: Int = UIImage.animatedImageDefaultLoopCount) -> URL?
    {
        var imageSources: [CGImageSource] = []
        
        for frame in frames
        {
            if let frameData = frame.jpegData
            {
                if let imageSource = CGImageSourceCreateWithData(frameData as CFData, nil)
                {
                    imageSources.append(imageSource)
                }
            }
        }
        
        return animatedImageWith(frames: imageSources, frameMaxPixelSize: frameMaxPixelSize, interFrameDelay: interFrameDelay, loopCount: loopCount)
    }
    
    /// Creates the animated image by arranging the frames (UIImage) in order with a default delay between them, looping by loopCount.
    /// - Parameters:
    ///   - frames: The frames as UIImage to construct the animated image.
    ///   - frameMaxPixelSize: The maximum width and height in pixels of each thumbnail.
    ///   - interFrameDelay: The delay between 2 frames. Set only when the animated image Data doesn't have a delay already.
    ///   - loopCount: The number of times the animated image loops. Zero means infinite.
    static func animatedImageWith(frames: [UIImage], frameMaxPixelSize: CGFloat? = nil, interFrameDelay: Double = UIImage.animatedImageDefaultInterFrameDelay, loopCount: Int = UIImage.animatedImageDefaultLoopCount) -> URL?
    {
        var imageSources: [CGImageSource] = []
        
        for frame in frames
        {
            if let frameData = frame.jpegData(compressionQuality: 1)
            {
                if let imageSource = CGImageSourceCreateWithData(frameData as CFData, nil)
                {
                    imageSources.append(imageSource)
                }
            }
        }
        
        return animatedImageWith(frames: imageSources, frameMaxPixelSize: frameMaxPixelSize, interFrameDelay: interFrameDelay, loopCount: loopCount)
    }
    
    /// Creates the animated image by arranging the frames (URL) in order with a default delay between them, looping by loopCount.
    /// - Parameters:
    ///   - frames: The locations for each frame for animated image.
    ///   - frameMaxPixelSize: The maximum width and height in pixels of each thumbnail.
    ///   - interFrameDelay: The delay between 2 frames. Set only when the animated image Data doesn't have a delay already.
    ///   - loopCount: The number of times the animated image loops. Zero means infinite.
    static func animatedImageWith(frames: [URL], frameMaxPixelSize: CGFloat? = nil, interFrameDelay: Double = UIImage.animatedImageDefaultInterFrameDelay, loopCount: Int = UIImage.animatedImageDefaultLoopCount) -> URL?
    {
        var imageSources: [CGImageSource] = []
        
        for frameFileURL in frames
        {
            if let imageSource = CGImageSourceCreateWithURL(frameFileURL as CFURL, nil)
            {
                imageSources.append(imageSource)
            }
        }
        
        return animatedImageWith(frames: imageSources, frameMaxPixelSize: frameMaxPixelSize, interFrameDelay: interFrameDelay, loopCount: loopCount)
    }
    
    /// Draws a given text on the current image with given attributes.
    /// - Parameters:
    ///   - location: The CGPoint of the text's location.
    ///   - rotationAngleRad: Text's rotation angle in radians.
    /// - Returns: The image with the text drawn over, nil if fails.
    func drawText(_ text: String, font: UIFont, color: UIColor, location: CGPoint, rotationAngleRad: CGFloat = .zero) -> UIImage?
    {
        if text != .empty
        {
            UIGraphicsBeginImageContextWithOptions(size, false, 1)
            
            self.draw(in: CGRect(origin: CGPoint.zero, size: size))
            
            let textDrawSucceeded = text.drawTextWith(font: font, color: color, location: location, rotationAngleRad: rotationAngleRad)
            
            guard textDrawSucceeded, let textImage = UIGraphicsGetImageFromCurrentImageContext()
            else
            {
                return nil
            }
            
            UIGraphicsEndImageContext()
            
            return textImage
        }
        
        return self
    }
    
    /// Draws a given UIImage on the current image with given attributes.
    /// - Parameters:
    ///   - location: The CGPoint of the UIImage's location.
    ///   - rotationAngleRad: UIImage's rotation angle in radians.
    /// - Returns: The image with the given UIImage drawn over, nil if fails.
    func drawImage(_ uiImage: UIImage, location: CGPoint, rotationAngleRad: CGFloat = .zero) -> UIImage?
    {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        guard let context: CGContext = UIGraphicsGetCurrentContext()
        else
        {
            return nil
        }
        
        let locationTransform: CGAffineTransform = .init(translationX: location.x, y: location.y)
        let rotationTransform: CGAffineTransform = .init(rotationAngle: rotationAngleRad)
        
        context.concatenate(locationTransform)
        context.concatenate(rotationTransform)
        
        uiImage.draw(at: CGPoint(x: -1 * uiImage.size.width / 2, y: -1 * uiImage.size.height / 2))
        
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext()
        else
        {
            return nil
        }
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    /// Adds a filter of given type to the current image.
    /// - Returns: The image with added filter or nil.
    func addFilter(filterType: CIFilter.FilterType) -> UIImage?
    {
        let ciImage: CIImage!
        
        if self.ciImage != nil
        {
            ciImage = self.ciImage
        }
        else if let createdCIImage = CIImage(image: self)
        {
            ciImage = createdCIImage
        }
        else
        {
            return nil
        }
        
        guard let cgImage = ciImage.addFilter(filterType: filterType)
        else
        {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
}
