//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: AnyTransition+Ext.swift
//  Creation: 4/9/21 2:19 PM
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

public extension AnyTransition
{
    // MARK: - Constants & Variables
    
    /// An opacity based transition for a View insertion.
    static var viewInsertionTransition: AnyTransition
    {
        AnyTransition
            .opacity
            .animation(.viewInsertionAnimation)
    }
    
    /// An opacity based transition for a View removal.
    static var viewRemovalTransition: AnyTransition
    {
        AnyTransition
            .opacity
            .animation(.viewRemovalAnimation)
    }
    
    /// An asymmetryic opacity based transition for a View insertion and removal.
    static var viewTransition: AnyTransition
    {
        AnyTransition
            .asymmetric(insertion: .viewInsertionTransition, removal: viewRemovalTransition)
    }
}
