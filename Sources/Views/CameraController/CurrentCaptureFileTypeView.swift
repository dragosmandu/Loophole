//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: CurrentCaptureFileTypeView.swift
//  Creation: 4/23/21 9:33 AM
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

struct CurrentCaptureFileTypeView: View
{
    @Binding private var currentCaptureFileType: CaptureButtonView.CaptureFileType
    
    private var animation: Animation
    {
        return .spring(response: 0.5, dampingFraction: 0.65, blendDuration: 0.1)
    }
    
    init(currentCaptureFileType: Binding<CaptureButtonView.CaptureFileType>)
    {
        _currentCaptureFileType = currentCaptureFileType
    }
    
    var body: some View
    {
        let paddingFactor = 3
        let minOpacity = 0.55
        let maxOpacity = 1.0
        let minScale: CGFloat = 0.85
        let maxScale: CGFloat = 1.0
        let absMinOffsetX: CGFloat = 0
        let absMaxOffsetX: CGFloat = 60
        let absMinOffsetY: CGFloat = 0
        let absMaxOffsetY: CGFloat = 5
        
        ZStack(alignment: .center)
        {
            let fontTextStyle: Font.TextStyle = .title3
            let fontDesign: Font.Design = .rounded
            
            let gifFileTypeOpacity = currentCaptureFileType == .gif ? maxOpacity : minOpacity
            let gifFileTypeScale = currentCaptureFileType == .gif ? maxScale : minScale
            let gifFileTypeOffsetX = currentCaptureFileType == .gif ? absMinOffsetX : -absMaxOffsetX
            let gifFileTypeOffsetY = currentCaptureFileType == .gif ? absMinOffsetY : absMaxOffsetY
            
            Button
            {
                currentCaptureFileType = .gif
            }
            label:
            {
                let weight: Font.Weight = currentCaptureFileType == .gif ? .semibold : .medium
                
                Text(CaptureButtonView.CaptureFileType.gif.name)
                    .font(Font.system(fontTextStyle, design: fontDesign).weight(weight))
                    .padding(.all, factor: paddingFactor)
                    .contentShape(Rectangle())
            }
            .opacity(gifFileTypeOpacity)
            .scaleEffect(gifFileTypeScale)
            .offset(x: gifFileTypeOffsetX, y: gifFileTypeOffsetY)
            
            let mp4FileTypeOpacity = currentCaptureFileType == .mp4 ? maxOpacity : minOpacity
            let mp4FileTypeScale = currentCaptureFileType == .mp4 ? maxScale : minScale
            let mp4FileTypeOffsetX = currentCaptureFileType == .mp4 ? absMinOffsetX : absMaxOffsetX
            let mp4FileTypeOffsetY = currentCaptureFileType == .mp4 ? absMinOffsetY : absMaxOffsetY
            
            Button
            {
                currentCaptureFileType = .mp4
            }
            label:
            {
                let weight: Font.Weight = currentCaptureFileType == .mp4 ? .semibold : .medium
                
                Text(CaptureButtonView.CaptureFileType.mp4.name)
                    .font(Font.system(fontTextStyle, design: fontDesign).weight(weight))
                    .padding(.all, factor: paddingFactor)
                    .contentShape(Rectangle())
            }
            .opacity(mp4FileTypeOpacity)
            .scaleEffect(mp4FileTypeScale)
            .offset(x: mp4FileTypeOffsetX, y: mp4FileTypeOffsetY)
        }
        .foregroundColor(.white)
        .animation(animation)
    }
}
