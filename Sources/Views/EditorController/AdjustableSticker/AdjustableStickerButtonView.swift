//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.3
//			
//  File Name: AdjustableStickerButtonView.swift
//  Creation: 5/11/21 10:20 AM
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

public struct AdjustableStickerButtonView: View
{
    /// The maximum number of stickers that can be added.
    public static var maxAdjustableStickerCounter: Int = 5
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @State private var isPresented: Bool = false
    @State private var selectedSticker: Sticker? = nil
    
    @Binding private var adjustableStickerViews: [AdjustableStickerView]
    
    public init(adjustableStickerViews: Binding<[AdjustableStickerView]>)
    {
        _adjustableStickerViews = adjustableStickerViews
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
        .fullScreenCover(isPresented: $isPresented)
        {
            isPresented = false
            addNewStickerView()
        }
        content:
        {
            StickersLibraryView(isPresented: $isPresented, selectedSticker: $selectedSticker)
        }
    }
    
    private func addNewStickerView()
    {
        if let selectedSticker = selectedSticker
        {
            if adjustableStickerViews.count < AdjustableStickerButtonView.maxAdjustableStickerCounter
            {
                let adjustableStickerView = AdjustableStickerView(adjustableStickerViews: $adjustableStickerViews, sticker: selectedSticker)
                
                adjustableStickerView.stickerProperties.index = adjustableStickerViews.count
                adjustableStickerViews.append(adjustableStickerView)
            }
        }
    }
    
    private var buttonLabelView: some View
    {
        let font: Font = .system(size: Constant.fontSize * 1.22, weight: .bold)
        
        return Image("Sticker")
            .font(font)
            .foregroundColor(colorScheme.white)
            .margin([.top, .horizontal])
    }
}
