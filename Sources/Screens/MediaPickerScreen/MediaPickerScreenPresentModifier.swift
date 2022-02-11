//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: MediaPickerScreenPresentModifier.swift
//  Creation: 4/9/21 7:56 PM
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
import PhotosUI

extension MediaPickerScreen
{
    struct MediaPickerScreenPresentModifier: ViewModifier
    {
        @EnvironmentObject private var modalViewPresenterManager: ModalViewPresenter.Manager
        
        @State private var authorizationStatus: PHAuthorizationStatus = .notDetermined
        
        @Binding private var isPresented: Bool
        @Binding private var selectedAssets: [Int : PHAsset]
        
        private let maxNoSelectedAssets: Int
        
        init(isPresented: Binding<Bool>, selectedAssets: Binding<[Int : PHAsset]>, maxNoSelectedAssets: Int)
        {
            _isPresented = isPresented
            _selectedAssets = selectedAssets
            self.maxNoSelectedAssets = maxNoSelectedAssets
        }
        
        func body(content: Content) -> some View
        {
            DispatchQueue.main.async
            {
                isPresented = isPresented && authorizationStatus == .authorized
            }
            
            return content
                .onChange(of: isPresented)
                { _ in
                    checkAuthorizationStatus
                    { (authorizationStatus) in
                        if authorizationStatus != .authorized
                        {
                            isPresented = false
                            presentUnauthorizedDialogBox(modalViewPresenterManager: modalViewPresenterManager)
                        }
                        
                        self.authorizationStatus = authorizationStatus
                    }
                }
                .onChange(of: authorizationStatus)
                { _ in
                    
                    // Updates the authorization status in order to check if the request for authorization was rejected and show the modal.
                    checkAuthorizationStatus
                    { (authorizationStatus) in
                        if authorizationStatus != .authorized
                        {
                            isPresented = false
                            presentUnauthorizedDialogBox(modalViewPresenterManager: modalViewPresenterManager)
                        }
                        
                        self.authorizationStatus = authorizationStatus
                    }
                }
                .fullScreenCover(isPresented: $isPresented)
                {
                    MediaPickerScreenView(isPresented: $isPresented, selectedAssets: $selectedAssets, maxNoSelectedAssets: maxNoSelectedAssets)
                }
        }
    }
    
}
