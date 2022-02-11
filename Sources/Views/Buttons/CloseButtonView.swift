//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: CloseButtonView.swift
//  Creation: 4/13/21 7:13 PM
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

public struct CloseButtonView: View
{
    public static var systemSymbolName = "xmark"
    public static var font: Font = .subheadline
    public static var fontSize: CGFloat = UIFont.preferredFont(forTextStyle: .subheadline).pointSize
    public static var fontWeight: Font.Weight = .bold
    public static var paddingFactor: Int = 2
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    private let isTranslucent: Bool
    private let onTapAction: () -> Void
    
    public init(isTranslucent: Bool = false, _ onTapAction: @escaping () -> Void)
    {
        self.isTranslucent = isTranslucent
        self.onTapAction = onTapAction
    }
    
    public var body: some View
    {
        Button
        {
            onTapAction()
        }
        label:
        {
            let background = isTranslucent ? nil : colorScheme.red
            
            Image(systemName: CloseButtonView.systemSymbolName)
                .font(CloseButtonView.font.weight(CloseButtonView.fontWeight))
                .foregroundColor(colorScheme.white)
                .padding(.all, factor: CloseButtonView.paddingFactor)
                .background(background)
                .backgroundBlur(isActive: isTranslucent)
                .clipShape(Circle())
                .margin(.all)
        }
    }
}

struct CloseButtonView_Previews: PreviewProvider
{
    static var previews: some View
    {
        VStack
        {
            CloseButtonView(isTranslucent: true)
            {
                
            }
            
            CloseButtonView(isTranslucent: false)
            {
                
            }
        }
    }
}

