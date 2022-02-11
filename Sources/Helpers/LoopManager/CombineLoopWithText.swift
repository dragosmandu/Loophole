//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: CombineLoopWithText.swift
//  Creation: 4/22/21 7:28 AM
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

private var _lock: NSLock = .init()

/// The frame file URLs with added text, if any.
private var _finalFrameFileURLs = [URL]()
private var _processedFinalFrameFileURLsCounter: Int = 0
private var _loopSize: CGSize = .zero

private var _watermarkTextProperties: AdjustableTextFieldTextProperties
{
    let watermarkTextProperties = AdjustableTextFieldTextProperties()
    
    watermarkTextProperties.text = "Made with Loophole"
    watermarkTextProperties.fontSize = AdjustableTextFieldTextProperties.defaultMinFontSize * 0.4
    watermarkTextProperties.foregroundColorProperties.color = Color.white.opacity(TransparencyModifier.maxTransparency)
    watermarkTextProperties.position = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height - watermarkTextProperties.fontSize * 1.5)
    watermarkTextProperties.rotationAngle = .zero
    
    return watermarkTextProperties
}

// Deleting the text drawn frames regardles of the loop creation status.
private func cleanDrawnFrames()
{
    while _finalFrameFileURLs.count > 0
    {
        let lastFinalFrameFileURL = _finalFrameFileURLs.removeLast()
        try? FileManager.deleteFile(fileURL: lastFinalFrameFileURL)
    }
}

private func updateLoopSize(uiImageFrame: inout UIImage)
{
    if _loopSize.width > uiImageFrame.size.width
    {
        
        // If there is a frame with a lower width, take that width as the loop width.
        _loopSize.width = uiImageFrame.size.width
    }
    
    if _loopSize.height > uiImageFrame.size.height
    {
        
        // If there is a frame with a lower height, take that height as the loop height.
        _loopSize.height = uiImageFrame.size.height
    }
}

private func drawTextWith(adjustableTextFieldProperties: [AdjustableTextFieldTextProperties], uiImageFrame: inout UIImage)
{
    let imageScreenWidthRatio = uiImageFrame.size.width / UIScreen.main.bounds.size.width
    let imageScreenHeightRatio = uiImageFrame.size.height / UIScreen.main.bounds.size.height
    
    // Normalizes the font size to adapt to the image size, which it may be larger or smaller than the screen size. This makes the font look almost the same as shown in the live camera buffer.
    let fontSizeScaleFactor = min(imageScreenWidthRatio, imageScreenWidthRatio)
    
    for adjustableTextFieldProperty in adjustableTextFieldProperties
    {
        let text = adjustableTextFieldProperty.text
        let fontSize = adjustableTextFieldProperty.fontSize * fontSizeScaleFactor
        var font: UIFont = .systemFont(ofSize: fontSize, weight: AdjustableTextFieldTextProperties.defaultUIFontWeight)
        let color = UIColor(adjustableTextFieldProperty.foregroundColorProperties.color)
        let location = CGPoint(x: adjustableTextFieldProperty.position.x * imageScreenWidthRatio, y: adjustableTextFieldProperty.position.y * imageScreenHeightRatio)
        let rotationAngleRad = CGFloat(adjustableTextFieldProperty.rotationAngle.radians)
        
        if let descriptor = font.fontDescriptor.withDesign(AdjustableTextFieldTextProperties.defaultUIFontDesign)
        {
            font = UIFont(descriptor: descriptor, size: fontSize)
        }
        
        if let updatedUIImageFrame = uiImageFrame.drawText(text, font: font, color: color, location: location, rotationAngleRad: rotationAngleRad)
        {
            uiImageFrame = updatedUIImageFrame
        }
    }
}

