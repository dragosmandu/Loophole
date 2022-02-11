//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: ImageAnimator.swift
//  Creation: 4/19/21 3:56 PM
//
//  Company: Thecircle LLC 
//  Contact: dev@thecircle.xyz
//  Website: https://thecircle.xyz
//  Author: Dragos-Costin Mandu
//
//  Copyright © 2021 Thecircle LLC. All rights reserved.
//
//
	

import AVFoundation
import UIKit

class ImageAnimator
{
    static let kTimescale: Int32 = 600
    
    private let renderSettings: RenderSettings
    private let videoWriter: VideoWriter
    private var imageURLs: [URL]
    private var frameNum = 0
    
    init(imageURLs: [URL], renderSettings: RenderSettings)
    {
        self.imageURLs = imageURLs
        self.renderSettings = renderSettings
        
        videoWriter = VideoWriter(renderSettings: renderSettings)
    }
    
    func render(_ completion: @escaping (_ success: Bool) -> Void)
    {
        guard let outputURL = renderSettings.outputURL
        else
        {
            completion(false)
            return
        }
        
        try? FileManager.default.removeItem(atPath: outputURL.path)
        
        videoWriter.start
        { success in
            if success
            {
                self.videoWriter.render(appendPixelBuffers: self.appendPixelBuffers)
                { success in
                    completion(success)
                }
            }
            else
            {
                completion(success)
            }
        }
    }
    
    func appendPixelBuffers(writer: VideoWriter) -> Bool
    {
        let frameDuration = CMTimeMake(value: Int64(ImageAnimator.kTimescale / renderSettings.fps), timescale: ImageAnimator.kTimescale)
        
        while !imageURLs.isEmpty
        {
            if !writer.isReadyForData
            {
                return false
            }
            
            let currentImageURL = imageURLs.removeFirst()
            let presentationTime = CMTimeMultiply(frameDuration, multiplier: Int32(frameNum))
            let success = videoWriter.addImageFrom(imageURL: currentImageURL, withPresentationTime: presentationTime)
            
            frameNum += success ? 1 : 0
        }
        
        return true
    }
}
