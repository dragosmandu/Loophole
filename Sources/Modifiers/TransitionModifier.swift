//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: TransitionModifier.swift
//  Creation: 4/9/21 2:21 PM
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

struct TransitionModifier: ViewModifier
{
    init()
    {
        
    }
    
    func body(content: Content) -> some View
    {
        content
            .transition(.viewTransition)
    }
}
