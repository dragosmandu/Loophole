//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: BackgroundBlurModifier.swift
//  Creation: 4/9/21 8:11 PM
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

struct BackgroundBlurModifier: ViewModifier
{
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    private let blurStyle: UIBlurEffect.Style?
    private let vibrancyStyle: UIVibrancyEffectStyle?
    private let isActive: Bool
    
    init(blurStyle: UIBlurEffect.Style?, vibrancyStyle: UIVibrancyEffectStyle?, isActive: Bool)
    {
        self.blurStyle = blurStyle
        self.vibrancyStyle = vibrancyStyle
        self.isActive = isActive
    }
    
    func body(content: Content) -> some View
    {
        var blurStyle: UIBlurEffect.Style! = self.blurStyle
        var vibrancyStyle: UIVibrancyEffectStyle! = self.vibrancyStyle
        
        if blurStyle == nil
        {
            blurStyle = colorScheme == .light ? .systemUltraThinMaterialLight : .systemUltraThinMaterialDark
        }
        
        if vibrancyStyle == nil
        {
            vibrancyStyle = .fill
        }
        
        return content
            .background(isActive ? VisualEffectBlurView(blurStyle: blurStyle, vibrancyStyle: vibrancyStyle) { } : nil)
    }
}

