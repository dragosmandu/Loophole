//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: PhotosLibraryItemsView.swift
//  Creation: 4/9/21 7:48 PM
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

struct PhotosLibraryItemView: View
{
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    /// Updates when the image manager provides the requested image.
    @State private var uiImage: UIImage? = nil
    
    @State private var currentAsset: PHAsset? = nil
    @State private var isSelected: Bool = false
    
    @Binding private var selectedAssets: [Int : PHAsset]
    
    private let imageManager: PHImageManager = .init()
    private let fetchResult: PHFetchResult<PHAsset>
    private let index: Int
    private let itemSize: CGFloat
    private let maxNoSelectedAssets: Int
    
    init(selectedAssets: Binding<[Int : PHAsset]>, fetchResult: PHFetchResult<PHAsset>, index: Int, itemSize: CGFloat, maxNoSelectedAssets: Int)
    {
        _selectedAssets = selectedAssets
        self.fetchResult = fetchResult
        self.index = index
        self.itemSize = itemSize
        self.maxNoSelectedAssets = maxNoSelectedAssets
    }
    
    var body: some View
    {
        let shape = RoundedRectangle(cornerRadius: Constant.cornerRadius, style: .continuous)
        
        Group
        {
            if let uiImage = uiImage
            {
                ZStack(alignment: .center)
                {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: itemSize, height: itemSize)
                }
                .transition()
            }
            else
            {
                PlaceholderView()
                    .transition()
            }
        }
        .onAppear
        {
            requestImageAt(index: index)
        }
        .clipShape(shape)
        .contentShape(shape)
        .overlay(isSelectedOverlayView)
        .onAnimatedTapGesture(isActive: true)
        {
            isSelected.toggle()
            
            if isSelected, let currentAsset = currentAsset
            {
                if selectedAssets.count < maxNoSelectedAssets
                {
                    selectedAssets[index] = currentAsset
                }
                else
                {
                    isSelected.toggle()
                }
            }
            else
            {
                selectedAssets.removeValue(forKey: index)
            }
        }
    }
    
    private var isSelectedOverlayView: some View
    {
        Group
        {
            if isSelected
            {
                let borderItemSizeRatio: CGFloat = 0.02
                
                RoundedRectangle(cornerRadius: Constant.cornerRadius, style: .continuous)
                    .strokeBorder(colorScheme.blue, style: StrokeStyle(lineWidth: itemSize * borderItemSizeRatio, lineCap: .round, lineJoin: .round))
                    .transition()
            }
            else
            {
                EmptyView()
            }
        }
    }
    
    private func requestImageAt(index: Int)
    {
        currentAsset = fetchResult.object(at: index)
        
        guard let currentAsset = currentAsset
        else
        {
            return
        }
        
        let options = PHImageRequestOptions()
        
        // Target size is bigger than the item size in order to have a decent quality, without accupying the memory with the entire image.
        let targetSize = CGSize(width: itemSize * 2, height: itemSize * 2)
        let contentMode: PHImageContentMode = .aspectFill
        
        options.isNetworkAccessAllowed = true
        options.resizeMode = .fast
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        
        imageManager.requestImage(for: currentAsset, targetSize: targetSize, contentMode: contentMode, options: options)
        { (uiImage, _) in
            self.uiImage = uiImage
        }
    }
}

