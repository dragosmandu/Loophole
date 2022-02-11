//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: CreateLoopWithOptions.swift
//  Creation: 4/19/21 12:57 PM
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

func createLoopWithOptions(size: CGSize, captureFileType: CaptureButtonView.CaptureFileType, frameFileURLs: [URL], interFrameDelay: Double, _ completion: @escaping ( _ animatedImageFileURL: URL?) -> Void)
{
    
    // Check if we have only one frame, in order to save it as a static image.
    if frameFileURLs.count == 1
    {
        let thumbnailMaxPixelSize = max(size.width, size.height)
        var imageFileURL: URL? = nil
        
        if let frameData = try? Data(contentsOf: frameFileURLs[0]), let downsampledCGImage = frameData.downsampleImage(thumbnailMaxPixelSize: thumbnailMaxPixelSize, imageIndex: 0), let downsampledFrameData = downsampledCGImage.jpegData, let _imageFileURL = FileManager.createFile(contentType: .jpeg, data: downsampledFrameData)
        {
            imageFileURL = _imageFileURL
        }
        
        completion(imageFileURL)
    }
    else
    {
        if captureFileType == .gif
        {
            let frameMaxPixelSize = max(size.width, size.height)
            
            if let animatedImageFileURL = UIImage.animatedImageWith(frames: frameFileURLs, frameMaxPixelSize: frameMaxPixelSize, interFrameDelay: interFrameDelay)
            {
                completion(animatedImageFileURL)
            }
        }
        else
        {
            let renderSettings = RenderSettings(size: size, fps: Int32(1 / interFrameDelay))
            let animator = ImageAnimator(imageURLs: frameFileURLs, renderSettings: renderSettings)
            
            animator.render
            { _ in
                completion(renderSettings.outputURL)
            }
        }
    }
}
