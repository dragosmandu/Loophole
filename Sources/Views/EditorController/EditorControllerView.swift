//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: EditorControllerView.swift
//  Creation: 4/13/21 2:10 PM
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

public struct EditorControllerView: View
{
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    // Settings
    @Binding private var isHDQuality: Bool
    @Binding private var captureDelay: Double
    @Binding private var interFrameDelay: Double
    @Binding private var videoFormatLoopCounter: Int
    
    @Binding private var frameFileURLs: [URL]
    @Binding private var isReversed: Bool
    @Binding private var didFocusAdjustableTextField: Bool
    @Binding private var adjustableTextFieldViews: [AdjustableTextFieldView]
    @Binding private var adjustableStickerViews: [AdjustableStickerView]
    @Binding private var adjustablePhotoViews: [AdjustablePhotoView]
    @Binding private var selectedFilterType: CIFilter.FilterType?
    @Binding private var currentCaptureFileType: CaptureButtonView.CaptureFileType
    @Binding private var isPreviewing: Bool
    
    init(frameFileURLs: Binding<[URL]>, isReversed: Binding<Bool>, adjustableTextFieldViews: Binding<[AdjustableTextFieldView]>, adjustableStickerViews: Binding<[AdjustableStickerView]>, adjustablePhotoViews: Binding<[AdjustablePhotoView]>, isHDQuality: Binding<Bool>, captureDelay: Binding<Double>, interFrameDelay: Binding<Double>, videoFormatLoopCounter: Binding<Int>, didFocusAdjustableTextField: Binding<Bool>, selectedFilterType: Binding<CIFilter.FilterType?>, currentCaptureFileType: Binding<CaptureButtonView.CaptureFileType>, isPreviewing: Binding<Bool>)
    {
        _frameFileURLs = frameFileURLs
        _isReversed = isReversed
        _adjustableTextFieldViews = adjustableTextFieldViews
        _adjustableStickerViews = adjustableStickerViews
        _adjustablePhotoViews = adjustablePhotoViews
        _isHDQuality = isHDQuality
        _captureDelay = captureDelay
        _interFrameDelay = interFrameDelay
        _videoFormatLoopCounter = videoFormatLoopCounter
        _didFocusAdjustableTextField = didFocusAdjustableTextField
        _selectedFilterType = selectedFilterType
        _currentCaptureFileType = currentCaptureFileType
        _isPreviewing = isPreviewing
    }
    
    public var body: some View
    {
        let shadowCollor = colorScheme.black.opacity(0.2)
        let shadowRadius: CGFloat = 5
        let shadowX: CGFloat = 0
        let shadowY: CGFloat = 0
        
        VStack(alignment: .trailing, spacing: 0)
        {
            SettingsButtonView(isHDQuality: $isHDQuality, captureDelay: $captureDelay, interFrameDelay: $interFrameDelay, videoFormatLoopCounter: $videoFormatLoopCounter, currentCaptureFileType: $currentCaptureFileType, isPreviewing: $isPreviewing)
                .shadow(color: shadowCollor, radius: shadowRadius, x: shadowX, y: shadowY)
            
            AdjustableStickerButtonView(adjustableStickerViews: $adjustableStickerViews)
                .shadow(color: shadowCollor, radius: shadowRadius, x: shadowX, y: shadowY)
            
            AdjustableTextFieldButtonView(adjustableTextFieldViews: $adjustableTextFieldViews, didFocusAdjustableTextField: $didFocusAdjustableTextField)
                .shadow(color: shadowCollor, radius: shadowRadius, x: shadowX, y: shadowY)
            
            AdjustablePhotoButtonView(adjustablePhotoViews: $adjustablePhotoViews)
                .shadow(color: shadowCollor, radius: shadowRadius, x: shadowX, y: shadowY)
            
            if isPreviewing
            {
                ReverseAnimatedImageButtonView(isReversed: $isReversed)
                    .shadow(color: shadowCollor, radius: shadowRadius, x: shadowX, y: shadowY)
                    .transition()
                
                if frameFileURLs.count > 0
                {
                    FilterButtonView(selectedFilterType: $selectedFilterType, firstFrameURL: frameFileURLs[0])
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 0)
                        .transition()
                }
            }
        }
    }
}
