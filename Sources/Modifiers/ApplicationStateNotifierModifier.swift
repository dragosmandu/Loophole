//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: ApplicationStateNotifierModifier.swift
//  Creation: 4/10/21 6:37 PM
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

public struct ApplicationStateNotifierModifier: ViewModifier
{
    public enum ApplicationState
    {
        case willEnterBackground
        case willEnterForeground
        case willTerminate
        case willShowKeyboard
        case willHideKeyboard
        
        fileprivate var notifName: NSNotification.Name
        {
            switch self
            {
                case .willEnterBackground:
                    return UIApplication.willResignActiveNotification
                    
                case .willEnterForeground:
                    return UIApplication.willEnterForegroundNotification
                    
                case .willTerminate:
                    return UIApplication.willTerminateNotification
                    
                case .willShowKeyboard:
                    return UIApplication.keyboardWillShowNotification
                    
                case .willHideKeyboard:
                    return UIApplication.keyboardWillHideNotification
            }
        }
    }
    
    private let appState: ApplicationState
    private let onReceiveAction: () -> Void
    
    /// - Parameters:
    ///   - appState: The state of the app in which the notification to be triggered.
    ///   - onReceiveAction: The action to be done when the notification for that state has launched.
    init(appState: ApplicationState, _ onReceiveAction: @escaping () -> Void)
    {
        self.appState = appState
        self.onReceiveAction = onReceiveAction
    }
    
    public func body(content: Content) -> some View
    {
        let notifCenter = NotificationCenter.default
        let notifPublisher = notifCenter.publisher(for: appState.notifName)
        
        return content
            .onAppear()
            .onReceive(notifPublisher)
            { _ in
                onReceiveAction()
            }
    }
}


