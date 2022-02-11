//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: UIScreen+Ext.swift
//  Creation: 4/10/21 11:49 AM
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

extension UIScreen
{
    /// The minimum length of the current screen.
    static var minScreenLength: CGFloat
    {
        let mainScreenSize = UIScreen.main.bounds.size
        return min(mainScreenSize.width, mainScreenSize.height)
    }
}
