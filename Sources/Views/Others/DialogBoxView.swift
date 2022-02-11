//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: DialogBoxView.swift
//  Creation: 4/9/21 8:15 PM
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

public struct DialogBoxView: View
{
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    private let systemSymbolName: String
    private let title: String
    private let description: String
    private let isTappable: Bool
    private let onTapAction: () -> Void
    
    public init(systemSymbolName: String, title: String, description: String, isTappable: Bool, _ onTapAction: @escaping () -> Void = { })
    {
        self.systemSymbolName = systemSymbolName
        self.title = title
        self.description = description
        self.isTappable = isTappable
        self.onTapAction = onTapAction
    }
    
    public var body: some View
    {
        let maxWidth: CGFloat = 500 // The max width the dialog box can have.
        
        VStack(alignment: .leading, spacing: 0)
        {
            let paddingFactor = 2
            
            HStack(alignment: .center, spacing: 0)
            {
                let titleLineLimit = 1
                
                Image(systemName: systemSymbolName)
                    .font(Font.headline.weight(.semibold))
                    .foregroundColor(colorScheme.darkGrayComplement)
                    .padding(.trailing, factor: paddingFactor)
                
                Text(title)
                    .font(Font.subheadline.weight(.semibold))
                    .foregroundColor(colorScheme.blackComplement)
                    .lineLimit(titleLineLimit)
                
                Spacer()
            }
            
            let descriptionLineLimit = 3
            
            Text(description)
                .font(.subheadline)
                .lineLimit(descriptionLineLimit)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(colorScheme.darkGrayComplement)
                .padding(.top, factor: paddingFactor)
        }
        .frame(maxWidth: maxWidth)
        .margin(.all)
        .background(colorScheme.lightGrayComplement)
        .cornerRadius(Constant.cornerRadius)
        .onAnimatedTapGesture(isActive: isTappable)
        {
            onTapAction()
        }
    }
}

struct DialogBoxView_Previews: PreviewProvider
{
    static var previews: some View
    {
        VStack
        {
            DialogBoxView(systemSymbolName: "INSERT_SYMBOL_NAME", title: "INSERT_TITLE", description: "INSERT_DESCRIPTION", isTappable: true)
            {
                
            }
        }
    }
}