private func drawStickersWith(adjustableStickerProperties: [AdjustableStickerProperties], uiImageFrame: inout UIImage)
{
    let imageScreenWidthRatio = uiImageFrame.size.width / UIScreen.main.bounds.size.width
    let imageScreenHeightRatio = uiImageFrame.size.height / UIScreen.main.bounds.size.height
    
    // Normalizes the font size to adapt to the image size, which it may be larger or smaller than the screen size. This makes the font look almost the same as shown in the live camera buffer.
    let fontSizeScaleFactor = min(imageScreenWidthRatio, imageScreenWidthRatio)
    
    for adjustableStickerProperty in adjustableStickerProperties
    {
        let fontSize = adjustableStickerProperty.fontSize * fontSizeScaleFactor
        var font: UIFont = .systemFont(ofSize: fontSize)
        let config = UIImage.SymbolConfiguration(font: font)
        
        guard let sticker = adjustableStickerProperty.sticker, let uiImage = UIImage(named: sticker.symbolName, in: nil, with: config)
        else
        {
            continue
        }
        
        let location = CGPoint(x: adjustableStickerProperty.position.x * imageScreenWidthRatio, y: adjustableStickerProperty.position.y * imageScreenHeightRatio)
        let rotationAngleRad = CGFloat(adjustableStickerProperty.rotationAngle.radians)
        
        if let descriptor = font.fontDescriptor.withDesign(AdjustableTextFieldTextProperties.defaultUIFontDesign)
        {
            font = UIFont(descriptor: descriptor, size: fontSize)
        }
        
        if let updatedUIImageFrame = uiImageFrame.drawImage(uiImage, location: location, rotationAngleRad: rotationAngleRad)
        {
            uiImageFrame = updatedUIImageFrame
        }
    }
}

private func getPhotoAsset(asset: PHAsset, targetSize: CGSize, _ completion: @escaping (_ photo: UIImage?) -> Void)
{
    let imageManager = PHImageManager()
    let options = PHImageRequestOptions()
    let contentMode: PHImageContentMode = .aspectFit
    
    options.isNetworkAccessAllowed = true
    options.resizeMode = .exact
    options.normalizedCropRect = CGRect(origin: .zero, size: targetSize)
    options.isSynchronous = true
    options.deliveryMode = .highQualityFormat
    
    imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options)
    { uiImage, _ in
        completion(uiImage)
    }
}

private func drawPhotosWith(adjustablePhotoProperties: [AdjustablePhotoProperties], uiImageFrame: UIImage) -> UIImage
{
    var _uiImageFrame = uiImageFrame
    let imageScreenWidthRatio = uiImageFrame.size.width / UIScreen.main.bounds.size.width
    let imageScreenHeightRatio = uiImageFrame.size.height / UIScreen.main.bounds.size.height
    
    // Normalizes the size to adapt to the image size, which it may be larger or smaller than the screen size. This makes the photo look almost the same as shown in the live camera buffer.
    let sizeScaleFactor = min(imageScreenWidthRatio, imageScreenWidthRatio)
    
    for adjustablePhotoProperty in adjustablePhotoProperties
    {
        let lengthSize = adjustablePhotoProperty.lengthSize * sizeScaleFactor
        let targetSize = CGSize(width: lengthSize, height: lengthSize)
        let location = CGPoint(x: adjustablePhotoProperty.position.x * imageScreenWidthRatio, y: adjustablePhotoProperty.position.y * imageScreenHeightRatio)
        let rotationAngleRad = CGFloat(adjustablePhotoProperty.rotationAngle.radians)
        
        if let asset = adjustablePhotoProperty.photo
        {
            getPhotoAsset(asset: asset, targetSize: targetSize)
            { uiImage in
                if let uiImage = uiImage, let updatedUIImageFrame = _uiImageFrame.drawImage(uiImage, location: location, rotationAngleRad: rotationAngleRad)
                {
                    _uiImageFrame = updatedUIImageFrame
                }
            }
        }
    }
    
    return _uiImageFrame
}

private func addWatermarkIf(isAddingWatermark: Bool, uiImageFrame: inout UIImage)
{
    if isAddingWatermark
    {
        drawTextWith(adjustableTextFieldProperties: [_watermarkTextProperties], uiImageFrame: &uiImageFrame)
    }
}

private func getFrameFrom(frameFileURL: URL) -> UIImage?
{
    guard let frameData = try? Data(contentsOf: frameFileURL), let uiImageFrame = UIImage(data: frameData)
    else
    {
        return nil
    }
    
    return uiImageFrame
}

// Adding a filter if any selected.
private func addFilterIfNeeded(selectedFilterType: CIFilter.FilterType?, uiImageFrame: inout UIImage)
{
    if let selectedFilterType = selectedFilterType, let filteredUIImageFrame = uiImageFrame.addFilter(filterType: selectedFilterType)
    {
        uiImageFrame = filteredUIImageFrame
    }
}

