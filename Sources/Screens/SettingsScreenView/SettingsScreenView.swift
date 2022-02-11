//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: SettingsScreenView.swift
//  Creation: 4/17/21 12:10 PM
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

struct SettingsScreenView: View
{
    static let titleFont = Font.title2.weight(.semibold)
    static let headlineFont = Font.title3.weight(.semibold)
    static let itemFont = Font.headline.weight(.semibold)
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @State private var didAppear: Bool = false
    
    @Binding private var isPresented: Bool
    @Binding private var isHDQuality: Bool
    @Binding private var captureDelay: Double
    @Binding private var interFrameDelay: Double
    @Binding private var videoFormatLoopCounter: Int
    @Binding private var currentCaptureFileType: CaptureButtonView.CaptureFileType
    @Binding private var isPreviewing: Bool
    
    init(isPresented: Binding<Bool>, isHDQuality: Binding<Bool>, captureDelay: Binding<Double>, interFrameDelay: Binding<Double>, videoFormatLoopCounter: Binding<Int>, currentCaptureFileType: Binding<CaptureButtonView.CaptureFileType>, isPreviewing: Binding<Bool>)
    {
        _isPresented = isPresented
        _isHDQuality = isHDQuality
        _captureDelay = captureDelay
        _captureDelay = captureDelay
        _interFrameDelay = interFrameDelay
        _videoFormatLoopCounter = videoFormatLoopCounter
        _currentCaptureFileType = currentCaptureFileType
        _isPreviewing = isPreviewing
        
        UINavigationController.isNavigationBarHidden = true
    }
    
    var body: some View
    {
        ZStack(alignment: .topTrailing)
        {
            NavigationView
            {
                VStack(alignment: .center)
                {
                    settingsTitleView
                        .margin(.all)
                        .margin(.bottom)
                    
                    ScrollView(.vertical, showsIndicators: false)
                    {
                        VStack(alignment: .center)
                        {
                            PreferencesView(isHDQuality: $isHDQuality, captureDelay: $captureDelay, interFrameDelay: $interFrameDelay, videoFormatLoopCounter: $videoFormatLoopCounter, currentCaptureFileType: $currentCaptureFileType, isPreviewing: $isPreviewing)
                                .margin(.top)
                            
                            RequestReviewButtonView()
                                .margin(.top)
                                .margin(.bottom, factor: 3)
                            
                            MiscellaneousView()
                            
                            Spacer()
                            
                            let loopholeVersion = "Loophole v\(Constant.version) (\(Constant.build))"
                            
                            Text(loopholeVersion)
                                .font(Font.caption.weight(.medium))
                                .foregroundColor(colorScheme.gray)
                                .padding(.bottom, factor: 1)
                                .margin(.top, factor: 3)
                        }
                    }
                    .onAppear
                    {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
                        {
                            didAppear = true
                        }
                    }
                    .animation(didAppear ? .easeInOut : nil)
                    .background(colorScheme.whiteComplement)
                    .cornerRadius(Constant.cornerRadius)
                    .margin(.horizontal)
                    
                    // Margin bottom for iPhone SE like.
                    .margin(UIApplication.safeAreaInsets.bottom == 0 ? .bottom : [])
                    .edgesIgnoringSafeArea([.top, .horizontal])
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            
            closeButtonView
        }
    }
    
    private var settingsTitleView: some View
    {
        HStack(alignment: .center, spacing: 0)
        {
            Text("Settings")
                .padding(.trailing, factor: 2)
            
            Image(systemName: "gearshape.fill")
                .foregroundColor(colorScheme.gray)
            
            Spacer()
        }
        .font(SettingsScreenView.titleFont)
        .foregroundColor(colorScheme.blackComplement)
        .lineLimit(1)
    }
    
    private var closeButtonView: some View
    {
        Button
        {
            isPresented = false
        }
        label:
        {
            Image(systemName: CloseButtonView.systemSymbolName)
                .font(CloseButtonView.font.weight(CloseButtonView.fontWeight))
                .foregroundColor(colorScheme.gray)
                .padding(.all, factor: CloseButtonView.paddingFactor)
                .backgroundBlur(isActive: true)
                .clipShape(Circle())
                .margin(.all)
        }
    }
}

struct SettingsScreenView_Previews: PreviewProvider
{
    @State static private var isHDQuality: Bool = false
    @State static private var captureDelay: Double = 0.3
    @State static private var interFrameDelay: Double = 0.3
    @State static private var videoFormatLoopCounter: Int = 1
    @State static private var currentCaptureFileType: CaptureButtonView.CaptureFileType = .mp4
    
    static var previews: some View
    {
        SettingsScreenView(isPresented: .constant(true), isHDQuality: $isHDQuality, captureDelay: $captureDelay, interFrameDelay: $interFrameDelay, videoFormatLoopCounter: $videoFormatLoopCounter, currentCaptureFileType: $currentCaptureFileType, isPreviewing: .constant(false))
        
    }
}
