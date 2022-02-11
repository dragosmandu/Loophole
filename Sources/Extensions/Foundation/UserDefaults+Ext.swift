//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: UserDefaults+Ext.swift
//  Creation: 4/23/21 8:11 AM
//
//  Company: Thecircle LLC 
//  Contact: dev@thecircle.xyz
//  Website: https://thecircle.xyz
//  Author: Dragos-Costin Mandu
//
//  Copyright © 2021 Thecircle LLC. All rights reserved.
//
//


import Foundation

extension UserDefaults
{
    // MARK: - Constants & Variables
    
    static var appInstallTimestamp: Double
    {
        guard let appInstallTimestamp = UserDefaults.standard.object(forKey: Key.appInstallTimestampKey), appInstallTimestamp is Double
        else
        {
            return 0
        }
        
        return appInstallTimestamp as! Double
    }
    
    static var reviewRequestCounter: Int
    {
        guard let reviewRequestCounter = UserDefaults.standard.object(forKey: Key.reviewRequestCounterKey), reviewRequestCounter is Int
        else
        {
            return 0
        }
        
        return reviewRequestCounter as! Int
    }
    
    static var isHDQuality: Bool
    {
        guard let isHDQuality = UserDefaults.standard.object(forKey: Key.isHDQualityKey),
              isHDQuality is Bool
        else
        {
            return true
        }
        
        return isHDQuality as! Bool
    }
    
    static var captureDelay: Double
    {
        guard let captureDelay = UserDefaults.standard.object(forKey: Key.captureDelayKey), captureDelay is Double
        else
        {
            return 0.3
        }
        
        return captureDelay as! Double
    }
    
    static var interFrameDelay: Double
    {
        guard let interFrameDelay = UserDefaults.standard.object(forKey: Key.interFrameDelayKey), interFrameDelay is Double
        else
        {
            return 0.1
        }
        
        return interFrameDelay as! Double
    }
    
    static var videoFormatLoopCounter: Int
    {
        guard let videoFormatLoopCounter = UserDefaults.standard.object(forKey: Key.videoFormatLoopCounterKey), videoFormatLoopCounter is Int
        else
        {
            return 1
        }
        
        return videoFormatLoopCounter as! Int
    }
    
    static var hasInformedAboutAds: Bool
    {
        guard let hasInformedAboutAds = UserDefaults.standard.object(forKey: Key.hasInformedAboutAdsKey), hasInformedAboutAds is Bool
        else
        {
            return false
        }
        
        return hasInformedAboutAds as! Bool
    }
    
    static var createdLoopsCounter: Int
    {
        guard let createdLoopsCounter = UserDefaults.standard.object(forKey: Key.createdLoopsCounterKey), createdLoopsCounter is Int
        else
        {
            return 0
        }
        
        return createdLoopsCounter as! Int
    }
}

extension UserDefaults
{
    // MARK: - Objects
    
    struct Key
    {
        static let appInstallTimestampKey: String = Bundle.main.bundleIdentifier! + "-" + "AppInstallTimestampKey"
        static let reviewRequestCounterKey: String = Bundle.main.bundleIdentifier! + "-" + "ReviewRequestCounterKey"
        static let isHDQualityKey: String = Bundle.main.bundleIdentifier! + "-" + "IdHDQualityKey"
        static let captureDelayKey: String = Bundle.main.bundleIdentifier! + "-" + "CaptureDelayKey"
        static let interFrameDelayKey: String = Bundle.main.bundleIdentifier! + "-" + "InterFrameDelayKey"
        static let videoFormatLoopCounterKey: String = Bundle.main.bundleIdentifier! + "-" + "VideoFormatLoopCounterKey"
        static let hasInformedAboutAdsKey: String = Bundle.main.bundleIdentifier! + "-" + "HasInformedAboutAdsKey"
        static let createdLoopsCounterKey: String = Bundle.main.bundleIdentifier! + "-" + "CreatedLoopsCounterKey"
    }
}
