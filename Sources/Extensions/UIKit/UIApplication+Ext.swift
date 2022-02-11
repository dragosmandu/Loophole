//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: UIApplication+Ext.swift
//  Creation: 4/9/21 7:59 PM
//
//  Company: Thecircle LLC 
//  Contact: dev@thecircle.xyz
//  Website: https://thecircle.xyz
//  Author: Dragos-Costin Mandu
//
//  Copyright © 2021 Thecircle LLC. All rights reserved.
//
//


import UIKit

public extension UIApplication
{
    // MARK: - Constants & Variables
    
    static var safeAreaInsets: UIEdgeInsets
    {
        let window = UIApplication.shared.windows[0]
        
        return window.safeAreaInsets
    }
}

public extension UIApplication
{
    // MARK: - Methods
    
    static func openSettings()
    {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString)
        {
            if UIApplication.shared.canOpenURL(settingsURL)
            {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
    }
}
