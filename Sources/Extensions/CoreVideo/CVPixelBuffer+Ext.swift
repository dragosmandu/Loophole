//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: CVPixelBuffer+Ext.swift
//  Creation: 4/9/21 1:32 PM
//
//  Company: Thecircle LLC 
//  Contact: dev@thecircle.xyz
//  Website: https://thecircle.xyz
//  Author: Dragos-Costin Mandu
//
//  Copyright © 2021 Thecircle LLC. All rights reserved.
//
//


import CoreVideo

public extension CVPixelBuffer
{
    /// The copy of the current buffer.
    var copy: CVPixelBuffer?
    {
        var copy : CVPixelBuffer?
        
        CVPixelBufferCreate(kCFAllocatorDefault, CVPixelBufferGetWidth(self), CVPixelBufferGetHeight(self),CVPixelBufferGetPixelFormatType(self), nil, &copy)
        
        if let copy = copy
        {
            CVPixelBufferLockBaseAddress(self, CVPixelBufferLockFlags.readOnly)
            CVPixelBufferLockBaseAddress(copy, CVPixelBufferLockFlags(rawValue: 0))
            
            
            let copyBaseAddress = CVPixelBufferGetBaseAddress(copy)
            let currBaseAddress = CVPixelBufferGetBaseAddress(self)
            
            memcpy(copyBaseAddress, currBaseAddress, CVPixelBufferGetDataSize(copy))
            
            CVPixelBufferUnlockBaseAddress(copy, CVPixelBufferLockFlags(rawValue: 0))
            CVPixelBufferUnlockBaseAddress(self, CVPixelBufferLockFlags.readOnly)
        }
        
        return copy
    }
}


