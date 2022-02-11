//
//
//  Project Name: Thecircle 
//  Workspace: Untitled 12
//  MacOS Version: 11.2
//			
//  File Name: Loophole.swift
//  Creation: 4/9/21 12:48 PM
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

#if !targetEnvironment(simulator)
import AppLovinSDK
import GoogleMobileAds
#endif

@main
struct Loophole: App
{
    @State private var didFinishInitializingGADMobileSDK: Bool = false
    
    private let modalViewPresenterManager = ModalViewPresenter.Manager()
    
    init()
    {
        
    }
    
    var body: some Scene
    {
        WindowGroup
        {
            RootView()
                .contentShape(Rectangle())
                .setModalViewPresenter()
                .environmentObject(modalViewPresenterManager)
                .overlay(
                    Group
                    {
                        if !didFinishInitializingGADMobileSDK
                        {
                            LaunchScreenView(didFinishInitializingGADMobileSDK: $didFinishInitializingGADMobileSDK)
                                .transition(AnyTransition.opacity.animation(.easeOut))
                        }
                    }
                )
        }
    }
}
