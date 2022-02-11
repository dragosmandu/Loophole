//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: PhotosLibraryView.swift
//  Creation: 4/9/21 7:50 PM
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
import PhotosUI

public struct PhotosLibraryView: View
{
    public static var numColumns: CGFloat = 3
    public static var interItemSpacing: CGFloat = 2.5
    
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    @State private var fetchResult: PHFetchResult<PHAsset>? = nil
    @State private var noAssets: Int = 0
    
    @Binding private var selectedAssets: [Int : PHAsset]
    
    private let maxNoSelectedAssets: Int
    private let imageManager: PHImageManager = .init()
    
    // Considers all the needed permissions are granted.
    public init(selectedAssets: Binding<[Int : PHAsset]>, maxNoSelectedAssets: Int = 1)
    {
        _selectedAssets = selectedAssets
        self.maxNoSelectedAssets = maxNoSelectedAssets
    }
    
    public var body: some View
    {
        let screenWidth = UIScreen.main.bounds.width
        let itemSize = (screenWidth - 2 * PhotosLibraryView.interItemSpacing) / PhotosLibraryView.numColumns
        let gridItemSize: GridItem.Size = .fixed(itemSize)
        let gridItem: GridItem = .init(gridItemSize, spacing: PhotosLibraryView.interItemSpacing, alignment: .center)
        var columns: [GridItem] = []
        
        for _ in 0..<Int(PhotosLibraryView.numColumns)
        {
            columns.append(gridItem)
        }
        
        return ScrollView(.vertical, showsIndicators: false)
        {
            LazyVGrid(columns: columns, alignment: .center, spacing: PhotosLibraryView.interItemSpacing)
            {
                if let fetchResult = fetchResult, noAssets > 0
                {
                    ForEach (0..<noAssets)
                    { index in
                        PhotosLibraryItemView(selectedAssets: $selectedAssets, fetchResult: fetchResult, index: index, itemSize: itemSize, maxNoSelectedAssets: maxNoSelectedAssets)
                    }
                }
            }
        }
        .onAppear
        {
            fetchAssets()
        }
    }
    
    private func fetchAssets()
    {
        let options = PHFetchOptions()
        let creationDateDescriptorKey = "creationDate"
        
        options.includeAssetSourceTypes = [.typeUserLibrary, .typeCloudShared]
        options.sortDescriptors =
            [
                // Order by date.
                NSSortDescriptor(key: creationDateDescriptorKey, ascending: false)
            ]
        
        fetchResult = PHAsset.fetchAssets(with: .image, options: options)
        
        noAssets = fetchResult?.count ?? 0
    }
}

struct PhotosLibraryView_Previews: PreviewProvider
{
    @State private static var selectedAssets: [Int : PHAsset] = [:]
    
    static var previews: some View
    {
        PhotosLibraryView(selectedAssets: $selectedAssets)
    }
}
