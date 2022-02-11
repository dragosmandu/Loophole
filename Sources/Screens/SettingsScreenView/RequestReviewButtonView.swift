//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.3
//			
//  File Name: RequestReviewButtonView.swift
//  Creation: 5/10/21 7:13 PM
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

extension SettingsScreenView
{
    struct RequestReviewButtonView: View
    {
        @Environment(\.colorScheme) private var colorScheme: ColorScheme
        
        init()
        {
            
        }
        
        var body: some View
        {
            Button
            {
                requestReview()
            }
            label:
            {
                HStack(alignment: .center, spacing: 0)
                {
                    Text("Rate Us")
                    
                    Spacer()
                    
                    Image(systemName: "star.fill")
                }
                .font(itemFont)
                .foregroundColor(colorScheme.red)
                .lineLimit(1)
                .margin(.all)
            }
            .background(colorScheme.lightGrayComplement)
            .cornerRadius(Constant.cornerRadius)
        }
        
        private func requestReview()
        {
            guard let writeReviewURL = URL(string: "https://apps.apple.com/app/id1561715454?action=write-review")
            else
            {
                return
            }
            
            UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
        }
    }
}
