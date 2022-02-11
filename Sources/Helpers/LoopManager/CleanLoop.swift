//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: CleanLoop.swift
//  Creation: 4/20/21 10:05 AM
//
//  Company: Thecircle LLC 
//  Contact: dev@thecircle.xyz
//  Website: https://thecircle.xyz
//  Author: Dragos-Costin Mandu
//
//  Copyright © 2021 Thecircle LLC. All rights reserved.
//
//


import Foundation

func cleanLoopWith(frameFileURLs: [URL], loopFileURL: URL?)
{
    DispatchQueue.global(qos: .userInitiated).async
    {
        
        // Cleans and resets the frames and created loop.
        if let loopFileURL = loopFileURL
        {
            try? FileManager.deleteFile(fileURL: loopFileURL)
        }
        
        for frameFileURL in frameFileURLs
        {
            try? FileManager.deleteFile(fileURL: frameFileURL)
        }
    }
}
