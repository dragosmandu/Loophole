//
//
//  Project Name: Thecircle 
//  Workspace: Untitled 12
//  MacOS Version: 11.2
//			
//  File Name: RootView.swift
//  Creation: 4/9/21 12:48 PM
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
import AVFoundation
import Network

struct RootView: View
{
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @EnvironmentObject private var modalViewPresenterManager: ModalViewPresenter.Manager
    
    // Settings
    @State private var isHDQuality: Bool = UserDefaults.isHDQuality
    @State private var captureDelay: Double = UserDefaults.captureDelay
    @State private var interFrameDelay: Double = UserDefaults.interFrameDelay
    @State private var videoFormatLoopCounter: Int = UserDefaults.videoFormatLoopCounter
    
    // Camera
    @State private var currentCapturePosition: AVCaptureDevice.Position = .back
    @State private var torchMode: AVCaptureDevice.TorchMode = .auto
    @State private var isRecording: Bool = false
    
    // Text Field
    @State private var adjustableTextFieldViews: [AdjustableTextFieldView] = []
    @State private var didFocusAdjustableTextField: Bool = false
    @State private var editorOpacity: Double = 1
    
    // Options
    @State private var isReversed: Bool = false
    @State private var currentCaptureFileType: CaptureButtonView.CaptureFileType = .mp4
    @State private var selectedFilterType: CIFilter.FilterType? = nil
    
    @State private var isRequestingSelectedAssets: Bool = false
    @State private var frameFileURLs: [URL] = []
    @State private var selectedAssets: [Int : PHAsset] = [ : ]
    @State private var isShowingStartScreen: Bool = true
    @State private var adjustableStickerViews: [AdjustableStickerView] = []
    @State private var adjustablePhotoViews: [AdjustablePhotoView] = []
    @State private var isPreviewing: Bool = false
    
    init()
    {
        
    }
    
    var body: some View
    {
        ZStack(alignment: .topTrailing)
        {
            Group
            {
                if !isRecording && !isRequestingSelectedAssets && frameFileURLs.count > 0
                {
                    LoopPreviewScreenView(frameFileURLs: $frameFileURLs, isReversed: $isReversed, adjustableTextFieldViews: $adjustableTextFieldViews, adjustableStickerViews: $adjustableStickerViews, adjustablePhotoViews: $adjustablePhotoViews, selectedFilterType: $selectedFilterType, currentCaptureFileType: $currentCaptureFileType, interFrameDelay: $interFrameDelay, videoFormatLoopCounter: $videoFormatLoopCounter, selectedAssets: $selectedAssets)
                        .onAppear
                        {
                            isPreviewing = true
                            
                            updateLoopsCounterWithNoAds()
                            
                            // Stop requesting ads.
                            #if !targetEnvironment(simulator)
                            GADMobileInterstitialAdController.shared.canRequestAds = false
                            #endif
                        }
                        .onDisappear
                        {
                            isPreviewing = false
                        }
                        .transition()
                }
                else if !isRequestingSelectedAssets
                {
                    CameraView(currentCapturePosition: $currentCapturePosition, torchMode: $torchMode, isRecording: $isRecording, isReversed: $isReversed, frameFileURLs: $frameFileURLs, captureDelay: $captureDelay, isHDQuality: $isHDQuality, selectedAssets: $selectedAssets, currentCaptureFileType: $currentCaptureFileType)
                        .onAppear
                        {
                            requestReviewIfAppropriate()
                            requestAdIfAppropriate()
                        }
                        .notifyOnApp(appState: .willEnterForeground)
                        {
                            requestReviewIfAppropriate()
                            requestAdIfAppropriate()
                        }
                        .transition()
                }
                else
                {
                    PlaceholderView()
                        .transition()
                }
            }
            .zIndex(1)
            
            editorView
                .zIndex(2)
        }
        .ignoresSafeArea(.keyboard, edges: .all)
        .onChange(of: selectedAssets)
        { selectedAssets in
            if selectedAssets.count > 0
            {
                populateFrameURLsWithSelectedAssets()
            }
        }
        .notifyOnApp(appState: .willEnterBackground)
        {
            
            #if !targetEnvironment(simulator)
            // Stop requesting ads if the app enters in background.
            GADMobileInterstitialAdController.shared.canRequestAds = false
            #endif
        }
    }
    
