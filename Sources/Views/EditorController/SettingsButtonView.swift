//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: SettingsButtonView.swift
//  Creation: 4/17/21 9:32 AM
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

struct SettingsButtonView: View
{
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @State private var isPresented: Bool = false
    
    /// Keeps track of the latest inter frame delay. Updates inter frame delay when dismissed.
    @State private var currentInterFrameDelay: Double = 0
    
    /// Keeps track of the latest video loop counter. Updates video loop counter when dismissed.
    @State private var currentVideoFormatLoopCounter: Int = 0
    
    
    @Binding private var isHDQuality: Bool
    @Binding private var captureDelay: Double
    @Binding private var interFrameDelay: Double
    @Binding private var videoFormatLoopCounter: Int
    @Binding private var currentCaptureFileType: CaptureButtonView.CaptureFileType
    @Binding private var isPreviewing: Bool
    
    init(isHDQuality: Binding<Bool>, captureDelay: Binding<Double>, interFrameDelay: Binding<Double>, videoFormatLoopCounter: Binding<Int>, currentCaptureFileType: Binding<CaptureButtonView.CaptureFileType>, isPreviewing: Binding<Bool>)
    {
        _isHDQuality = isHDQuality
        _captureDelay = captureDelay
        _interFrameDelay = interFrameDelay
        _videoFormatLoopCounter = videoFormatLoopCounter
        _currentCaptureFileType = currentCaptureFileType
        _isPreviewing = isPreviewing
    }
    
    var body: some View
    {
        Button
        {
            isPresented.toggle()
        }
        label:
        {
            buttonLabelView
        }
        .fullScreenCover(isPresented: $isPresented)
        {
            isPresented = false
            
            // Inter frame delay and video loop counter aren't updated until the settings sheet is dismissed in order to stop creating multiple loops for each choice. Waits until the last inter frame delay or video loop counter has been set as final value.
            interFrameDelay = currentInterFrameDelay
            videoFormatLoopCounter = currentVideoFormatLoopCounter
        }
        content:
        {
            SettingsScreenView(isPresented: $isPresented, isHDQuality: $isHDQuality, captureDelay: $captureDelay, interFrameDelay: $currentInterFrameDelay, videoFormatLoopCounter: $currentVideoFormatLoopCounter, currentCaptureFileType: $currentCaptureFileType, isPreviewing: $isPreviewing)
        }
        .onAppear
        {
            currentInterFrameDelay = interFrameDelay
            currentVideoFormatLoopCounter = videoFormatLoopCounter
        }
    }
    
    public var buttonLabelView: some View
    {
        let font: Font = .system(size: Constant.fontSize, weight: Constant.fontWeight, design: .rounded)
        let systemSymbolName = "gearshape"
        
        return Image(systemName: systemSymbolName)
            .font(font)
            .foregroundColor(colorScheme.white)
            .margin([.top, .horizontal])
    }
}
