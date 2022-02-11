//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.3
//			
//  File Name: FilterButtonView.swift
//  Creation: 5/4/21 12:16 PM
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

private let _filterOptionWidth: CGFloat = UIScreen.main.bounds.size.width / 9
private let _filterOptionHeight: CGFloat = UIScreen.main.bounds.size.width / 9
private let _cornerRadius: CGFloat = 10

struct FilterButtonView: View
{
    private var animation: Animation
    {
        Animation
            .easeInOut(duration: 0.35)
            .speed(1)
            .delay(0)
    }
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @State private var isEnabled: Bool = false
    
    @Binding private var selectedFilterType: CIFilter.FilterType?
    
    private let firstFrameURL: URL
    
    init(selectedFilterType: Binding<CIFilter.FilterType?>, firstFrameURL: URL)
    {
        self._selectedFilterType = selectedFilterType
        self.firstFrameURL = firstFrameURL
    }
    
    var body: some View
    {
        VStack(alignment: .center, spacing: 0)
        {
            Button
            {
                isEnabled.toggle()
            }
            label:
            {
                filterToggleButtonLabelView
            }
            .margin(isEnabled ? .bottom : [])
            
            if isEnabled, let firstFrameData = try? Data(contentsOf: firstFrameURL), let firstFrameUIImage = UIImage(data: firstFrameData)
            {
                ScrollView(.vertical, showsIndicators: false)
                {
                    LazyVStack(alignment: .center, spacing: 10)
                    {
                        ForEach(CIFilter.FilterType.allCases, id: \.self)
                        { filterType in
                            FilterPreviewButtonView(selectedFilterType: $selectedFilterType, filterType: filterType, firstFrameUIImage: firstFrameUIImage)
                        }
                    }
                }
                
                // Should display almost 4 options.
                .frame(width: _filterOptionWidth, height: _filterOptionHeight * 4)
                .cornerRadius(_cornerRadius)
                .margin(.bottom)
                .transition()
            }
        }
        .onAppear
        {
            if selectedFilterType != nil
            {
                isEnabled = true
            }
        }
        .background(
            Group
            {
                if isEnabled
                {
                    colorScheme.black
                        .transparent()
                        .transition()
                }
            }
        )
        .cornerRadius(_cornerRadius * 1.5)
        .animation(animation)
        .onChange(of: isEnabled)
        { isEnabled in
            
            if !isEnabled
            {
                updateSelectedFilterType(newSelectedFilterType: nil)
            }
            else if selectedFilterType == nil
            {
                
                // Auto-selects the first filter when the filter option has been enabled and no filter is selected.
                updateSelectedFilterType(newSelectedFilterType: CIFilter.FilterType.allCases.first)
            }
        }
    }
    
    private func updateSelectedFilterType(newSelectedFilterType: CIFilter.FilterType?)
    {
        DispatchQueue.main.async
        {
            selectedFilterType = newSelectedFilterType
        }
    }
    
    private var filterToggleButtonLabelView: some View
    {
        let systemSymbolName = "camera.filters"
        let foregroundColor = isEnabled ? colorScheme.blue : colorScheme.white
        let fontWeight: Font.Weight = isEnabled ? .bold : Constant.fontWeight
        let marginEdgeSet: Edge.Set = isEnabled ? [.top, .horizontal] : [.bottom, .horizontal]
        
        return Image(systemName: systemSymbolName)
            .font(Constant.font.weight(fontWeight))
            .foregroundColor(foregroundColor)
            .margin(marginEdgeSet)
    }
}

private extension FilterButtonView
{
    struct FilterPreviewButtonView: View
    {
        
        // Creates a decent sized thumbnail.
        private let thumbnailMaxPixelSize = _filterOptionWidth * 4
        
        @Environment(\.colorScheme) private var colorScheme: ColorScheme
        
        @State private var downsampledFilteredFirstFrameUIImage: UIImage? = nil
        @State private var didFailToCreatePreview: Bool = false
        
        @Binding private var selectedFilterType: CIFilter.FilterType?
        
        private let filterType: CIFilter.FilterType
        private let firstFrameUIImage: UIImage
        
        init(selectedFilterType: Binding<CIFilter.FilterType?>, filterType: CIFilter.FilterType, firstFrameUIImage: UIImage)
        {
            _selectedFilterType = selectedFilterType
            self.filterType = filterType
            self.firstFrameUIImage = firstFrameUIImage
        }
        
        var body: some View
        {
            Group
            {
                if downsampledFilteredFirstFrameUIImage != nil
                {
                    Button
                    {
                        updateSelectedFilterType(newSelectedFilterType: filterType)
                    }
                    label:
                    {
                        Image(uiImage: downsampledFilteredFirstFrameUIImage!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: _filterOptionWidth, height: _filterOptionHeight, alignment: .center)
                            .cornerRadius(_cornerRadius)
                            
                            // Shows if the current filter type is selected or not.
                            .overlay(
                                Group
                                {
                                    if selectedFilterType == filterType
                                    {
                                        RoundedRectangle(cornerRadius: _cornerRadius, style: .continuous)
                                            .strokeBorder(colorScheme.blue, lineWidth: _filterOptionWidth * 0.05)
                                            .transition()
                                    }
                                }
                            )
                    }
                }
                else if !didFailToCreatePreview
                {
                    Rectangle()
                        .fill(colorScheme.black)
                        .frame(width: _filterOptionWidth, height: _filterOptionHeight, alignment: .center)
                        .cornerRadius(_cornerRadius)
                        .onAppear
                        {
                            if let downsampledFilteredFirstFrameCGImage = createFilterPreviewImage(filterType: filterType, firstFrameUIImage: firstFrameUIImage)
                            {
                                downsampledFilteredFirstFrameUIImage = UIImage(cgImage: downsampledFilteredFirstFrameCGImage)
                            }
                            else
                            {
                                didFailToCreatePreview = true
                            }
                        }
                }
            }
        }
        
        private func updateSelectedFilterType(newSelectedFilterType: CIFilter.FilterType?)
        {
            DispatchQueue.main.async
            {
                selectedFilterType = newSelectedFilterType
            }
        }
        
        private func createFilterPreviewImage(filterType: CIFilter.FilterType, firstFrameUIImage: UIImage) -> CGImage?
        {
            if let filteredFirstFrameUIImage = firstFrameUIImage.addFilter(filterType: filterType), let filteredFirstFrameData = filteredFirstFrameUIImage.jpegData(compressionQuality: 1), let downsampledFilteredFirstFrameCGImage = filteredFirstFrameData.downsampleImage(thumbnailMaxPixelSize: thumbnailMaxPixelSize, imageIndex: 0)
            {
                return downsampledFilteredFirstFrameCGImage
            }
            
            return nil
        }
    }
}
