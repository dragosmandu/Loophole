//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: ShadowModifier.swift
//  Creation: 4/9/21 8:06 PM
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

public struct ShadowModifier: ViewModifier
{
    public static var shadowRadius: CGFloat = 3.5
    
    private let isActive: Bool
    
    init(_ isActive: Bool)
    {
        self.isActive = isActive
    }
    
    public func body(content: Content) -> some View
    {
        Group
        {
            if isActive
            {
                content
                    .shadow(radius: ShadowModifier.shadowRadius)
            }
            else
            {
                content
            }
        }
    }
}
