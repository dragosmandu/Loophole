//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: CameraControllerView.swift
//  Creation: 4/10/21 2:24 PM
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

struct CameraControllerView: View
{
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @Binding private var isRecording: Bool
    @Binding private var torchMode: AVCaptureDevice.TorchMode
    @Binding private var selectedAssets: [Int : PHAsset]
    @Binding private var currentCaptureFileType: CaptureButtonView.CaptureFileType
    
    init(isRecording: Binding<Bool>, torchMode: Binding<AVCaptureDevice.TorchMode>, selectedAssets: Binding<[Int : PHAsset]>, currentCaptureFileType: Binding<CaptureButtonView.CaptureFileType>)
    {
        _isRecording = isRecording
        _torchMode = torchMode
        _selectedAssets = selectedAssets
        _currentCaptureFileType = currentCaptureFileType
    }
    
    var body: some View
    {
        let backgroundColor = colorScheme.black.transparent().opacity(isRecording ? 0 : 1)
        
        VStack(alignment: .center, spacing: 0)
        {
            if !isRecording
            {
                CurrentCaptureFileTypeView(currentCaptureFileType: $currentCaptureFileType)
                    .transition()
            }
            
            ZStack(alignment: .center)
            {
                CaptureControllerView(currentCaptureFileType: $currentCaptureFileType, isRecording: $isRecording)
                    .margin(.all)
                
                Group
                {
                    if !isRecording
                    {
                        HStack(alignment: .center, spacing: 0)
                        {
                            TorchModeButtonView(torchMode: $torchMode)
                            
                            Spacer()
                            
                            MediaPickerButtonView(selectedAssets: $selectedAssets)
                        }
                        .transition()
                    }
                }
            }
            .background(backgroundColor)
            .cornerRadius(Constant.cornerRadius)
            .margin([.bottom, .horizontal])
        }
    }
}

