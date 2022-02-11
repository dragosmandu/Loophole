//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: VisualEffectBlurViewRepresentable.swift
//  Creation: 4/9/21 8:11 PM
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

struct VisualEffectBlurViewRepresentable<Content: View>: UIViewRepresentable
{
    private let content: Content
    private let blurStyle: UIBlurEffect.Style
    private let vibrancyStyle: UIVibrancyEffectStyle?
    
    init(content: Content, blurStyle: UIBlurEffect.Style, vibrancyStyle: UIVibrancyEffectStyle)
    {
        self.content = content
        self.blurStyle = blurStyle
        self.vibrancyStyle = vibrancyStyle
    }
    
    func makeUIView(context: Context) -> UIVisualEffectView
    {
        context.coordinator.blurView
    }
    
    func updateUIView(_ view: UIVisualEffectView, context: Context)
    {
        context.coordinator.update(content: content, blurStyle: blurStyle, vibrancyStyle: vibrancyStyle)
    }
    
    func makeCoordinator() -> Coordinator
    {
        Coordinator(content: content)
    }
}

extension VisualEffectBlurViewRepresentable
{
    class Coordinator
    {
        let blurView = UIVisualEffectView()
        let vibrancyView = UIVisualEffectView()
        let hostingController: UIHostingController<Content>
        
        init(content: Content)
        {
            hostingController = UIHostingController(rootView: content)
            hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            hostingController.view.backgroundColor = nil
            
            blurView.contentView.addSubview(vibrancyView)
            blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            vibrancyView.contentView.addSubview(hostingController.view)
            vibrancyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        
        func update(content: Content, blurStyle: UIBlurEffect.Style, vibrancyStyle: UIVibrancyEffectStyle?)
        {
            hostingController.rootView = content
            
            let blurEffect = UIBlurEffect(style: blurStyle)
            blurView.effect = blurEffect
            
            if let vibrancyStyle = vibrancyStyle
            {
                vibrancyView.effect = UIVibrancyEffect(blurEffect: blurEffect, style: vibrancyStyle)
            }
            else
            {
                vibrancyView.effect = nil
            }
            
            hostingController.view.setNeedsDisplay()
        }
    }
}

