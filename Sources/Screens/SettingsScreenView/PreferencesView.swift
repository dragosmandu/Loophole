//
//
//  Project Name: Thecircle
//  Workspace: Loophole
//  MacOS Version: 11.2
//
//  File Name: PreferencesView.swift
//  Creation: 4/17/21 4:52 PM
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

extension SettingsScreenView
{
    struct PreferencesView: View
    {
        @Environment(\.colorScheme) private var colorScheme: ColorScheme
        @EnvironmentObject private var modalViewPresenterManager: ModalViewPresenter.Manager
        
        // Current Values
        @State private var currentCaptureDelayStep: Int = 0
        @State private var currentInterFrameDelayStep: Int = 0
        @State private var currentVideoFormatLoopCounterStep: Int = 0
        
        // Info
        @State private var isShowingHDQualityInfo: Bool = false
        @State private var isShowingCaptureDelayInfo: Bool = false
        @State private var isShowingInterFrameDelayInfo: Bool = false
        @State private var isShowingVideoFormatLoopCounterInfo: Bool = false
        
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
            VStack(alignment: .leading, spacing: 0)
            {
                VStack(alignment: .center, spacing: 0)
                {
                    titleView
                        .margin(.bottom)
                    
                    hdQualityView
                        .opacity(isPreviewing ? TransparencyModifier.maxTransparency : 1)
                        .disabled(isPreviewing)
                    
                    captureDelayView
                        .opacity(isPreviewing ? TransparencyModifier.maxTransparency : 1)
                        .disabled(isPreviewing)
                    
                    interFrameDelayView
                    
                    videoFormatLoopCounterView
                        .opacity(currentCaptureFileType == .gif && isPreviewing ? TransparencyModifier.maxTransparency : 1)
                        .disabled(currentCaptureFileType == .gif && isPreviewing)
                }
                .margin(.all)
                .background(colorScheme.lightGrayComplement)
                .cornerRadius(Constant.cornerRadius)
            }
        }
        
        private var titleView: some View
        {
            return HStack(alignment: .center)
            {
                Text("Preferences")
                    .font(headlineFont)
                    .foregroundColor(colorScheme.gray)
                    .lineLimit(1)
                
                Spacer()
            }
        }
        
        private var infoImageLabelView: some View
        {
            return Image(systemName: "info.circle.fill")
                .font(Font.subheadline.weight(.semibold))
        }
        
        private func infoTextViewWith(description: String) -> some View
        {
            return Text(description)
                .font(.caption2)
                .foregroundColor(colorScheme.gray)
        }
        
        private var hdQualityView: some View
        {
            return HStack(alignment: .center, spacing: 0)
            {
                VStack(alignment: .leading, spacing: 0)
                {
                    HStack(alignment: .center, spacing: 0)
                    {
                        Text("HD Quality")
                            .padding(.trailing, factor: 1)
                        
                        Button
                        {
                            isShowingCaptureDelayInfo = false
                            isShowingInterFrameDelayInfo = false
                            isShowingVideoFormatLoopCounterInfo = false
                            isShowingHDQualityInfo.toggle()
                        }
                        label:
                        {
                            infoImageLabelView
                        }
                    }
                    .padding(.bottom, factor: 1)
                    
                    if isShowingHDQualityInfo
                    {
                        let description = "High-Definition 1280x720 pixels"
                        
                        infoTextViewWith(description: description)
                    }
                }
                .fixedSize()
                
                Spacer()
                
                Toggle("", isOn: $isHDQuality)
                    .toggleStyle(SwitchToggleStyle(tint: colorScheme.blue))
                    .onChange(of: isHDQuality)
                    { isHDQuality in
                        DispatchQueue.global(qos: .userInitiated).async
                        {
                            UserDefaults.standard.setValue(isHDQuality, forKey: UserDefaults.Key.isHDQualityKey)
                        }
                    }
            }
            .font(itemFont)
            .foregroundColor(colorScheme.darkGrayComplement)
            .lineLimit(1)
            .margin(.vertical)
        }
        
        private var captureDelayView: some View
        {
            DispatchQueue.main.async
            {
                currentCaptureDelayStep = Int(Double(captureDelay) * 10 - 1)
            }
            
            return HStack(alignment: .center, spacing: 0)
            {
                VStack(alignment: .leading, spacing: 0)
                {
                    HStack(alignment: .center, spacing: 0)
                    {
                        Text("Capture Delay")
                            .padding(.trailing, factor: 1)
                        
                        Button
                        {
                            isShowingHDQualityInfo = false
                            isShowingInterFrameDelayInfo = false
                            isShowingVideoFormatLoopCounterInfo = false
                            isShowingCaptureDelayInfo.toggle()
                        }
                        label:
                        {
                            infoImageLabelView
                        }
                    }
                    .padding(.bottom, factor: 1)
                    
                    if isShowingCaptureDelayInfo
                    {
                        let description = "Delay between shots"
                        
                        infoTextViewWith(description: description)
                    }
                }
                .fixedSize()
                
                Spacer()
                
                StepperView(currentStep: $currentCaptureDelayStep, range: 1...10, font: itemFont, foregroundColor: colorScheme.darkGrayComplement, signForegroundColor: colorScheme.darkGrayComplement, backgroundColor: colorScheme.gray)
                { step in
                    return "\(String(format: "%.1f", Double(step) / 10))s"
                }
                .frame(width: 80, height: 35, alignment: .center)
                .onChange(of: currentCaptureDelayStep)
                { currentCaptureDelayStep in
                    let newCaptureDelay = Double(currentCaptureDelayStep + 1) / 10
                    
                    if newCaptureDelay != captureDelay
                    {
                        DispatchQueue.global(qos: .userInitiated).async
                        {
                            captureDelay = newCaptureDelay
                        }
                    }
                }
                .onChange(of: captureDelay)
                { captureDelay in
                    DispatchQueue.global(qos: .userInitiated).async
                    {
                        UserDefaults.standard.setValue(captureDelay, forKey: UserDefaults.Key.captureDelayKey)
                    }
                }
            }
            .font(itemFont)
            .foregroundColor(colorScheme.darkGrayComplement)
            .lineLimit(1)
            .margin(.vertical)
        }
        
