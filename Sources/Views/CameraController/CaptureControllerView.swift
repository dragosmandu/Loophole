//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: CaptureControllerView.swift
//  Creation: 4/10/21 12:31 PM
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

struct CaptureControllerView: View
{
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @State private var currentPage: Int = 0
    @State private var strokeBorderLineWidth: CGFloat = Constant.circleBorderLineWidth
    @State private var isAnimating: Bool = false
    
    @Binding private var currentCaptureFileType: CaptureButtonView.CaptureFileType
    @Binding private var isRecording: Bool
    
    init(currentCaptureFileType: Binding<CaptureButtonView.CaptureFileType>, isRecording: Binding<Bool>)
    {
        _currentCaptureFileType = currentCaptureFileType
        _isRecording = isRecording
        
        // Update current capture button with the initial capture file type.
        _currentPage = .init(initialValue: self.currentCaptureFileType.rawValue)
    }
    
    var body: some View
    {
        let paddingFactor: Int = 1
        
        return PageView(currentPage: $currentPage, orientation: .horizontal)
        {
            [
                CaptureButtonView(isRecording: $isRecording, captureFileType: .gif),
                CaptureButtonView(isRecording: $isRecording, captureFileType: .mp4)
            ]
        }
        
        // Stops from scrolling more than one item.
        .frame(width: UIScreen.main.bounds.size.width)
        .frame(width: Constant.circleDiameter, height: Constant.circleDiameter, alignment: .center)
        .padding(.all, factor: paddingFactor)
        .overlay(borderView)
        .clipShape(Circle())
        .onChange(of: currentPage)
        { currentPage in
            if currentPage == 0
            {
                currentCaptureFileType = .gif
            }
            else
            {
                currentCaptureFileType = .mp4
            }
        }
        .onChange(of: currentCaptureFileType)
        { currentCaptureFileType in
            if currentCaptureFileType.rawValue != currentPage
            {
                currentPage = currentCaptureFileType.rawValue
            }
        }
    }
    
    private var borderView: some View
    {
        let maxTransparency = TransparencyModifier.maxTransparency
        let strokeStyle = StrokeStyle(lineWidth: strokeBorderLineWidth)
        
        return Group
        {
            if isRecording
            {
                Circle()
                    .fill(colorScheme.white.opacity(maxTransparency))
                    .transition()
            }
            else
            {
                Circle()
                    .strokeBorder(colorScheme.white.opacity(maxTransparency), style: strokeStyle)
                    .transition()
            }
        }
    }
}
