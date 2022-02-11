//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: TransparencyModifier.swift
//  Creation: 4/9/21 5:58 PM
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

struct TransparencyModifier: ViewModifier
{
    /// The value that renders a maximum transparent View.
    static var maxTransparency: Double = 0.6
    
    /// The value that renders a View fully opaque.
    static var opaque: Double = 1
    
    private var isActive: Bool
    
    /// When isActive is false, the View is fully opaque.
    init(isActive: Bool)
    {
        self.isActive = isActive
    }
    
    func body(content: Content) -> some View
    {
        content
            .opacity(isActive ? TransparencyModifier.maxTransparency : TransparencyModifier.opaque)
    }
}