        private var interFrameDelayView: some View
        {
            DispatchQueue.main.async
            {
                currentInterFrameDelayStep = Int(Double(interFrameDelay) * 10 - 1)
            }
            
            return HStack(alignment: .center, spacing: 0)
            {
                VStack(alignment: .leading, spacing: 0)
                {
                    HStack(alignment: .center, spacing: 0)
                    {
                        Text("Inter Frame Delay")
                            .padding(.trailing, factor: 1)
                        
                        Button
                        {
                            isShowingHDQualityInfo = false
                            isShowingCaptureDelayInfo = false
                            isShowingVideoFormatLoopCounterInfo = false
                            isShowingInterFrameDelayInfo.toggle()
                        }
                        label:
                        {
                            infoImageLabelView
                        }
                    }
                    .padding(.bottom, factor: 1)
                    
                    if isShowingInterFrameDelayInfo
                    {
                        let description = "Delay between frames in loop"
                        
                        infoTextViewWith(description: description)
                    }
                }
                .fixedSize()
                
                Spacer()
                
                StepperView(currentStep: $currentInterFrameDelayStep, range: 1...10, font: itemFont, foregroundColor: colorScheme.darkGrayComplement, signForegroundColor: colorScheme.darkGrayComplement, backgroundColor: colorScheme.gray)
                { step in
                    return "\(String(format: "%.1f", Double(step) / 10))s"
                }
                .frame(width: 80, height: 35, alignment: .center)
                .onChange(of: currentInterFrameDelayStep)
                { currentInterFrameDelayStep in
                    let newInterFrameDelay = Double(currentInterFrameDelayStep + 1) / 10
                    
                    if newInterFrameDelay != interFrameDelay
                    {
                        DispatchQueue.global(qos: .userInitiated).async
                        {
                            interFrameDelay = newInterFrameDelay
                        }
                    }
                }
                .onChange(of: interFrameDelay)
                { interFrameDelay in
                    DispatchQueue.global(qos: .userInitiated).async
                    {
                        UserDefaults.standard.setValue(interFrameDelay, forKey: UserDefaults.Key.interFrameDelayKey)
                    }
                }
            }
            .font(itemFont)
            .foregroundColor(colorScheme.darkGrayComplement)
            .lineLimit(1)
            .margin(.vertical)
        }
        
        private var videoFormatLoopCounterView: some View
        {
            DispatchQueue.main.async
            {
                currentVideoFormatLoopCounterStep = videoFormatLoopCounter - 1
            }
            
            return HStack(alignment: .center, spacing: 0)
            {
                VStack(alignment: .leading, spacing: 0)
                {
                    HStack(alignment: .center, spacing: 0)
                    {
                        Text("Video Loops")
                            .padding(.trailing, factor: 1)
                        
                        Button
                        {
                            isShowingHDQualityInfo = false
                            isShowingCaptureDelayInfo = false
                            isShowingInterFrameDelayInfo = false
                            isShowingVideoFormatLoopCounterInfo.toggle()
                        }
                        label:
                        {
                            infoImageLabelView
                        }
                    }
                    .padding(.bottom, factor: 1)
                    
                    if isShowingVideoFormatLoopCounterInfo
                    {
                        let description = "The number of loops of a video format"
                        
                        infoTextViewWith(description: description)
                    }
                }
                .fixedSize()
                
                Spacer()
                
                StepperView(currentStep: $currentVideoFormatLoopCounterStep, range: 1...3, font: itemFont, foregroundColor: colorScheme.darkGrayComplement, signForegroundColor: colorScheme.darkGrayComplement, backgroundColor: colorScheme.gray)
                { step in
                    return "\(String(format: "%d", step))"
                }
                .frame(width: 80, height: 35, alignment: .center)
                .onChange(of: currentVideoFormatLoopCounterStep)
                { currentVideoFormatLoopCounterStep in
                    let newVideoFormatLoopCounterStep = currentVideoFormatLoopCounterStep + 1
                    
                    if newVideoFormatLoopCounterStep != videoFormatLoopCounter
                    {
                        DispatchQueue.global(qos: .userInitiated).async
                        {
                            videoFormatLoopCounter = newVideoFormatLoopCounterStep
                        }
                    }
                }
                .onChange(of: videoFormatLoopCounter)
                { videoFormatLoopCounter in
                    DispatchQueue.global(qos: .userInitiated).async
                    {
                        UserDefaults.standard.setValue(videoFormatLoopCounter, forKey: UserDefaults.Key.videoFormatLoopCounterKey)
                    }
                }
            }
            .font(itemFont)
            .foregroundColor(colorScheme.darkGrayComplement)
            .lineLimit(1)
            .margin(.vertical)
        }
    }
}
