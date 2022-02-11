//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: TorchModeButtonView.swift
//  Creation: 4/15/21 11:12 AM
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

public struct TorchModeButtonView: View
{
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @Binding private var torchMode: AVCaptureDevice.TorchMode
    
    public init(torchMode: Binding<AVCaptureDevice.TorchMode>)
    {
        _torchMode = torchMode
    }
    
    public var body: some View
    {
        Button
        {
            torchMode.toggle()
        }
        label:
        {
            Group
            {
                if torchMode == .auto
                {
                    torchModeView()
                }
                else if torchMode == .on
                {
                    torchModeView()
                }
                else
                {
                    torchModeView()
                }
            }
            .font(Constant.font)
            .foregroundColor(colorScheme.white)
        }
    }
    
    private func torchModeView() -> some View
    {
        Image(systemName: torchMode.systemSymbolName)
            .margin(.all)
            .transition()
    }
}
