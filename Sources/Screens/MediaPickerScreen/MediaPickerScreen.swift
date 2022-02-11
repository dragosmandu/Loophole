//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: MediaPickerScreen.swift
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

public struct MediaPickerScreen
{
    /// Checks the current authorization status for Photos Library and request authorization if it's not determined yet.
    static func checkAuthorizationStatus(_ completion: @escaping (_ authorizationStatus: PHAuthorizationStatus) -> Void)
    {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch authorizationStatus
        {
            case .notDetermined:
                
                PHPhotoLibrary.requestAuthorization(for: .readWrite)
                { authorizationStatus in
                    completion(authorizationStatus)
                }
                
            default:
                completion(authorizationStatus)
        }
    }
    
    /// Presents the modal when the Photos Library authorization isn't .authorized. On modal tap will send to Settings.
    static func presentUnauthorizedDialogBox(modalViewPresenterManager: ModalViewPresenter.Manager)
    {
        modalViewPresenterManager.presentModal(presentationStart: .top, isBlockingBackground: false, isShadowEnabled: true)
        {
            let systemSymbolName = "photo.fill.on.rectangle.fill"
            let title = "Photos Library Access"
            let description = "Your authorization is required in order to access Photos Library. Tap to go to Settings."
            
            return AnyView(
                DialogBoxView(systemSymbolName: systemSymbolName, title: title, description: description, isTappable: true)
                {
                    UIApplication.openSettings()
                }
                .margin(.all)
            )
        }
    }
}

