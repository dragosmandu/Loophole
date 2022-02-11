//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: VideoWriter.swift
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

class VideoWriter
{
    private let renderSettings: RenderSettings
    
    private var videoWriter: AVAssetWriter!
    private var videoWriterInput: AVAssetWriterInput!
    private var pixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor!
    
    var isReadyForData: Bool
    {
        return videoWriterInput?.isReadyForMoreMediaData ?? false
    }
    
    init(renderSettings: RenderSettings)
    {
        self.renderSettings = renderSettings
    }
    
    func pixelBufferFromImage(uiImage: UIImage, pixelBufferPool: CVPixelBufferPool, size: CGSize) -> CVPixelBuffer?
    {
        var pixelBufferOut: CVPixelBuffer?
        
        let status = CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, pixelBufferPool, &pixelBufferOut)
        if status != kCVReturnSuccess
        {
            return nil
        }
        
        let pixelBuffer = pixelBufferOut!
        
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        guard let data = CVPixelBufferGetBaseAddress(pixelBuffer)
        else
        {
            return nil
        }
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        
        guard let context = CGContext(data: data, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
        else
        {
            return nil
        }
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        context.clear(rect)
        
        let horizontalRatio = size.width / uiImage.size.width
        let verticalRatio = size.height / uiImage.size.height
        let aspectRatio = min(horizontalRatio, verticalRatio) // ScaleAspectFit.
        let newSize = CGSize(width: uiImage.size.width * aspectRatio, height: uiImage.size.height * aspectRatio)
        let x = newSize.width < size.width ? (size.width - newSize.width) / 2 : 0
        let y = newSize.height < size.height ? (size.height - newSize.height) / 2 : 0
        
        guard let cgImage = uiImage.cgImage
        else
        {
            return nil
        }
        
        context.draw(cgImage, in: CGRect(x: x, y: y, width: newSize.width, height: newSize.height))
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
    
    func createPixelBufferAdaptor()
    {
        let sourcePixelBufferAttributesDictionary =
            [
                kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32ARGB),
                kCVPixelBufferWidthKey as String: NSNumber(value: Float(renderSettings.size.width)),
                kCVPixelBufferHeightKey as String: NSNumber(value: Float(renderSettings.size.height))
            ]
        
        pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoWriterInput, sourcePixelBufferAttributes: sourcePixelBufferAttributesDictionary)
    }
    
    /// Creates a AVAssetWriter that writes in the output URL with given settings.
    func createAssetWriter(avOutputSettings: [String : Any]) -> AVAssetWriter?
    {
        guard let assetWriter = try? AVAssetWriter(outputURL: renderSettings.outputURL!, fileType: .mp4)
        else
        {
            return nil
        }
        
        guard assetWriter.canApply(outputSettings: avOutputSettings, forMediaType: .video) else
        {
            return nil
        }
        
        return assetWriter
    }
    
    func start(_ completion: @escaping (_ success: Bool) -> Void)
    {
        let avOutputSettings: [String : Any] =
            [
                AVVideoCodecKey: renderSettings.avCodecKey,
                AVVideoWidthKey: NSNumber(value: Float(renderSettings.size.width)),
                AVVideoHeightKey: NSNumber(value: Float(renderSettings.size.height))
            ]
        
        videoWriter = createAssetWriter(avOutputSettings: avOutputSettings)
        videoWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: avOutputSettings)
        
        guard videoWriter != nil
        else
        {
            completion(false)
            return
        }
        
        if videoWriter.canAdd(videoWriterInput)
        {
            videoWriter.add(videoWriterInput)
        }
        else
        {
            completion(false)
            return
        }
        
        createPixelBufferAdaptor()
        
        if videoWriter.startWriting() == false
        {
            completion(false)
            return
        }
        
        videoWriter.startSession(atSourceTime: .zero)
        completion(true)
    }
    
    func render(appendPixelBuffers: ((VideoWriter) -> Bool)?, _ completion: @escaping (_ success: Bool) -> Void)
    {
        guard videoWriter != nil, videoWriterInput != nil
        else
        {
            completion(false)
            return
        }
        
        let queue = DispatchQueue(label: "_VideoWriterInputQueue")
        
        videoWriterInput.requestMediaDataWhenReady(on: queue)
        {
            let finished = appendPixelBuffers?(self) ?? false
            
            if finished
            {
                self.videoWriterInput.markAsFinished()
                self.videoWriter.finishWriting()
                {
                    if let error = self.videoWriter.error
                    {
                        debugPrint(error)
                        completion(false)
                    }
                    else
                    {
                        completion(true)
                    }
                }
            }
        }
    }
    
    func addImageFrom(imageURL: URL, withPresentationTime presentationTime: CMTime) -> Bool
    {
        guard let data = try? Data(contentsOf: imageURL), let uiImage = UIImage(data: data)
        else
        {
            return false
        }
        
        guard pixelBufferAdaptor != nil, pixelBufferAdaptor.pixelBufferPool != nil
        else
        {
            return false
        }
        
        guard let pixelBuffer = pixelBufferFromImage(uiImage: uiImage, pixelBufferPool: pixelBufferAdaptor.pixelBufferPool!, size: renderSettings.size)
        else
        {
            return false
        }
        
        return pixelBufferAdaptor.append(pixelBuffer, withPresentationTime: presentationTime)
    }
}
