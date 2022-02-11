//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: ShadowOverlayModifier.swift
//  Creation: 4/10/21 7:02 PM
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

public struct ShadowOverlayModifier: ViewModifier
{
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    private let startPoint: UnitPoint
    private let endPoint: UnitPoint
    private let heightRatio: CGFloat
    
    /// Adds a shadow gradient overlay on the current View.
    /// - Parameters:
    ///     - startPoint: The point where the shadow starts.
    ///     - endPoint: The point where the shadow ends.
    ///     - heightRatio: The ratio between the height of the overlay and the View.
    /// - Returns: A View with a shadow overlay.
    init(startPoint: UnitPoint, endPoint: UnitPoint, heightRatio: CGFloat)
    {
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.heightRatio = heightRatio
    }
    
    public func body(content: Content) -> some View
    {
        let startColor = colorScheme.black.opacity(TransparencyModifier.maxTransparency)
        let endColor = Color.clear
        let shadowGradient = LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: startPoint, endPoint: endPoint)
        
        return GeometryReader
        { proxy in
            ZStack(alignment: alignment)
            {
                content
                
                shadowGradient
                    .edgesIgnoringSafeArea(.all)
                    .frame(height: proxy.size.height * heightRatio, alignment: alignment)
            }
        }
    }
    
    private var alignment: Alignment
    {
        switch startPoint
        {
            case .top, .topTrailing, .topLeading:
                return .top
                
            case .bottom, .bottomTrailing, .bottomTrailing:
                return .bottom
                
            case .leading:
                return .leading
                
            case .trailing:
                return .trailing
                
            default:
                return .bottom
        }
    }
}


