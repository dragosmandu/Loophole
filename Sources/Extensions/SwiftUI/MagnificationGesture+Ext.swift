//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: MagnificationGesture+Ext.swift
//  Creation: 4/9/21 2:17 PM
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

public extension MagnificationGesture
{
    // MARK: Constants & Variables
    
    /// The minimum magnitude to reach in order to set a fit equivalent content mode.
    static var mediaContentModeFitMinMagnitude: CGFloat = 0.75
    
    /// The minimum magnitude to reach in order to set a fill equivalent content mode.
    static var mediaContentModeFillMinMagnitude: CGFloat = 1.25
}
