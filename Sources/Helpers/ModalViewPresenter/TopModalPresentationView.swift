//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: TopModalPresentationView.swift
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
    /// A modal that starts it's presentation from the top of the device screen.
    struct TopModalPresentationView: View
    {
        private static var startOffset: CGFloat = -UIScreen.main.bounds.height
        
        private static var minDismissOffset: CGFloat = -UIScreen.main.bounds.height * 0.05
        
        @EnvironmentObject private var manager: Manager
        
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
                .simultaneousGesture(manager.isGestureDismissable ? dismissGesture : nil)
                .onAppear
                {
                    /// Sets the starting point of the content, which shouldn't not on user's visual screen.
                    currentOffset = TopModalPresentationView.startOffset
                    
                    withAnimation(presentAnimation)
                    {
                        /// The content will slide down in the default position.
                        currentOffset = 0
                    }
                }
                .observeAnimation(for: currentOffset)
                { (currentOffset) in
                    
                    // Update content blocker opacity to show it may be dismissed.
                    let newContentBlockerOpacity = getContentBlockerOpacity(currentOffset: currentOffset, startOffset: TopModalPresentationView.startOffset).roundWith(fractionDigits: 2)
                    
                    if newContentBlockerOpacity != contentBlockerOpacity
                    {
                        contentBlockerOpacity = newContentBlockerOpacity
                    }
                }
                endedHandler:
                {
                    
                    // Update content blocker opacity to show it may be dismissed.
                    let newContentBlockerOpacity = getContentBlockerOpacity(currentOffset: currentOffset, startOffset: TopModalPresentationView.startOffset).roundWith(fractionDigits: 2)
                    
                    if newContentBlockerOpacity != contentBlockerOpacity
                    {
                        contentBlockerOpacity = newContentBlockerOpacity
                    }
                }
                .onChange(of: currentOffset)
                { _ in
                    
                    // Update content blocker opacity to show it may be dismissed.
                    let newContentBlockerOpacity = getContentBlockerOpacity(currentOffset: currentOffset, startOffset: TopModalPresentationView.startOffset).roundWith(fractionDigits: 2)
                    
                    if newContentBlockerOpacity != contentBlockerOpacity
                    {
                        contentBlockerOpacity = newContentBlockerOpacity
                    }
                    
                    if currentOffset <= TopModalPresentationView.startOffset
                    {
                        manager.dismiss()
                    }
                }
                .onChange(of: manager.isPresented)
                { isPresented in
                    if !isPresented
                    {
                        withAnimation(dismissAnimation)
                        {
                            currentOffset = TopModalPresentationView.startOffset
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
                        
                        let maxOffset = -TopModalPresentationView.minDismissOffset
                        
                        if translation <= maxOffset
                        {
                            currentOffset = translation
                        }
                        else
                        {
                            currentOffset = maxOffset
                        }
                    }
                )
                .onEnded(
                    { (value) in
                        if currentOffset > TopModalPresentationView.minDismissOffset
                        {
                            withAnimation(presentAnimation)
                            {
                                currentOffset = 0
                            }
                        }
                        else if currentOffset <= TopModalPresentationView.minDismissOffset
                        {
                            withAnimation(dismissAnimation)
                            {
                                currentOffset = TopModalPresentationView.startOffset
                            }
                        }
                    }
                )
        }
    }
}

