//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: UINavigationController+Ext.swift
//  Creation: 4/18/21 7:38 AM
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

private var _isNavigationBarHidden: Bool = true

extension UINavigationController
{
    static var isNavigationBarHidden: Bool
    {
        get
        {
            _isNavigationBarHidden
        }
        set
        {
            _isNavigationBarHidden = newValue
        }
    }
    
    override open func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationBar.isHidden = UINavigationController.isNavigationBarHidden
    }
}
