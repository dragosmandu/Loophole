//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: VisualEffectBlurView.swift
//  Creation: 4/9/21 8:13 PM
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

public struct VisualEffectBlurView<Content>: View where Content: View
{
    private let blurStyle: UIBlurEffect.Style
    private let vibrancyStyle: UIVibrancyEffectStyle
    private let content: Content
    
    init(blurStyle: UIBlurEffect.Style, vibrancyStyle: UIVibrancyEffectStyle, @ViewBuilder content: () -> Content)
    {
        self.blurStyle = blurStyle
        self.vibrancyStyle = vibrancyStyle
        self.content = content()
    }
    
    public var body: some View
    {
        VisualEffectBlurViewRepresentable(content: content, blurStyle: blurStyle, vibrancyStyle: vibrancyStyle)
    }
}

struct VisualEffectBlurView_Previews: PreviewProvider
{
    static var previews: some View
    {
        VisualEffectBlurView(blurStyle: .regular, vibrancyStyle: .fill)
        {
            
        }
    }
}

