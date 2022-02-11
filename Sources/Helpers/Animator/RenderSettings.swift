//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: RenderSettings.swift
//  Creation: 4/19/21 3:55 PM
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
import UIKit

struct RenderSettings
{
    let outputURL: URL? = FileManager.createFileURL(contentType: .mpeg4Movie)
    
    private(set) var size : CGSize
    private(set) var fps: Int32
    private(set) var avCodecKey: AVVideoCodecType
    
    init(size: CGSize, fps: Int32 = Int32(1 / UIImage.animatedImageDefaultInterFrameDelay), avCodecKey: AVVideoCodecType = .h264)
    {
        self.size = size
        self.fps = fps
        self.avCodecKey = avCodecKey
    }
}

