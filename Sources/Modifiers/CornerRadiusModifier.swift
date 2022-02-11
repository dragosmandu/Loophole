//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: CornerRadiusModifier.swift
//  Creation: 4/9/21 6:01 PM
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

struct CornerRadiusModifier: ViewModifier
{
    private let cornerRadius: CGFloat
    
    init(cornerRadius: CGFloat)
    {
        self.cornerRadius = cornerRadius
    }
    
    func body(content: Content) -> some View
    {
        content
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}
