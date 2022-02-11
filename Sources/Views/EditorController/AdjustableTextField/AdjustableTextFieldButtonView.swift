//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: AdjustableTextFieldButtonView.swift
//  Creation: 4/13/21 2:13 PM
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

public struct AdjustableTextFieldButtonView: View
{
    /// The maximum number of text fields that can be added.
    public static var maxAdjustableTextFieldCounter: Int = 5
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @ObservedObject private var keyboard: Keyboard = .init()
    
    @Binding private var adjustableTextFieldViews: [AdjustableTextFieldView]
    @Binding private var didFocusAdjustableTextField: Bool
    
    init(adjustableTextFieldViews: Binding<[AdjustableTextFieldView]>, didFocusAdjustableTextField: Binding<Bool>)
    {
        _adjustableTextFieldViews = adjustableTextFieldViews
        _didFocusAdjustableTextField = didFocusAdjustableTextField
    }
    
    public var body: some View
    {
        Button
        {
            if adjustableTextFieldViews.count < AdjustableTextFieldButtonView.maxAdjustableTextFieldCounter
            {
                let adjustableTextFieldView = AdjustableTextFieldView(adjustableTextFieldViews: $adjustableTextFieldViews, didFocusAdjustableTextField: $didFocusAdjustableTextField)
                
                adjustableTextFieldView.textProperties.index = adjustableTextFieldViews.count
                adjustableTextFieldViews.append(adjustableTextFieldView)
            }
        }
        label:
        {
            buttonLabelView
        }
    }
    
    private var buttonLabelView: some View
    {
        let font: Font = .system(size: Constant.fontSize, weight: Constant.fontWeight, design: .rounded)
        
        return Image(systemName: "textbox")
            .font(font)
            .foregroundColor(colorScheme.white)
            .margin([.top, .horizontal])
    }
}
