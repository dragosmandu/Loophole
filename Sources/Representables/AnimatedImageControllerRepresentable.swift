//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: AnimatedImageControllerRepresentable.swift
//  Creation: 4/9/21 1:57 PM
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

struct AnimatedImageControllerRepresentable: UIViewControllerRepresentable
{
    @Binding private var contentMode: ContentMode
    
    private let data: Data
    
    init(data: Data, contentMode: Binding<ContentMode>)
    {
        self.data = data
        _contentMode = contentMode
    }
    
    func makeCoordinator() -> Coordinator
    {
        Coordinator()
    }
    
    func makeUIViewController(context: Context) -> UIViewController
    {
        context.coordinator
    }
    
    func updateUIViewController(_ viewController: UIViewController, context: Context)
    {
        let contentMode =
            { () -> UIImageView.ContentMode in
                switch self.contentMode
                {
                    case .fit:
                        return .scaleAspectFit
                        
                    default:
                        return .scaleAspectFill
                }
            }
        
        context.coordinator.updateAnimatedImage(animatedImageData: data)
        context.coordinator.updateContentMode(newContentMode: contentMode())
    }
}

extension AnimatedImageControllerRepresentable
{
    class Coordinator: UIViewController
    {
        let imageView: UIImageView = .init(frame: .zero)
        
        init()
        {
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder)
        {
            super.init(coder: coder)
        }
        
        override func viewDidLoad()
        {
            super.viewDidLoad()
            
            configureImageView()
        }
        
        private func configureImageView()
        {
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.isUserInteractionEnabled = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(imageView)
            
            NSLayoutConstraint.activate(
                [
                    imageView.topAnchor.constraint(equalTo: view.topAnchor),
                    imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                    imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                ]
            )
        }
        
        func updateAnimatedImage(animatedImageData: Data)
        {
            let frameMaxPixelSize = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) * UIScreen.main.scale
            
            if let animatedImage = UIImage.animatedImageWith(data: animatedImageData, frameMaxPixelSize: frameMaxPixelSize)
            {
                imageView.image = animatedImage
            }
        }
        
        func updateContentMode(newContentMode: UIImageView.ContentMode)
        {
            imageView.contentMode = newContentMode
        }
    }
}

