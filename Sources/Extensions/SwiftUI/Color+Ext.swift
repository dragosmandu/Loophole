//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: Color+Ext.swift
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

public extension Color
{
    // MARK: - Constructors
    
    init(hex: String)
    {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        
        switch hex.count
        {
            case 3: // RGB (12-bit)
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue:  Double(b) / 255, opacity: Double(a) / 255)
    }
}

public extension Color
{
    // MARK: - Constants & Variables
    
    static var lightBlue: Color = .init(red: 65/255, green: 165/255, blue: 255/255)
    static var darkBlue: Color = .init(red: 75/255, green: 175/255, blue: 255/255)
    
    static var lightRed: Color = .init(red: 255/255, green: 80/255, blue: 75/255)
    static var darkRed: Color = .init(red: 255/255, green: 90/255, blue: 85/255)
    
    static var lightGreen: Color = .init(red: 90/255, green: 210/255, blue: 90/255)
    static var darkGreen: Color = .init(red: 100/255, green: 225/255, blue: 95/255)
    
    static var lightViolet: Color = .init(red: 210/255, green: 70/255, blue: 185/255)
    static var darkViolet: Color = .init(red: 220/255, green: 80/255, blue: 205/255)
    
    static var lightWhite: Color = .init(red: 255/255, green: 255/255, blue: 255/255)
    static var darkWhite: Color = .init(red: 255/255, green: 255/255, blue: 255/255)
    
    static var lightWhiteComplement: Color = .init(red: 255/255, green: 255/255, blue: 255/255)
    static var darkWhiteComplement: Color = .init(red: 0/255, green: 0/255, blue: 0/255)
    
    static var lightLightGray: Color = .init(red: 230/255, green: 230/255, blue: 230/255)
    static var darkLightGray: Color = .init(red: 100/255, green: 100/255, blue: 100/255)
    
    static var lightLightGrayComplement: Color = .init(red: 230/255, green: 230/255, blue: 230/255)
    static var darkLightGrayComplement: Color = .init(red: 25/255, green: 25/255, blue: 25/255)
    
    static var lightGray: Color = .init(red: 205/255, green: 205/255, blue: 205/255)
    static var darkGray: Color = .init(red: 50/255, green: 50/255, blue: 50/255)
    
    static var lightDarkGray: Color = .init(red: 155/255, green: 155/255, blue: 155/255)
    static var darkDarkGray: Color = .init(red: 25/255, green: 25/255, blue: 25/255)
    
    static var lightDarkGrayComplement: Color = .init(red: 155/255, green: 155/255, blue: 155/255)
    static var darkDarkGrayComplement: Color = .init(red: 100/255, green: 100/255, blue: 100/255)
    
    static var lightBlack: Color = .init(red: 0/255, green: 0/255, blue: 0/255)
    static var darkBlack: Color = .init(red: 0/255, green: 0/255, blue: 0/255)
    
    static var lightBlackComplement: Color = .init(red: 0/255, green: 0/255, blue: 0/255)
    static var darkBlackComplement: Color = .init(red: 255/255, green: 255/255, blue: 255/255)
    
    var components: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)
    {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard UIColor(self).getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        else
        {
            return (0, 0, 0, 0)
        }
        
        return (hue, saturation, brightness, alpha)
    }
}
