//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: MediaPickerButtonView.swift
//  Creation: 4/15/21 11:13 AM
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

struct MediaPickerButtonView: View
{
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @State private var isPresented: Bool = false
    @State private var currentSelectedAssets: [Int: PHAsset] = [ : ]
    
    @Binding private var selectedAssets: [Int : PHAsset]
    
    init(selectedAssets: Binding<[Int : PHAsset]>)
    {
        _selectedAssets = selectedAssets
    }
    
    var body: some View
    {
        Button
        {
            isPresented = true
        }
        label:
        {
            let systemSymbolName = "photo.fill.on.rectangle.fill"
            
            Image(systemName: systemSymbolName)
                .font(Constant.font)
                .foregroundColor(colorScheme.white)
                .margin(.all)
        }
        .mediaPicker(isPresented: $isPresented, selectedAssets: $currentSelectedAssets, maxNoSelectedAssets: Constant.maxRecordedFrames)
        .onChange(of: isPresented)
        { _ in
            if !isPresented
            {
                selectedAssets = currentSelectedAssets
            }
            else
            {
                
                // Cleans the previous selected assets.
                currentSelectedAssets.removeAll()
            }
        }
    }
}
