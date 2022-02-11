//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.3
//			
//  File Name: AppLovinInterstitialAdControllerRepresentable.swift
//  Creation: 5/3/21 8:16 AM
//
//  Company: Thecircle LLC 
//  Contact: dev@thecircle.xyz
//  Website: https://thecircle.xyz
//  Author: Dragos-Costin Mandu
//
//  Copyright © 2021 Thecircle LLC. All rights reserved.
//
//


#if !targetEnvironment(simulator)
import SwiftUI
import AppLovinSDK

func initializeAppLovinSDK()
{
    let settings = ALSdkSettings()
    
    ALPrivacySettings.setHasUserConsent(false)
    ALPrivacySettings.setIsAgeRestrictedUser(true)
    
    settings.isVerboseLogging = true
    
    guard let sharedALSDK = ALSdk.shared(with: settings)
    else
    {
        return
    }
    
    sharedALSDK.mediationProvider = "max"
    sharedALSDK.initializeSdk()
}

struct AppLovinInterstitialAdControllerRepresentable: UIViewControllerRepresentable
{
    @Binding private var isProcessingAd: Bool
    @Binding private var didShowAdForLoop: Bool
    
    init(isProcessingAd: Binding<Bool>, didShowAdForLoop: Binding<Bool>)
    {
        self._isProcessingAd = isProcessingAd
        self._didShowAdForLoop = didShowAdForLoop
    }
    
    func makeCoordinator() -> Coordinator
    {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController
    {
        return AppLovinInterstitialAdController.shared
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context)
    {
        
    }
}

extension AppLovinInterstitialAdControllerRepresentable
{
    class Coordinator: NSObject
    {
        private var representable: AppLovinInterstitialAdControllerRepresentable!
        
        init(_ representable: AppLovinInterstitialAdControllerRepresentable)
        {
            self.representable = representable
            
            super.init()
            
            configureInterstitialAdController()
        }
        
        private func configureInterstitialAdController()
        {
            let sharedInstance = AppLovinInterstitialAdController.shared
            
            sharedInstance.onDidHideAction =
                {
                    DispatchQueue.main.async
                    {
                        self.representable.isProcessingAd = false
                    }
                }
            
            sharedInstance.onDidDisplayAction =
                {
                    
                    // Max one ad per loop, regardless the share/save count.
                    DispatchQueue.main.async
                    {
                        self.representable.didShowAdForLoop = true
                    }
                }
            
            sharedInstance.onDidFailRetryAttemptAction =
                {
                    
                    // All the retries failed to load an ad.
                    DispatchQueue.main.async
                    {
                        self.representable.isProcessingAd = false
                    }
                }
            
            if sharedInstance.interstitialAd.isReady
            {
                sharedInstance.interstitialAd.show()
            }
            else
            {
                DispatchQueue.main.async
                {
                    self.representable.isProcessingAd = false
                }
            }
        }
    }
}
#endif
