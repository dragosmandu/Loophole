//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.3
//			
//  File Name: StickerView.swift
//  Creation: 5/11/21 2:13 PM
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

struct StickerView: View
{
    @Binding private var font: Font
    
    private let sticker: Sticker
    
    init(font: Binding<Font>, sticker: Sticker)
    {
        _font = font
        self.sticker = sticker
    }
    
    var body: some View
    {
        Image(sticker.symbolName)
            .resizable()
            .renderingMode(.original)
            .aspectRatio(contentMode: .fit)
            .foregroundColor(Color.clear)
            .font(font)
    }
}
