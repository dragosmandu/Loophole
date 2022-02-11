//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: PageView.swift
//  Creation: 4/10/21 8:24 AM
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

struct PageView<Page>: View where Page: View
{
    @Binding private var currentPage: Int
    
    private let pages: [Page]
    private let orientation: UIPageViewController.NavigationOrientation
    private let isHapticEnabled: Bool
    private let isAnimationEnabled: Bool
    
    init(currentPage: Binding<Int>, orientation: UIPageViewController.NavigationOrientation, isHapticEnabled: Bool = true, isAnimationEnabled: Bool = true, _ pages: @escaping () -> [Page])
    {
        _currentPage = currentPage
        self.pages = pages()
        self.orientation = orientation
        self.isHapticEnabled = isHapticEnabled
        self.isAnimationEnabled = isAnimationEnabled
    }
    
    var body: some View
    {
        let controllers = pages.map
        {
            UIHostingController(rootView: $0)
        }
        
        PageViewControllerRepresentable(currentPage: $currentPage, controllers: controllers, isHapticEnabled: isHapticEnabled, isAnimationEnabled: isAnimationEnabled, orientation: orientation)
    }
}
