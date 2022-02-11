//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: CaptureButtonView.swift
//  Creation: 4/10/21 10:14 AM
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
import CoreHaptics

struct CaptureButtonView: View
{
    enum CaptureFileType: Int
    {
        case gif = 0
        case mp4 = 1
        
        var name: String
        {
            switch self
            {
                case .gif:
                    return "GIF"
                    
                default:
                    return "Video"
            }
        }
        
        var systemSymbolName: String
        {
            switch self
            {
                case .gif:
                    return "square.stack.3d.forward.dottedline"
                    
                default:
                    return "video.fill"
            }
        }
    }
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @Binding private var isRecording: Bool
    
    private let captureFileType: CaptureFileType
    
    init(isRecording: Binding<Bool>, captureFileType: CaptureFileType)
    {
        _isRecording = isRecording
        self.captureFileType = captureFileType
    }
    
    var body: some View
    {
        let backgroundGradient = captureFileType == .gif ? LinearGradient(gradient: Gradient(colors: [colorScheme.red, colorScheme.violet]), startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(gradient: Gradient(colors: [colorScheme.red]), startPoint: .topLeading, endPoint: .bottomTrailing)
        
        Image(systemName: captureFileType.systemSymbolName)
            .font(Constant.font)
            .foregroundColor(colorScheme.white)
            .frame(width: Constant.circleDiameter, height: Constant.circleDiameter, alignment: .center)
            .background(backgroundGradient)
            .clipShape(Circle())
            
            // In order for a scroll to work.
            .onTapGesture { }
            .gesture(longPressGesture)
    }
    
    private var longPressGesture: _ChangedGesture<SequenceGesture<LongPressGesture, _EndedGesture<DragGesture>>>
    {
        LongPressGesture(minimumDuration: 0.35, maximumDistance: 15)
            .sequenced(
                before: DragGesture(minimumDistance: 0, coordinateSpace: .global)
                    .onEnded
                    { _ in
                        isRecording = false
                        CHHapticEngine.sharedEngine?.play(.fallHapticPattern)
                    }
            )
            .onChanged
            { value in
                if value == .second(true, nil) // First gesture ended.
                {
                    isRecording = true
                    CHHapticEngine.sharedEngine?.play(.riseHapticPattern)
                }
            }
    }
}
