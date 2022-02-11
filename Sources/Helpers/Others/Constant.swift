//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: Constant.swift
//  Creation: 4/9/21 5:55 PM
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

struct Constant
{
    static let version: Any = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")!
    static let build: Any = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion")!
    static let cornerRadius: CGFloat = 22
    
    /// The total maximum number of frames should be recorded/used for a single loop.
    static let maxRecordedFrames: Int = 20
    
    /// The total maximum number of loops created with no ad.
    static let createdLoopsWithNoAd: Int = 3
    
    /// The total maximum number of times should request review.
    static let maxReviewRequestCounter: Int = 2
    
    /// The total minimum number of seconds passed from app installation in order to request a review.
    static let minSecDurationFromInstallToRequestReview: Double = 2592000
    
    static var fontSize: CGFloat
    {
        return circleDiameter / 2.85
    }
    
    static var fontWeight: Font.Weight
    {
        return .semibold
    }
    
    static var font: Font
    {
        return .system(size: fontSize, weight: fontWeight)
    }
    
    /// The diameter of a default circle with a default ratio (minScreenLength * ratio).
    static var circleDiameter: CGFloat
    {
        return UIScreen.minScreenLength * 0.165
    }
    
    /// The border line width of a default circle with a default ratio (circleDiameter * ratio).
    static var circleBorderLineWidth: CGFloat
    {
        circleDiameter * 0.03
    }
}