private func generateFinalFrameFileURLsFor(frameFileURLs: [URL], adjustableTextFieldProperties: [AdjustableTextFieldTextProperties], adjustableStickerProperties: [AdjustableStickerProperties], adjustablePhotoProperties: [AdjustablePhotoProperties], selectedFilterType: CIFilter.FilterType?, isAddingWatermark: Bool, _ completion: @escaping () -> Void)
{
    for (index, frameFileURL) in frameFileURLs.enumerated()
    {
        DispatchQueue.global(qos: .userInitiated).async
        {
            guard var uiImageFrame = getFrameFrom(frameFileURL: frameFileURL)
            else
            {
                return
            }
            
            updateLoopSize(uiImageFrame: &uiImageFrame)
            uiImageFrame = drawPhotosWith( adjustablePhotoProperties: adjustablePhotoProperties, uiImageFrame: uiImageFrame)
            drawStickersWith(adjustableStickerProperties: adjustableStickerProperties, uiImageFrame: &uiImageFrame)
            drawTextWith(adjustableTextFieldProperties: adjustableTextFieldProperties, uiImageFrame: &uiImageFrame)
            addFilterIfNeeded(selectedFilterType: selectedFilterType, uiImageFrame: &uiImageFrame)
            addWatermarkIf(isAddingWatermark: isAddingWatermark, uiImageFrame: &uiImageFrame)
            
            if let jpegData = uiImageFrame.jpegData(compressionQuality: 1), let finalFrameFileURL = FileManager.createFile(contentType: .jpeg, data: jpegData)
            {
                _lock.lock()
                
                if _finalFrameFileURLs.count - 1 >= index
                {
                    _finalFrameFileURLs[index] = finalFrameFileURL
                    _processedFinalFrameFileURLsCounter += 1
                }
                
                // We've processed all the frames.
                if _processedFinalFrameFileURLsCounter == frameFileURLs.count
                {
                    completion()
                }
                
                _lock.unlock()
            }
        }
    }
}

func combineLoopFor(frameFileURLs: [URL], adjustableTextFieldProperties: [AdjustableTextFieldTextProperties], adjustableStickerProperties: [AdjustableStickerProperties], adjustablePhotoProperties: [AdjustablePhotoProperties], isReversed: Bool, captureFileType: CaptureButtonView.CaptureFileType, interFrameDelay: Double, videoFormatLoopCounter: Int, selectedFilterType: CIFilter.FilterType?, isAddingWatermark: Bool, _ completion: @escaping (_ loopFileURL: URL?) -> Void)
{
    cleanDrawnFrames() // Cleans the previous combined frames, if any.
    
    _finalFrameFileURLs = .init(repeating: URL(fileURLWithPath: ""), count: frameFileURLs.count)
    _processedFinalFrameFileURLsCounter = 0
    _loopSize = CGSize(width: UserDefaults.isHDQuality ? 720 : 480, height: UserDefaults.isHDQuality ? 1280 : 640)
    
    generateFinalFrameFileURLsFor(frameFileURLs: frameFileURLs, adjustableTextFieldProperties: adjustableTextFieldProperties, adjustableStickerProperties: adjustableStickerProperties, adjustablePhotoProperties: adjustablePhotoProperties, selectedFilterType: selectedFilterType, isAddingWatermark: isAddingWatermark)
    {
        if isReversed
        {
            _finalFrameFileURLs.append(contentsOf: _finalFrameFileURLs.reversed())
        }
        
        if captureFileType == .mp4 && videoFormatLoopCounter > 1
        {
            var _videoFormatLoopCounter = 1
            let singleLoopedFinalFrameFileURLs = _finalFrameFileURLs // One sequence (one loop, in video format) of frame URLs.
            
            // Adding more loops to the video.
            while _videoFormatLoopCounter < videoFormatLoopCounter
            {
                _finalFrameFileURLs.append(contentsOf: singleLoopedFinalFrameFileURLs)
                _videoFormatLoopCounter += 1
            }
        }
        
        createLoopWithOptions(size: _loopSize, captureFileType: captureFileType, frameFileURLs: _finalFrameFileURLs, interFrameDelay: interFrameDelay)
        { loopFileURL in
            cleanDrawnFrames()
            completion(loopFileURL)
        }
    }
}
