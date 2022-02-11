//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: ReverseAnimatedImageButtonView.swift
//  Creation: 4/13/21 2:08 PM
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

public struct ReverseAnimatedImageButtonView: View
{
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @Binding private var isReversed: Bool
    
    public init(isReversed: Binding<Bool>)
    {
        _isReversed = isReversed
    }
    
    public var body: some View
    {
        Button
        {
            isReversed.toggle()
        }
        label:
        {
            let systemSymbolName = "infinity"
            
            Group
            {
                if isReversed
                {
                    Image(systemName: systemSymbolName)
                        .font(Constant.font.weight(.bold))
                        .foregroundColor(colorScheme.blue)
                        .margin(.all)
                        .transition()
                }
                else
                {
                    Image(systemName: systemSymbolName)
                        .font(Constant.font)
                        .foregroundColor(colorScheme.white)
                        .margin(.all)
                        .transition()
                }
            }
        }
    }
}

