//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: MediaPickerScreenView.swift
//  Creation: 4/9/21 7:57 PM
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

extension MediaPickerScreen
{
    struct MediaPickerScreenView: View
    {
        @Environment(\.colorScheme) private var colorScheme: ColorScheme
        
        @Binding private var isPresented: Bool
        @Binding private var selectedAssets: [Int : PHAsset]
        
        private let maxNoSelectedAssets: Int
        
        init(isPresented: Binding<Bool>, selectedAssets: Binding<[Int : PHAsset]>, maxNoSelectedAssets: Int)
        {
            _isPresented = isPresented
            _selectedAssets = selectedAssets
            self.maxNoSelectedAssets = maxNoSelectedAssets
        }
        
        var body: some View
        {
            ZStack(alignment: .topTrailing)
            {
                PhotosLibraryView(selectedAssets: $selectedAssets, maxNoSelectedAssets: maxNoSelectedAssets)
                
                MediaPickerScreenDismissButtonView(selectedAssets: $selectedAssets, isPresented: $isPresented, maxNoSelectedAssets: maxNoSelectedAssets)
            }
            .onAppear
            {
                selectedAssets.removeAll() // Stars with a clean asset selection.
            }
        }
    }
}

