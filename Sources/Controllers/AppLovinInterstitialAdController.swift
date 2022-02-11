//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.3
//			
//  File Name: AppLovinInterstitialAdController.swift
//  Creation: 5/3/21 7:23 PM
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
import UIKit
import AppLovinSDK

class AppLovinInterstitialAdController: UIViewController, MAAdDelegate
{
    static let shared: AppLovinInterstitialAdController = .init()
    
    private let adUnitID: String = "xxxxxxxxxxxxxxxx"
    private(set) var interstitialAd: MAInterstitialAd!
    private var retryAttempt = 0.0
    
    var onDidFailRetryAttemptAction: () -> Void = { }
    var onDidDisplayAction: () -> Void = { }
    var onDidHideAction: () -> Void = { }
    
    private init()
    {
        super.init(nibName: nil, bundle: nil)
        
        configureInterstitialAd()
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    private func configureInterstitialAd()
    {
        interstitialAd = MAInterstitialAd(adUnitIdentifier: adUnitID)
        
        interstitialAd.delegate = self
    }
    
    func retryLoadingAd()
    {
        if retryAttempt < 5
        {
            retryAttempt += 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1)
            {
                self.interstitialAd.load()
            }
        }
        else
        {
            retryAttempt = 0
            onDidFailRetryAttemptAction()
        }
    }
    
    // MARK: MAAdDelegate Protocol
    
    func didLoad(_ ad: MAAd)
    {
        if interstitialAd.isReady // Should be true.
        {
            retryAttempt = 0
        }
        else
        {
            retryLoadingAd()
        }
    }
    
    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withErrorCode errorCode: Int)
    {
        debugPrint(errorCode)
        
        // Interstitial ad failed to load. Pre-load the next ad.
        retryLoadingAd()
    }
    
    func didDisplay(_ ad: MAAd)
    {
        onDidDisplayAction()
    }
    
    func didClick(_ ad: MAAd) { }
    
    func didHide(_ ad: MAAd)
    {
        onDidHideAction()
    }
    
    func didFail(toDisplay ad: MAAd, withErrorCode errorCode: Int)
    {
        debugPrint(errorCode)
        
        // Interstitial ad failed to display. Pre-load the next ad.
        interstitialAd.load()
    }
}
#endif
