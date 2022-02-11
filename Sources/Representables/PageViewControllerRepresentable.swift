//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: PageViewControllerRepresentable.swift
//  Creation: 4/10/21 8:17 AM
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

struct PageViewControllerRepresentable: UIViewControllerRepresentable
{
    // MARK: - Representable
    
    @Binding private var currentPage: Int
    
    private let controllers: [UIViewController]
    private let orientation: UIPageViewController.NavigationOrientation
    private let isHapticEnabled: Bool
    private let isAnimationEnabled: Bool
    
    init(currentPage: Binding<Int>, controllers: [UIViewController], isHapticEnabled: Bool, isAnimationEnabled: Bool, orientation: UIPageViewController.NavigationOrientation)
    {
        _currentPage = currentPage
        self.controllers = controllers
        self.orientation = orientation
        self.isHapticEnabled = isHapticEnabled
        self.isAnimationEnabled = isAnimationEnabled
    }
    
    func makeCoordinator() -> Coordinator
    {
        for controller in controllers
        {
            controller.view.backgroundColor = .clear
        }
        
        return Coordinator(currentPage: $currentPage, controllers: controllers, orientation: orientation, isHapticEnabled: isHapticEnabled, isAnimationEnabled: isAnimationEnabled)
    }
    
    func makeUIViewController(context: Context) -> UIPageViewController
    {
        return context.coordinator.pageViewController
    }
    
    func updateUIViewController(_ controller: UIPageViewController, context: Context)
    {
        context.coordinator.updateCurrentPage(newCurrentPage: currentPage)
    }
}

extension PageViewControllerRepresentable
{
    // MARK: - Coordinator
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate
    {
        private let scaleAnimationDuration: Double = 0.2
        
        /// Tranform used when a page is changed with another one.
        private var willTransitionScaleTransform: CGAffineTransform
        {
            let minScaleTransform: CGFloat = 0.85
            return CGAffineTransform.identity.scaledBy(x: minScaleTransform, y: minScaleTransform)
        }
        
        var __currentPage: Int = 0
        let pageViewController: UIPageViewController!
        let pageOptions: [UIPageViewController.OptionsKey : Any] =
            [
                UIPageViewController.OptionsKey.interPageSpacing : 0
            ]
        
        @Binding var currentPage: Int
        
        private var controllers = [UIViewController]()
        private let isHapticEnabled: Bool
        private let isAnimationEnabled: Bool
        
        init(currentPage: Binding<Int>, controllers: [UIViewController], orientation: UIPageViewController.NavigationOrientation, isHapticEnabled: Bool, isAnimationEnabled: Bool)
        {
            _currentPage = currentPage
            self.controllers = controllers
            self.isHapticEnabled = isHapticEnabled
            self.isAnimationEnabled = isAnimationEnabled
            
            pageViewController = .init(transitionStyle: .scroll, navigationOrientation: orientation, options: pageOptions)
            
            super.init()
            
            __currentPage = self.currentPage
            configurePageViewController()
        }
        
        private func configurePageViewController()
        {
            pageViewController.delegate = self
            pageViewController.dataSource = self
            pageViewController.view.backgroundColor = .clear
            
            pageViewController.setViewControllers([controllers[currentPage]], direction: .forward, animated: true, completion: nil)
            
            for subview in pageViewController.view.subviews
            {
                if let scrollView = subview as? UIScrollView
                {
                    scrollView.delegate = self
                    break
                }
            }
        }
        
        private func scaleViewWith(transform: CGAffineTransform, for controller: UIViewController)
        {
            var hapticPattern: CHHapticPattern? = nil
            
            if isHapticEnabled
            {
                if transform == .identity
                {
                    hapticPattern = .riseHapticPattern
                }
            }
            
            if isAnimationEnabled
            {
                controller.view.layer.removeAllAnimations()
                UIView.animate(withDuration: scaleAnimationDuration)
                {
                    controller.view.transform = transform;
                }
                completion:
                { finished in
                    if !finished
                    {
                        // Set the requested tranform when the animation failed to finish.
                        controller.view.transform = transform
                    }
                    
                    if self.isHapticEnabled
                    {
                        CHHapticEngine.sharedEngine?.play(hapticPattern)
                    }
                }
            }
        }
        
        func updateCurrentPage(newCurrentPage: Int)
        {
            if newCurrentPage != __currentPage
            {
                var direction: UIPageViewController.NavigationDirection = .reverse
                
                if newCurrentPage > __currentPage
                {
                    direction = .forward
                }
                
                __currentPage = newCurrentPage
                
                if isAnimationEnabled
                {
                    let currentController = controllers[__currentPage]
                    
                    scaleViewWith(transform: willTransitionScaleTransform, for: currentController)
                }
                
                pageViewController?.setViewControllers([controllers[newCurrentPage]], direction: direction, animated: true)
                { _ in
                    if self.isAnimationEnabled
                    {
                        let currentController = self.controllers[self.__currentPage]
                        
                        if currentController.view.transform != .identity
                        {
                            self.scaleViewWith(transform: .identity, for: currentController)
                        }
                    }
                }
            }
        }
    }
}

extension PageViewControllerRepresentable.Coordinator: UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate
{
    // MARK: - Delegates
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        let currentController = controllers[currentPage]
        
        scaleViewWith(transform: willTransitionScaleTransform, for: currentController)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        let currentController = controllers[currentPage]
        
        scaleViewWith(transform: .identity, for: currentController)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
    {
        let currentController = controllers[currentPage]
        
        if currentController.view.transform != .identity
        {
            scaleViewWith(transform: .identity, for: currentController)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        guard let index = controllers.firstIndex(of: viewController)
        else
        {
            return nil
        }
        
        let beforeController = index == 0 ? nil : controllers[index - 1]
        
        if isAnimationEnabled
        {
            beforeController?.view.transform = willTransitionScaleTransform
        }
        
        return beforeController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard let index = controllers.firstIndex(of: viewController)
        else
        {
            return nil
        }
        
        let afterController = index + 1 == controllers.count ? nil : controllers[index + 1]
        
        if isAnimationEnabled
        {
            afterController?.view.transform = willTransitionScaleTransform
        }
        
        return afterController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        if completed, let visibleViewController = pageViewController.viewControllers?.first, let index = controllers.firstIndex(of: visibleViewController)
        {
            currentPage = index
            __currentPage = index
        }
    }
}
