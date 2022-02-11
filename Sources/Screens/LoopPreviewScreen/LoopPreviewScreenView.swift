//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: LoopPreviewScreenView.swift
//  Creation: 4/10/21 6:40 PM
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

struct LoopPreviewScreenView: View
{
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @State private var loopFileURL: URL? = nil
    @State private var isCombiningLoop: Bool = false
    @State private var isProcessingAd: Bool = false
    @State private var didShowAdForLoop: Bool = false
    
    @Binding private var frameFileURLs: [URL]
    @Binding private var isReversed: Bool
    @Binding private var adjustableTextFieldViews: [AdjustableTextFieldView]
    @Binding private var adjustableStickerViews: [AdjustableStickerView]
    @Binding private var adjustablePhotoViews: [AdjustablePhotoView]
    @Binding private var selectedFilterType: CIFilter.FilterType?
    @Binding private var currentCaptureFileType: CaptureButtonView.CaptureFileType
    @Binding private var interFrameDelay: Double
    @Binding private var videoFormatLoopCounter: Int
    @Binding private var selectedAssets: [Int : PHAsset]
    
    init(frameFileURLs: Binding<[URL]>, isReversed: Binding<Bool>, adjustableTextFieldViews: Binding<[AdjustableTextFieldView]>, adjustableStickerViews: Binding<[AdjustableStickerView]>, adjustablePhotoViews: Binding<[AdjustablePhotoView]>, selectedFilterType: Binding<CIFilter.FilterType?>, currentCaptureFileType: Binding<CaptureButtonView.CaptureFileType>, interFrameDelay: Binding<Double>, videoFormatLoopCounter: Binding<Int>, selectedAssets: Binding<[Int : PHAsset]>)
    {
        _frameFileURLs = frameFileURLs
        _isReversed = isReversed
        _adjustableTextFieldViews = adjustableTextFieldViews
        _adjustableStickerViews = adjustableStickerViews
        _adjustablePhotoViews = adjustablePhotoViews
        _selectedFilterType = selectedFilterType
        _currentCaptureFileType = currentCaptureFileType
        _interFrameDelay = interFrameDelay
        _videoFormatLoopCounter = videoFormatLoopCounter
        _selectedAssets = selectedAssets
    }
    
    var body: some View
    {
        ZStack(alignment: .bottom)
        {
            ZStack(alignment: .topLeading)
            {
                Group
                {
                    if currentCaptureFileType == .gif ||
                        
                        // 1 frame will be saved as a jpeg.
                        (frameFileURLs.count == 1 && !isReversed)
                    {
                        AnimatedImageView(url: $loopFileURL, isContentModeChangeable: true, contentMode: .fill)
                            .transition()
                    }
                    else
                    {
                        VideoPlayerView(url: $loopFileURL)
                            .transition()
                    }
                }
                .shadowOverlay(startPoint: .bottom, endPoint: .top, heightRatio: 0.2)
                .edgesIgnoringSafeArea(.all)
                
                CloseButtonView(isTranslucent: true)
                {
                    cleanLoopWith(frameFileURLs: frameFileURLs, loopFileURL: loopFileURL)
                    
                    loopFileURL = nil
                    selectedFilterType = nil
                    frameFileURLs.removeAll()
                    selectedAssets.removeAll()
                    adjustableTextFieldViews.removeAll()
                    adjustableStickerViews.removeAll()
                    adjustablePhotoViews.removeAll()
                }
            }
            .disabled(isCombiningLoop)
            
            ShareLoopButtonView(isCombiningLoop: $isCombiningLoop, frameFileURLs: $frameFileURLs, adjustableTextFieldViews: $adjustableTextFieldViews, adjustableStickerViews: $adjustableStickerViews, adjustablePhotoViews: $adjustablePhotoViews, isReversed: $isReversed, interFrameDelay: $interFrameDelay, videoFormatLoopCounter: $videoFormatLoopCounter, currentCaptureFileType: $currentCaptureFileType, isProcessingAd: $isProcessingAd, selectedFilterType: $selectedFilterType)
                .margin(.all)
        }
        .onAppear
        {
            combineLoop()
        }
        .onChange(of: isReversed)
        { _ in
            
            // Recreates the loop when the reversed option changes.
            combineLoop()
        }
        .onChange(of: frameFileURLs)
        { _ in
            
            // Recreates the loop when the frame URLs count changes.
            combineLoop()
        }
        .onChange(of: interFrameDelay)
        { _ in
            
            // Recreates the loop when the inter frame delay changes.
            combineLoop()
        }
        .onChange(of: selectedFilterType)
        { _ in
            
            // Recreates the loop when the filter changes.
            combineLoop()
        }
        .onChange(of: isProcessingAd)
        { _ in
            if isProcessingAd && didShowAdForLoop
            {
                isProcessingAd = false
            }
        }
        .overlay(
            Group
            {
                if isProcessingAd && !didShowAdForLoop // Show only if the current loop hasn't showed an ad yet.
                {
                    #if !targetEnvironment(simulator)
                    GADMobileInterstitialAdControllerRepresentable(isProcessingAd: $isProcessingAd, didShowAdForLoop: $didShowAdForLoop)
                        .edgesIgnoringSafeArea(.all)
                        .transition()
                    #endif
                }
            }
        )
    }
}

private extension LoopPreviewScreenView
{
    // MARK: - Helpers
    
    func deleteLoopWith(loopFileURL: URL)
    {
        do
        {
            try FileManager.deleteFile(fileURL: loopFileURL)
        }
        catch
        {
            debugPrint(error)
        }
    }
    
    private func combineLoop()
    {
        if frameFileURLs.count > 0
        {
            if let currentLoopFileURL = loopFileURL
            {
                loopFileURL = nil
                
                // Deleting the current loop to create a new one.
                deleteLoopWith(loopFileURL: currentLoopFileURL)
            }
            
            // No text/sticker/photo combine yet.
            combineLoopFor(frameFileURLs: frameFileURLs, adjustableTextFieldProperties: [], adjustableStickerProperties: [], adjustablePhotoProperties: [], isReversed: isReversed, captureFileType: currentCaptureFileType, interFrameDelay: interFrameDelay, videoFormatLoopCounter: 1, selectedFilterType: selectedFilterType, isAddingWatermark: false)
            { loopFileURL in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
                {
                    self.loopFileURL = loopFileURL
                }
            }
        }
    }
}
