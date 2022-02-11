//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: RequestReview.swift
//  Creation: 4/22/21 9:49 PM
//
//  Company: Thecircle LLC 
//  Contact: dev@thecircle.xyz
//  Website: https://thecircle.xyz
//  Author: Dragos-Costin Mandu
//
//  Copyright © 2021 Thecircle LLC. All rights reserved.
//
//


import StoreKit

func requestReview()
{
    if let scene = UIApplication.shared.connectedScenes.first(
        where:
            {
                $0.activationState == .foregroundActive
            }
    ) as? UIWindowScene
    {
        SKStoreReviewController.requestReview(in: scene)
    }
}
