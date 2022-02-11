//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.3
//			
//  File Name: CIImage+Ext.swift
//  Creation: 5/4/21 11:53 AM
//
//  Company: Thecircle LLC 
//  Contact: dev@thecircle.xyz
//  Website: https://thecircle.xyz
//  Author: Dragos-Costin Mandu
//
//  Copyright © 2021 Thecircle LLC. All rights reserved.
//
//


import CoreImage

public extension CIImage
{
    /// Adds a filter of given type to the current image.
    /// - Returns: The image with added filter or nil.
    func addFilter(filterType: CIFilter.FilterType) -> CGImage?
    {
        guard let filter = CIFilter(name: filterType.name)
        else
        {
            return nil
        }
        
        filter.setValue(self, forKey: kCIInputImageKey)
        
        guard let ciOutput = filter.outputImage
        else
        {
            return nil
        }
        
        let ciContext = CIContext()
        
        return ciContext.createCGImage(ciOutput, from: ciOutput.extent)
    }
}
