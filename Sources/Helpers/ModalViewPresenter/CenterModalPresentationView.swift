//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: CenterModalPresentationView.swift
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
    /// A modal that starts it's presentation from the center of the device screen.
    struct CenterModalPresentationView: View
    {
        private static var minDismissOffset: CGFloat = UIScreen.main.bounds.height * 0.1
        
        private static let minViewScale: CGFloat = 0.001
        private static let maxViewScale: CGFloat = 1
        
        @EnvironmentObject private var manager: Manager
        
        @State private var currentScale: CGFloat = CenterModalPresentationView.minViewScale
        @State private var currentOffset: CGFloat = 0
        
        @Binding private var contentBlockerOpacity: Double
        
        init(contentBlockerOpacity: Binding<Double>)
        {
            _contentBlockerOpacity = contentBlockerOpacity
        }
        
        var body: some View
        {
            manager.content?
                .shadow(manager.isShadowEnabled)
                .offset(y: currentOffset)
                .scaleEffect(currentScale)
                .opacity(Double(currentScale))
                .simultaneousGesture(manager.isGestureDismissable ? dismissGesture : nil)
                .onAppear
                {
                    currentOffset = 0
                    
                    withAnimation(presentAnimation)
                    {
                        // Animated presentation of the modal.
                        currentScale = CenterModalPresentationView.maxViewScale
                    }
                }
                .observeAnimation(for: currentScale)
                { (currentScale) in
                    
                    // Update content blocker opacity to show it may be dismissed.
                    if Double(currentScale) != contentBlockerOpacity
                    {
                        contentBlockerOpacity = Double(currentScale)
                    }
                }
                endedHandler:
                {
                    
                    // Update content blocker opacity to show it may be dismissed.
                    if Double(currentScale) != contentBlockerOpacity
                    {
                        contentBlockerOpacity = Double(currentScale)
                    }
                }
                .onChange(of: currentScale)
                { _ in
                    
                    // Update content blocker opacity to show it may be dismissed.
                    if Double(currentScale) != contentBlockerOpacity
                    {
                        contentBlockerOpacity = Double(currentScale)
                    }
                    
                    if currentScale <= CenterModalPresentationView.minViewScale
                    {
                        manager.dismiss()
                    }
                }
                .onChange(of: currentOffset)
                { _ in
                    let startOffset = UIScreen.main.bounds.height
                    
                    // Update content blocker opacity to show it may be dismissed.
                    let newContentBlockerOpacity = getContentBlockerOpacity(currentOffset: currentOffset, startOffset: startOffset).roundWith(fractionDigits: 2)
                    
                    if newContentBlockerOpacity != contentBlockerOpacity
                    {
                        contentBlockerOpacity = newContentBlockerOpacity
                    }
                }
                .onChange(of: manager.isPresented)
                { isPresented in
                    if !isPresented
                    {
                        withAnimation(dismissAnimation)
                        {
                            currentScale = CenterModalPresentationView.minViewScale
                            currentOffset = 0
                        }
                    }
                }
                .transition()
        }
        
        private var dismissGesture: _EndedGesture<_ChangedGesture<DragGesture>>
        {
            DragGesture(minimumDistance: 5, coordinateSpace: .global)
                .onChanged(
                    { (value) in
                        let translation = value.translation.height
                        
                        currentOffset = translation
                    }
                )
                .onEnded(
                    { (value) in
                        if (currentOffset < CenterModalPresentationView.minDismissOffset && currentOffset >= 0) || (currentOffset > -CenterModalPresentationView.minDismissOffset && currentOffset <= 0)
                        {
                            withAnimation(presentAnimation)
                            {
                                currentOffset = 0
                            }
                        }
                        else
                        {
                            withAnimation(dismissAnimation)
                            {
                                currentScale = CenterModalPresentationView.minViewScale
                                currentOffset = 0
                            }
                        }
                    }
                )
        }
    }
}

