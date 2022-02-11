//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.3
//			
//  File Name: DeleteOverlayElementButtonView.swift
//  Creation: 5/17/21 4:09 PM
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

struct DeleteOverlayElementButtonView: View
{
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @Binding private var isDisabled: Bool
    
    private let onTapAction: () -> Void
    
    init(isDisabled: Binding<Bool>, _ onTapAction: @escaping () -> Void)
    {
        _isDisabled = isDisabled
        self.onTapAction = onTapAction
    }
    
    var body: some View
    {
        let uiFont = UIFont.preferredFont(forTextStyle: .title3)
        
        return Button
        {
            onTapAction()
        }
        label:
        {
            Image(systemName: CloseButtonView.systemSymbolName)
                .font(Font.title3.weight(.bold))
                .foregroundColor(colorScheme.white)
                .padding(.all, factor: 1)
        }
        .offset(x: uiFont.pointSize / 2, y: -uiFont.pointSize / 2)
        .disabled(isDisabled)
    }
}
