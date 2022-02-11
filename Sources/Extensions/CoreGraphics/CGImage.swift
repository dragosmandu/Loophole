//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: CGImage.swift
//  Creation: 4/9/21 1:31 PM
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
import CoreGraphics
import MobileCoreServices


extension CGImage
{
    var jpegData: Data?
    {
        guard let mutableData = CFDataCreateMutable(nil, 0), let destination = CGImageDestinationCreateWithData(mutableData, kUTTypeJPEG, 1, nil)
        else
        {
            return nil
        }
        
        CGImageDestinationAddImage(destination, self, nil)
        
        guard CGImageDestinationFinalize(destination)
        else
        {
            return nil
        }
        
        return mutableData as Data
    }
}
