//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: PaddingModifier.swift
//  Creation: 4/9/21 2:22 PM
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

public struct PaddingModifier: ViewModifier
{
    /// The unit that the padding increments by.
    public static var paddingUnitSize: CGFloat = 4
    
    private let edges: Edge.Set
    private let factor: CGFloat
    
    init(edges: Edge.Set, factor: Int)
    {
        self.edges = edges
        self.factor = CGFloat(factor)
    }
    
    public func body(content: Content) -> some View
    {
        let paddingSize = PaddingModifier.paddingUnitSize * factor
        
        return content
            .padding(edges, paddingSize)
    }
}

