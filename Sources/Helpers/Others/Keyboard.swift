//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: Keyboard.swift
//  Creation: 4/12/21 8:31 PM
//
//  Company: Thecircle LLC 
//  Contact: dev@thecircle.xyz
//  Website: https://thecircle.xyz
//  Author: Dragos-Costin Mandu
//
//  Copyright © 2021 Thecircle LLC. All rights reserved.
//
//


import UIKit

public class Keyboard: ObservableObject
{
    @Published public var rect: CGRect = .zero
    
    private let notificationCenter: NotificationCenter = .default
    private var tokens: [NSObjectProtocol] = []
    
    /// Sets observers on keyboard presentation and dismissal, updating keyboard rect.
    public init()
    {
        notificationCenter.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main)
        { (notification) in
            guard let userInfo = notification.userInfo, let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            else
            {
                return
            }
            
            self.rect = keyboardRect
        }
        
        notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main)
        { (notification) in
            self.rect = .zero
        }
    }
    
    deinit
    {
        for token in tokens
        {
            notificationCenter.removeObserver(token)
        }
    }
}

