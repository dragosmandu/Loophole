//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: PlaceholderView.swift
//  Creation: 4/9/21 2:02 PM
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

public struct PlaceholderView: View
{
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    public init()
    {
        
    }
    
    public var body: some View
    {
        ZStack(alignment: .center)
        {
            Rectangle()
                .fill(colorScheme.black)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: colorScheme.gray))
                .scaleEffect(1.2)
        }
    }
}

struct PlaceholderView_Previews: PreviewProvider
{
    static var previews: some View
    {
        PlaceholderView()
    }
}

