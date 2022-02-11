//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: ColorScheme+Ext.swift
//  Creation: 4/9/21 2:01 PM
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

public extension ColorScheme
{
    // MARK: - Constants & Variables
    
    var blue: Color
    {
        return self == .light ? .lightBlue : .darkBlue
    }
    
    var red: Color
    {
        return self == .light ? .lightRed : .darkRed
    }
    
    var green: Color
    {
        return self == .light ? .lightGreen : .darkGreen
    }
    
    var violet: Color
    {
        return self == .light ? .lightViolet : .darkViolet
    }
    
    var white: Color
    {
        return self == .light ? .lightWhite : .darkWhite
    }
    
    var whiteComplement: Color
    {
        return self == .light ? .lightWhiteComplement : .darkWhiteComplement
    }
    
    var lightGray: Color
    {
        return self == .light ? .lightLightGray : .darkLightGray
    }
    
    var lightGrayComplement: Color
    {
        return self == .light ? .lightLightGrayComplement : .darkLightGrayComplement
    }
    
    var gray: Color
    {
        return self == .light ? .lightGray : .darkGray
    }
    
    var darkGray: Color
    {
        return self == .light ? .lightDarkGray : .darkDarkGray
    }
    
    var darkGrayComplement: Color
    {
        return self == .light ? .lightDarkGrayComplement : .darkDarkGrayComplement
    }
    
    var black: Color
    {
        return self == .light ? .lightBlack : .darkBlack
    }
    
    var blackComplement: Color
    {
        return self == .light ? .lightBlackComplement : .darkBlackComplement
    }
}

