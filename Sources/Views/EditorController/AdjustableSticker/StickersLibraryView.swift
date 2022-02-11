//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.3
//			
//  File Name: StickersLibraryView.swift
//  Creation: 5/11/21 1:28 PM
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

struct StickersLibraryView: View
{
    private let stickerFont = Font.system(size: UIScreen.main.bounds.size.width / 4).weight(.regular)
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @Binding private var selectedSticker: Sticker?
    @Binding private var isPresented: Bool
    
    init(isPresented: Binding<Bool>, selectedSticker: Binding<Sticker?>)
    {
        _isPresented = isPresented
        _selectedSticker = selectedSticker
    }
    
    var body: some View
    {
        ZStack(alignment: .topTrailing)
        {
            VStack(alignment: .center)
            {
                stickersLibraryTitleView
                    .margin(.all)
                    .margin(.bottom)
                
                ScrollView(.vertical, showsIndicators: false)
                {
                    LazyVStack(alignment: .center, spacing: 0)
                    {
                        ForEach (Sticker.Set.allCases, id: \.self)
                        { stickerSet in
                            ScrollView(.horizontal, showsIndicators: false)
                            {
                                LazyHStack(alignment: .center, spacing: 0)
                                {
                                    ForEach (0..<stickerSet.stickers.count)
                                    { index in
                                        let sticker = stickerSet.stickers[index]
                                        
                                        if index != stickerSet.stickers.count - 1
                                        {
                                            selectableStickerView(sticker: sticker)
                                                .margin(.trailing, factor: 2)
                                        }
                                        else
                                        {
                                            selectableStickerView(sticker: sticker)
                                        }
                                    }
                                }
                            }
                            .margin(.vertical)
                            .margin(.bottom)
                        }
                    }
                }
                .background(colorScheme.whiteComplement)
                .cornerRadius(Constant.cornerRadius)
                
                // Margin bottom for iPhone SE like.
                .margin(UIApplication.safeAreaInsets.bottom == 0 ? [.bottom, .horizontal] : [.horizontal])
            }
            
            closeButtonView
        }
        .onAppear
        {
            selectedSticker = nil
        }
    }
    
    private var stickersLibraryTitleView: some View
    {
        let length = UIFont.preferredFont(forTextStyle: .title2).pointSize * 1.2
        
        return HStack(alignment: .center, spacing: 0)
        {
            Text("Stickers")
                .padding(.trailing, factor: 2)
            
            LinearGradient(gradient: Gradient(colors: [colorScheme.red, colorScheme.violet]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .frame(width: length, height: length, alignment: .center)
                .mask(
                    Image("Sticker")
                        .font(Font.system(size: length, weight: .bold))
                )
            
            Spacer()
        }
        .font(Font.title2.weight(.semibold))
        .foregroundColor(colorScheme.blackComplement)
        .lineLimit(1)
    }
    
    private var closeButtonView: some View
    {
        Button
        {
            isPresented = false
        }
        label:
        {
            Image(systemName: CloseButtonView.systemSymbolName)
                .font(CloseButtonView.font.weight(CloseButtonView.fontWeight))
                .foregroundColor(colorScheme.gray)
                .padding(.all, factor: CloseButtonView.paddingFactor)
                .backgroundBlur(isActive: true)
                .clipShape(Circle())
                .margin(.all)
        }
    }
    
    private func selectableStickerView(sticker: Sticker) -> some View
    {
        Button
        {
            if selectedSticker == sticker
            {
                selectedSticker = nil
            }
            else
            {
                selectedSticker = sticker
                isPresented =  false
            }
        }
        label:
        {
            StickerView(font: .constant(stickerFont), sticker: sticker)
        }
    }
}
