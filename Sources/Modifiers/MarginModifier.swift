//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: MarginModifier.swift
//  Creation: 4/9/21 5:54 PM
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

struct MarginModifier: ViewModifier
{
    /// The padding factor used to set a padding that should be used as a margin.
    static var paddingFactor: Int = 4
    
    static var marginSize: CGFloat
    {
        return CGFloat(paddingFactor) * PaddingModifier.paddingUnitSize
    }
    
    private let edges: Edge.Set
    private let factor: Int
    
    init(edges: Edge.Set, factor: Int)
    {
        self.edges = edges
        self.factor = factor
    }
    
    func body(content: Content) -> some View
    {
        content
            .padding(edges, factor: MarginModifier.paddingFactor * factor)
    }
}
