//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.3
//			
//  File Name: GADMobileInterstitialAdController.swift
//  Creation: 5/5/21 8:32 PM
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
import GoogleMobileAds

class GADMobileInterstitialAdController: UIViewController, GADFullScreenContentDelegate
{
    static let shared: GADMobileInterstitialAdController = .init()
    
    private let adUnitID: String =  "ca-app-pub-7338460065613281/7244466320"
    private let maxRetryAttempts = 2.0
    private var interstitialAd: GADInterstitialAd?
    private var retryAttempt = 0.0
    private var requestSequenceID: UUID? = nil
    
    var canRequestAds: Bool = true
    var onDidFailToPresentAction: () -> Void = { }
    var onDidDisplayAction: () -> Void = { }
    var onDidHideAction: () -> Void = { }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        presentAd()
    }
    
    /// Presents the ad if possible.
    private func presentAd()
    {
        if let interstitialAd = interstitialAd
        {
            DispatchQueue.main.async
            {
                do
                {
                    try interstitialAd.canPresent(fromRootViewController: self)
                    interstitialAd.present(fromRootViewController: self)
                    
                    self.onDidDisplayAction()
                    
                    return
                }
                catch
                {
                    self.onDidFailToPresentAction()
                    debugPrint(error.localizedDescription)
                }
            }
        }
        else
        {
            onDidFailToPresentAction()
        }
    }
    
    /// Checks if we have a current request sequence or the given request sequence ID is the same with the given one.
    /// If there isn't a current request seq ID, will create one.
    private func shouldRequestAdWith(requestSequenceID: UUID?) -> Bool
    {
        let isAppInBackground = UIApplication.shared.applicationState != .background
        let shouldRequestAd = (
            self.requestSequenceID == nil ||
                (
                    self.requestSequenceID != nil && requestSequenceID == self.requestSequenceID
                )
        ) && isAppInBackground
        
        if self.requestSequenceID == nil && shouldRequestAd
        {
            
            // Set a new request sec ID if doesn't exist.
            self.requestSequenceID = UUID()
        }
        
        return shouldRequestAd
    }
    
    private func resetCurrentRequestSequence()
    {
        retryAttempt = 0
        self.requestSequenceID = nil // Request sequence failed, current reset ID.
        interstitialAd = nil
        onDidFailToPresentAction()
    }
    
    /// Requests a new add for current set ad unit ID. If fails, will retry loading ad with a new request, for max retry attempts requests.
    func loadAd(requestSequenceID: UUID? = nil)
    {
        if !canRequestAds
        {
            resetCurrentRequestSequence()
        }
        else if shouldRequestAdWith(requestSequenceID: requestSequenceID)
        {
            let request = GADRequest()
            
            GADInterstitialAd.load(withAdUnitID: adUnitID, request: request)
            { interstitialAd, error in
                guard let interstitialAd = interstitialAd, error == nil
                else
                {
                    debugPrint("Failed to load interstitial ad with error: \(error?.localizedDescription ?? "Invalid nil interstitial ad.")")
                    
                    // Interstitial ad failed to display. Pre-load the next ad.
                    self.retryLoadingAd(requestSequenceID: self.requestSequenceID)
                    
                    return
                }
                
                self.interstitialAd = interstitialAd
                self.interstitialAd?.fullScreenContentDelegate = self
                self.retryAttempt = 0
                self.requestSequenceID = nil // Request sequence succeeded, current reset ID.
            }
        }
    }
    
    private func retryLoadingAd(requestSequenceID: UUID?)
    {
        retryAttempt += 1
        
        if retryAttempt <= maxRetryAttempts
        {
            let delaySec = pow(2.0, min(maxRetryAttempts, retryAttempt))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delaySec)
            {
                self.loadAd(requestSequenceID: requestSequenceID)
            }
        }
        else
        {
            resetCurrentRequestSequence()
        }
    }
    
    // MARK: - GADFullScreenContentDelegate
    
    /// Tells the delegate that the ad presented full screen content.
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd)
    {
        onDidDisplayAction()
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd)
    {
        onDidHideAction()
    }
    
}
#endif
