//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: CameraView.swift
//  Creation: 4/9/21 1:33 PM
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
import PhotosUI

public struct CameraView: View
{
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @EnvironmentObject private var modalViewPresenterManager: ModalViewPresenter.Manager
    
    @State private var authorizationStatus: AVAuthorizationStatus = .notDetermined
    
    @Binding private var currentCapturePosition: AVCaptureDevice.Position
    @Binding private var torchMode: AVCaptureDevice.TorchMode
    @Binding private var isRecording: Bool
    @Binding private var isReversed: Bool
    @Binding private var frameFileURLs: [URL]
    @Binding private var captureDelay: Double
    @Binding private var isHDQuality: Bool
    @Binding private var selectedAssets: [Int : PHAsset]
    @Binding private var currentCaptureFileType: CaptureButtonView.CaptureFileType
    
    init(currentCapturePosition: Binding<AVCaptureDevice.Position>, torchMode: Binding<AVCaptureDevice.TorchMode>, isRecording: Binding<Bool>, isReversed: Binding<Bool>, frameFileURLs: Binding<[URL]>, captureDelay: Binding<Double>, isHDQuality: Binding<Bool>, selectedAssets: Binding<[Int : PHAsset]>, currentCaptureFileType: Binding<CaptureButtonView.CaptureFileType>)
    {
        _currentCapturePosition = currentCapturePosition
        _torchMode = torchMode
        _isRecording = isRecording
        _isReversed = isReversed
        _frameFileURLs = frameFileURLs
        _captureDelay = captureDelay
        _isHDQuality = isHDQuality
        _selectedAssets = selectedAssets
        _currentCaptureFileType = currentCaptureFileType
    }
    
    public var body: some View
    {
        Group
        {
            if authorizationStatus == .authorized
            {
                ZStack(alignment: .bottom)
                {
                    ZStack(alignment: .top)
                    {
                        CameraControllerRepresentable(currentCapturePosition: $currentCapturePosition, torchMode: $torchMode, isRecording: $isRecording, isReversed: $isReversed, frameFileURLs: $frameFileURLs, captureDelay: $captureDelay, isHDQuality: $isHDQuality)
                            .edgesIgnoringSafeArea(.all)
                        
                        FramesIndicatorView(currentFramesCounter: .constant(frameFileURLs.count), currentCaptureDelay: $captureDelay)
                            .margin(.all)
                    }
                    .overlay(
                        Group
                        {
                            #if targetEnvironment(simulator)
                            Image("INSERT_IMAGE_NAME")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .edgesIgnoringSafeArea(.all)
                            #endif
                        }
                    )
                    
                    CameraControllerView(isRecording: $isRecording, torchMode: $torchMode, selectedAssets: $selectedAssets, currentCaptureFileType: $currentCaptureFileType)
                }
            }
            else
            {
                GeometryReader
                { proxy in
                    ZStack(alignment: .center)
                    {
                        Rectangle()
                            .fill(colorScheme.black)
                            .edgesIgnoringSafeArea(.all)
                        
                        if authorizationStatus != .notDetermined // Show only when is certain of a non authorization status.
                        {
                            Image(systemName: "video.slash.fill")
                                .font(.system(size: proxy.size.width / 4, weight: .bold))
                                .foregroundColor(colorScheme.darkGray)
                        }
                    }
                }
            }
        }
        .onAppear
        {
            updateAuthorizationStatus()
        }
        .notifyOnApp(appState: .willEnterForeground)
        {
            updateAuthorizationStatus()
        }
        .notifyOnApp(appState: .willEnterBackground)
        {
            modalViewPresenterManager.dismiss()
        }
    }
    
    private func updateAuthorizationStatus()
    {
        authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        if authorizationStatus != .authorized
        {
            if authorizationStatus == .notDetermined
            {
                AVCaptureDevice.requestAccess(for: .video)
                { _ in
                    authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
                }
            }
            else
            {
                modalViewPresenterManager.presentModal(presentationStart: .top, isBlockingBackground: false, isShadowEnabled: true)
                {
                    let systemSymbolName = "video.slash.fill"
                    let title = "Camera Access"
                    let description = "Your authorization is required in order to use the Camera. Tap to go to Settings."
                    
                    return AnyView(
                        DialogBoxView(systemSymbolName: systemSymbolName, title: title, description: description, isTappable: true)
                        {
                            UIApplication.openSettings()
                        }
                        .margin(.all)
                    )
                }
            }
        }
    }
}
