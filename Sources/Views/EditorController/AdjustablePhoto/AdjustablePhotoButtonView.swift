//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.3
//			
//  File Name: AdjustablePhotoButtonView.swift
//  Creation: 5/17/21 11:51 AM
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

public struct AdjustablePhotoButtonView: View
{
    /// The maximum number of photos that can be added.
    public static var maxAdjustablePhotoCounter: Int = 5
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @State private var isPresented: Bool = false
    @State private var selectedPhoto: [Int : PHAsset] = [ : ]
    
    @Binding private var adjustablePhotoViews: [AdjustablePhotoView]
    
    public init(adjustablePhotoViews: Binding<[AdjustablePhotoView]>)
    {
        _adjustablePhotoViews = adjustablePhotoViews
    }
    
    public var body: some View
    {
        Button
        {
            isPresented = true
        }
        label:
        {
            buttonLabelView
        }
        .mediaPicker(isPresented: $isPresented, selectedAssets: $selectedPhoto, maxNoSelectedAssets: 1)
        .onChange(of: isPresented)
        { isPresented in
            if !isPresented
            {
                addNewPhotoView()
            }
        }
    }
    
    private func addNewPhotoView()
    {
        if let selectedPhoto = selectedPhoto.first
        {
            if adjustablePhotoViews.count < AdjustablePhotoButtonView.maxAdjustablePhotoCounter
            {
                let adjustablePhotoView = AdjustablePhotoView(adjustablePhotoViews: $adjustablePhotoViews, selectedPhoto: selectedPhoto.value)
                
                adjustablePhotoView.photoProperties.index = adjustablePhotoViews.count
                adjustablePhotoViews.append(adjustablePhotoView)
            }
        }
    }
    
    private var buttonLabelView: some View
    {
        let font: Font = .system(size: Constant.fontSize, weight: Constant.fontWeight, design: .rounded)
        
        return Image(systemName: "photo")
            .font(font)
            .foregroundColor(colorScheme.white)
            .margin([.top, .horizontal])
    }
}

