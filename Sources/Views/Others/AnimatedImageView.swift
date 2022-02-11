//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: AnimatedImageView.swift
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

public struct AnimatedImageView: View
{
    @ObservedObject private var downloadTaskManager: DownloadTaskManager = .init()
    
    @State private var contentMode: ContentMode = .fill
    
    @Binding private var url: URL?
    
    private let isContentModeChangeable: Bool
    
    /// - Parameters:
    ///   - url: A binding to a file/external URL where the animated image is located.
    ///   - contentMode: The default content mode. If isContentModeChangeable is true, it may change with a magnification gesture.
    public init(url: Binding<URL?>, isContentModeChangeable: Bool = true, contentMode: ContentMode = .fill)
    {
        _url = url
        self.isContentModeChangeable = isContentModeChangeable
        self.contentMode = contentMode
    }
    
    public var body: some View
    {
        Group
        {
            if let fileURL = url, let data = try? Data(contentsOf: fileURL)
            {
                AnimatedImageControllerRepresentable(data: data, contentMode: $contentMode)
                    .toggle(contentMode: $contentMode, isActive: isContentModeChangeable)
                    .transition()
            }
            else
            {
                PlaceholderView()
                    .transition()
            }
        }
    }
}

struct AnimatedImageView_Previews: PreviewProvider
{
    @State static var url: URL? = URL(string: "INSERT_URL")
    
    static var previews: some View
    {
        AnimatedImageView(url: $url, isContentModeChangeable: true, contentMode: .fill)
    }
}
