//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: AVCaptureDevice+Ext.swift
//  Creation: 4/9/21 7:24 PM
//
//  Company: Thecircle LLC 
//  Contact: dev@thecircle.xyz
//  Website: https://thecircle.xyz
//  Author: Dragos-Costin Mandu
//
//  Copyright © 2021 Thecircle LLC. All rights reserved.
//
//


import AVFoundation

public extension AVCaptureDevice.TorchMode
{
    var systemSymbolName: String
    {
        switch self
        {
            case .auto:
                return "bolt.badge.a.fill"
                
            case .on:
                return "bolt.fill"
                
            default:
                return "bolt.slash.fill"
        }
    }
    
    mutating func toggle()
    {
        if self == .auto
        {
            self = .on
        }
        else if self == .on
        {
            self = .off
        }
        else
        {
            self = .auto
        }
    }
}

public extension AVCaptureDevice.FlashMode
{
    var systemSymbolName: String
    {
        switch self
        {
            case .auto:
                return "bolt.badge.a.fill"
                
            case .on:
                return "bolt.fill"
                
            default:
                return "bolt.slash.fill"
        }
    }
    
    mutating func toggle()
    {
        if self == .auto
        {
            self = .on
        }
        else if self == .on
        {
            self = .off
        }
        else
        {
            self = .auto
        }
    }
}