    private var editorView: some View
    {
        return Group
        {
            
            // Means at least one adjustable text field is currently in focus.
            if !didFocusAdjustableTextField
            {
                EditorControllerView(frameFileURLs: $frameFileURLs, isReversed: $isReversed, adjustableTextFieldViews: $adjustableTextFieldViews, adjustableStickerViews: $adjustableStickerViews, adjustablePhotoViews: $adjustablePhotoViews, isHDQuality: $isHDQuality, captureDelay: $captureDelay, interFrameDelay: $interFrameDelay, videoFormatLoopCounter: $videoFormatLoopCounter, didFocusAdjustableTextField: $didFocusAdjustableTextField, selectedFilterType: $selectedFilterType, currentCaptureFileType: $currentCaptureFileType, isPreviewing: $isPreviewing)
                    .transition()
            }
            
            ForEach(adjustablePhotoViews, id: \.self)
            { adjustablePhotoView in
                adjustablePhotoView
            }
            
            ForEach(adjustableStickerViews, id: \.self)
            { adjustableStickerView in
                adjustableStickerView
            }
            
            ForEach(adjustableTextFieldViews, id: \.self)
            { adjustableTextFieldView in
                adjustableTextFieldView
            }
        }
        .opacity(editorOpacity)
        .onChange(of: isRecording)
        { isRecording in
            if isRecording
            {
                withAnimation(.viewRemovalAnimation)
                {
                    editorOpacity = 0
                }
            }
            else
            {
                withAnimation(.viewInsertionAnimation)
                {
                    editorOpacity = 1
                }
            }
        }
    }
    
    private func updateLoopsCounterWithNoAds()
    {
        let createdLoopsCounter = UserDefaults.createdLoopsCounter
        
        if createdLoopsCounter < Constant.createdLoopsWithNoAd + 1
        {
            UserDefaults.standard.setValue(createdLoopsCounter + 1, forKey: UserDefaults.Key.createdLoopsCounterKey)
        }
    }
    
    private func requestAdIfAppropriate()
    {
        #if !targetEnvironment(simulator)
        if UserDefaults.createdLoopsCounter > Constant.createdLoopsWithNoAd
        {
            GADMobileInterstitialAdController.shared.canRequestAds = true
            GADMobileInterstitialAdController.shared.loadAd() // Preload interstitial ad.
        }
        #endif
    }
    
    private func requestReviewIfAppropriate()
    {
        let currentTimestamp: Double = Date().timeIntervalSince1970
        let currentAppInstallTimestamp = UserDefaults.appInstallTimestamp
        let nextReviewRequestCounter = UserDefaults.reviewRequestCounter + 1 // If successfull.
        
        // Adjusted minimum number of seconds that should pass in order to prompt another review request for the next number of requests if this one is successfull.
        let adjMinSecDurationFromInstallToRequestReview = Constant.minSecDurationFromInstallToRequestReview * Double(nextReviewRequestCounter)
        
        if currentTimestamp - currentAppInstallTimestamp >= adjMinSecDurationFromInstallToRequestReview &&
            UserDefaults.reviewRequestCounter < Constant.maxReviewRequestCounter
        {
            requestReview()
            
            UserDefaults.standard.setValue(nextReviewRequestCounter, forKey: UserDefaults.Key.reviewRequestCounterKey)
        }
    }
    
    /// Get's the smallest size (width, height) possible from the selected assets.
    private func getSelectedAssetNominalTargetSize() -> CGSize
    {
        var targetSize = CGSize(width: isHDQuality ? 720 : 480, height: isHDQuality ? 1280 : 640)
        
        for asset in selectedAssets
        {
            let pixelSize = CGSize(width: asset.value.pixelWidth, height: asset.value.pixelHeight)
            
            if targetSize.width > pixelSize.width
            {
                targetSize.width = pixelSize.width
            }
            
            if targetSize.height > pixelSize.height
            {
                targetSize.height = pixelSize.height
            }
        }
        
        return targetSize
    }
    
    /// Gets the frames from selected assets.
    private func populateFrameURLsWithSelectedAssets()
    {
        isRequestingSelectedAssets = true
        frameFileURLs.removeAll()
        
        let imageManager = PHImageManager()
        let options = PHImageRequestOptions()
        let targetSize = getSelectedAssetNominalTargetSize()
        let contentMode: PHImageContentMode = .aspectFill
        
        options.isNetworkAccessAllowed = true
        options.resizeMode = .exact
        options.normalizedCropRect = CGRect(origin: .zero, size: targetSize)
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        
        for asset in selectedAssets
        {
            imageManager.requestImage(for: asset.value, targetSize: targetSize, contentMode: contentMode, options: options)
            { uiImage, _ in
                if let uiImage = uiImage, let jpegData = uiImage.jpegData(compressionQuality: 1), let frameFileURL = FileManager.createFile(contentType: .jpeg, data: jpegData)
                {
                    frameFileURLs.append(frameFileURL)
                    
                    if frameFileURLs.count == selectedAssets.count
                    {
                        isRequestingSelectedAssets = false
                    }
                }
            }
        }
    }
}

struct RootView_Previews: PreviewProvider
{
    static var previews: some View
    {
        RootView()
    }
}
