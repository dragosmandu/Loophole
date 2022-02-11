//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: ModalViewPresenterModifier.swift
//  Creation: 4/9/21 8:03 PM
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

extension ModalViewPresenter
{
    struct Modifier: ViewModifier
    {
        /// The maximum value of the opacity for the content blocker rectangle.
        static let maxContentBlockerOpacity: Double = 0.95
        
        @Environment(\.colorScheme) private var colorScheme: ColorScheme
        
        @EnvironmentObject private var manager: Manager
        
        @State private var contentBlockerOpacity: Double = Modifier.maxContentBlockerOpacity
        
        func body(content: Content) -> some View
        {
            let showModal = manager.content != nil && manager.presentationStart != .unknown
            let alignment: Alignment = manager.presentationStart == .top ? .top : manager.presentationStart == .center ? .center : .bottom
            
            return ZStack(alignment: alignment)
            {
                ZStack(alignment: .center)
                {
                    content
                    
                    // Block the content when the modal is presented and isBlockingBackground is true.
                    if showModal && manager.isBlockingBackground && manager.isPresented
                    {
                        let fillColor: Color = colorScheme.lightGrayComplement
                        
                        Rectangle()
                            .fill(fillColor.opacity(contentBlockerOpacity))
                            .edgesIgnoringSafeArea(.all)
                            .transition()
                    }
                }
                
                /// Present the modal content, if we have something to present.
                if showModal
                {
                    switch manager.presentationStart
                    {
                        case .top:
                            TopModalPresentationView(contentBlockerOpacity: $contentBlockerOpacity)
                            
                        case .bottom:
                            BottomModalPresentationView(contentBlockerOpacity: $contentBlockerOpacity)
                            
                        case .center:
                            CenterModalPresentationView(contentBlockerOpacity: $contentBlockerOpacity)
                            
                        default: EmptyView()
                    }
                }
            }
        }
    }
}
