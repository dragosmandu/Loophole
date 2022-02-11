//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: MediaPickerScreenDismissButtonView.swift
//  Creation: 4/9/21 7:56 PM
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
    struct MediaPickerScreenDismissButtonView: View
    {
        @Environment(\.colorScheme) private var colorScheme: ColorScheme
        
        @Binding private var isPresented: Bool
        @Binding private var selectedAssets: [Int : PHAsset]
        
        private let maxNoSelectedAssets: Int
        
        /// - Parameters:
        ///   - selectedAssets: The current selected assets, if any.
        ///   - isPresented: Shows if the media picker is presented.
        ///   - maxNoSelectedAssets: The max number of possible selected assets.
        init(selectedAssets: Binding<[Int : PHAsset]>, isPresented: Binding<Bool>, maxNoSelectedAssets: Int)
        {
            _selectedAssets = selectedAssets
            _isPresented = isPresented
            self.maxNoSelectedAssets = maxNoSelectedAssets
        }
        
        var body: some View
        {
            
            HStack(alignment: .center, spacing: 0)
            {
                if selectedAssets.count == 0
                {
                    Spacer()
                }
                
                closeButtonView
                
                if selectedAssets.count > 0
                {
                    Spacer()
                    
                    chooseButtonView
                        .margin(.horizontal)
                }
            }
            .animation(selectedAssets.count > 0 ? .viewInsertionAnimation : .viewRemovalAnimation)
        }
        
        private var closeButtonView: some View
        {
            return CloseButtonView(isTranslucent: true)
            {
                selectedAssets.removeAll() // Dismissing all the selected assets.
                isPresented = false
            }
        }
        
        private var chooseButtonView: some View
        {
            return Button
            {
                isPresented = false
            }
            label:
            {
                let paddingFactor = 2
                
                // Shows how many assets are selected and how many are remaining to select.
                Text("Choose \(selectedAssets.count)/\(maxNoSelectedAssets)")
                    .font(CloseButtonView.font.weight(.semibold))
                    .foregroundColor(colorScheme.white)
                    .padding(.vertical, factor: paddingFactor)
                    .padding(.horizontal, factor: paddingFactor * 2)
                    .backgroundBlur()
                    .clipShape(Capsule(style: .continuous))
                    .animation(nil)
            }
        }
    }
}

