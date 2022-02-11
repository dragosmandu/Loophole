//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: ModalViewPresenterManager.swift
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

public extension ModalViewPresenter
{
    class Manager: ObservableObject
    {
        /// Shows if the current modal is presented or not.
        @Published private(set) var isPresented: Bool = false
        
        /// The modal content to be presented.
        @Published private(set) var content: AnyView?
        
        /// The edge that the modal content should be presented from.
        @Published private(set) var presentationStart: PresentationStart = .unknown
        
        /// If true, will add a transparent background to the modal, covering the entire screen, that will partially block the View under it.
        private(set) var isBlockingBackground: Bool = false
        
        /// If true, the modal content will have a shadow.
        private(set) var isShadowEnabled: Bool = false
        
        private(set) var isGestureDismissable: Bool = true
        
        public init()
        {
            
        }
        
        /// - Parameters:
        ///   - presentationStart: Shows the start point of the modal.
        ///   - isBlockingBackground: Shows if the background should be blocked by a transparent View.
        ///   - isShadowEnabled: Shows if the content should have a shadow or not.
        ///   - initialCenterPosition: The initial x,y coordinates of the modal's center.
        ///   - modalContent: The modal to be presented.
        public func presentModal(presentationStart: PresentationStart, isBlockingBackground: Bool = false, isShadowEnabled: Bool = false, isGestureDismissable: Bool = true, @ViewBuilder modalContent: @escaping () -> AnyView)
        {
            // It means the previous modal wasn't dismissed yet.
            if self.isPresented
            {
                dismiss()
            }
            
            // Waiting to be sure the previous animated has finished.
            DispatchQueue.main.asyncAfter(deadline: .now() + ModalViewPresenter.dismissAnimationDuration)
            {
                self.presentationStart = presentationStart
                self.isBlockingBackground = isBlockingBackground
                self.isGestureDismissable = isGestureDismissable
                self.isShadowEnabled = isShadowEnabled
                self.content = modalContent()
                self.isPresented = true
            }
        }
        
        /// Dismisses and resets the previous modal values.
        public func dismiss()
        {
            self.isPresented = false
            
            /// Clean the previous content while giving it enough time in order to complete it's animation.
            DispatchQueue.main.asyncAfter(deadline: .now() + ModalViewPresenter.dismissAnimationDuration)
            {
                self.content = nil
                self.presentationStart = .unknown
                self.isBlockingBackground = false
                self.isGestureDismissable = true
                self.isShadowEnabled = false
            }
        }
    }
}

