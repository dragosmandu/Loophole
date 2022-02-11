//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: DragIndicatorView.swift
//  Creation: 4/10/21 7:04 PM
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

public struct DragIndicatorView: View
{
    public static var width: CGFloat = 30
    public static var height: CGFloat = 7
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @Binding private var progress: CGFloat
    
    private let fillColor: Color?
    private let isTranslucent: Bool
    
    /// - Parameters:
    ///   - progress: Binding to the progress of a View in screen space that changes the indicator shape.
    ///   - fillColor: If not provided, will use a default color.
    ///   - isTranslucent: Adding a background blur instead of a color.
    public init(progress: Binding<CGFloat>, fillColor: Color? = nil, isTranslucent: Bool = false)
    {
        _progress = progress
        self.fillColor = fillColor
        self.isTranslucent = isTranslucent
    }
    
    public var body: some View
    {
        let currentOffset = DragIndicatorView.maxOffset * progress
        
        if isTranslucent
        {
            Rectangle()
                .fill(Color.clear)
                .backgroundBlur()
                .mask(dragIndicatorView)
                
                // Increases with offset on top and bottom.
                .frame(width: DragIndicatorView.width * 2, height: DragIndicatorView.height + currentOffset * 2, alignment: .center)
                .transition()
        }
        else
        {
            dragIndicatorView
                .transition()
        }
    }
    
    private var dragIndicatorView: some View
    {
        let currentOffset = DragIndicatorView.maxOffset * progress
        let fillColor = self.fillColor != nil ? self.fillColor! : colorScheme.lightGrayComplement
        
        return self
            .stroke(fillColor, style: StrokeStyle(lineWidth: DragIndicatorView.height, lineCap: .round, lineJoin: .round))
            
            // Increases with offset on top and bottom.
            .frame(width: DragIndicatorView.width, height: DragIndicatorView.height + currentOffset * 2, alignment: .center)
    }
}

extension DragIndicatorView: Shape
{
    /// The maximum positive Y axe offset of the indicator, that will make it look like an arrow.
    public static var maxOffset: CGFloat = 10
    
    public func path(in rect: CGRect) -> Path
    {
        let offset = DragIndicatorView.maxOffset * progress
        
        return Path
        { path in
            path.move(to: CGPoint(x: 0, y: rect.midY + offset))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.midY))
            
            path.move(to: CGPoint(x: rect.midX + 1, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY + offset))
        }
    }
}

struct DragIndicatorView_Previews: PreviewProvider
{
    static var previews: some View
    {
        VStack
        {
            DragIndicatorView(progress: .constant(0))
            DragIndicatorView(progress: .constant(1))
        }
    }
}
