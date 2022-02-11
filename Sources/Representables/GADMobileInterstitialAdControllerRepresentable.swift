//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.3
//			
//  File Name: GADMobileInterstitialAdControllerRepresentable.swift
//  Creation: 5/5/21 8:26 PM
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
import GoogleMobileAds

func initializeGADMobileSDK(_ completion: @escaping () -> Void)
{
    let sharedInstance = GADMobileAds.sharedInstance()
    
    //    sharedInstance.requestConfiguration.testDeviceIdentifiers = ["d9cd03c2025da329e8d0c19ed5b82d0e"]
    sharedInstance.start
    { _ in
        completion()
    }
}

struct GADMobileInterstitialAdControllerRepresentable: UIViewControllerRepresentable
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
        return GADMobileInterstitialAdController.shared
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context)
    {
        
    }
}

extension GADMobileInterstitialAdControllerRepresentable
{
    class Coordinator: NSObject
    {
        private var representable: GADMobileInterstitialAdControllerRepresentable!
        
        init(_ representable: GADMobileInterstitialAdControllerRepresentable)
        {
            self.representable = representable
            
            super.init()
            
            configureInterstitialAdController()
        }
        
        private func configureInterstitialAdController()
        {
            let sharedInstance = GADMobileInterstitialAdController.shared
            
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
            
            sharedInstance.onDidFailToPresentAction =
                {
                    
                    // All the retries failed to load an ad.
                    DispatchQueue.main.async
                    {
                        self.representable.isProcessingAd = false
                    }
                }
        }
    }
}
#endif
