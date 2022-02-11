//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.3
//			
//  File Name: AdjustablePhotoView.swift
//  Creation: 5/17/21 12:01 PM
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

public struct AdjustablePhotoView: View
{
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @ObservedObject public var photoProperties: AdjustablePhotoProperties = .init()
    
    @State private var lengthSize: CGFloat = AdjustablePhotoProperties.defaultLengthSize
    @State private var currentPosition: CGPoint = AdjustablePhotoProperties.defaultPosition
    @State private var currentRotationAngle: Angle = AdjustablePhotoProperties.defaultRotationAngle
    
    @State private var previousRotationAngle: Angle? = nil
    @State private var previousLengthSize: CGFloat? = nil
    @State private var previousPosition: CGPoint? = nil
    
    /// Any rotation, position or font size change will set this value to true.
    @State private var isAdjustingPhoto: Bool = false
    @State private var isHidden: Bool = false
    @State private var selectedUIImage: UIImage? = nil
    
    @Binding private var adjustablePhotoViews: [AdjustablePhotoView]
    
    public init(adjustablePhotoViews: Binding<[AdjustablePhotoView]>, selectedPhoto: PHAsset)
    {
        _adjustablePhotoViews = adjustablePhotoViews
        
        photoProperties.photo = selectedPhoto
    }
    
    public var body: some View
    {
        if !isHidden
        {
            GeometryReader
            { proxy in
                if let selectedUIImage = selectedUIImage
                {
                    ZStack(alignment: .topTrailing)
                    {
                        Image(uiImage: selectedUIImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: lengthSize, height: lengthSize, alignment: .center)
                            .margin(.all, factor: 1)
                        
                        DeleteOverlayElementButtonView(isDisabled: $isAdjustingPhoto)
                        {
                            isHidden = true // Hidding the photo in order to delete it from array.
                            
                            for (index, adjustablePhotoView) in adjustablePhotoViews.enumerated()
                            {
                                if adjustablePhotoView.photoProperties == photoProperties
                                {
                                    adjustablePhotoViews.remove(at: index)
                                }
                            }
                        }
                    }
                    .background(colorScheme.black.opacity(0.001))
                    .rotationEffect(currentRotationAngle, anchor: .center)
                    .position(currentPosition)
                    .onTapGesture { }
                    .simultaneousGesture(dragGesture)
                    .simultaneousGesture(magnificationGesture)
                    .simultaneousGesture(rotationGesture)
                    .onAppear
                    {
                        if currentPosition == .zero
                        {
                            
                            let startPosition = CGPoint(x: proxy.size.width / 2, y: proxy.size.height / 2)
                            
                            currentPosition = startPosition
                            photoProperties.position = startPosition
                        }
                    }
                    .transition()
                }
            }
            .onAppear
            {
                if photoProperties.photo == nil
                {
                    isHidden = true
                }
                else
                {
                    updateSelectedPhoto()
                }
            }
            .transition()
        }
    }
    
    private func updateSelectedPhoto()
    {
        let imageManager = PHImageManager()
        let options = PHImageRequestOptions()
        let targetSize = CGSize(width: lengthSize * 1.5, height: lengthSize * 1.5)
        let contentMode: PHImageContentMode = .aspectFit
        
        options.isNetworkAccessAllowed = true
        options.resizeMode = .exact
        options.normalizedCropRect = CGRect(origin: .zero, size: targetSize)
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        
        imageManager.requestImage(for: photoProperties.photo!, targetSize: targetSize, contentMode: contentMode, options: options)
        { uiImage, _ in
            if let uiImage = uiImage
            {
                selectedUIImage = uiImage
            }
        }
    }
}

extension AdjustablePhotoView: Hashable
{
    // MARK: - Hashable
    
    public func hash(into hasher: inout Hasher)
    {
        hasher.combine(photoProperties.id)
    }
    
    public static func == (lhs: AdjustablePhotoView, rhs: AdjustablePhotoView) -> Bool
    {
        return lhs.photoProperties.id == rhs.photoProperties.id
    }
}

extension AdjustablePhotoView
{
    // MARK: - Gestures
    
    private var dragGesture: _EndedGesture<_ChangedGesture<DragGesture>>
    {
        DragGesture(minimumDistance: 1, coordinateSpace: .global)
            .onChanged
            { value in
                if !isAdjustingPhoto
                {
                    isAdjustingPhoto = true
                }
                
                if previousPosition == nil
                {
                    previousPosition = currentPosition
                }
                
                let newPositionX = previousPosition!.x + value.translation.width
                let newPositionY = previousPosition!.y + value.translation.height
                
                currentPosition = CGPoint(x: newPositionX, y: newPositionY)
            }
            .onEnded
            { _ in
                previousPosition = nil
                photoProperties.position = currentPosition
                isAdjustingPhoto = false
            }
    }
    
    private var rotationGesture: _EndedGesture<_ChangedGesture<RotationGesture>>
    {
        RotationGesture(minimumAngleDelta: .init(degrees: 0))
            .onChanged
            { angle in
                if !isAdjustingPhoto
                {
                    isAdjustingPhoto = true
                }
                
                if previousRotationAngle == nil
                {
                    previousRotationAngle = currentRotationAngle
                }
                
                
                let roundedPreviousRotationDeg = previousRotationAngle!.degrees.roundWith(fractionDigits: 3)
                let roundedDeg = angle.degrees.roundWith(fractionDigits: 3)
                var newRotationAngle: Angle = .init(degrees: roundedPreviousRotationDeg + roundedDeg)
                let remainder = newRotationAngle.degrees.truncatingRemainder(dividingBy: 90)
                
                if remainder <= 5 && remainder >= -5
                {
                    newRotationAngle = .init(degrees: newRotationAngle.degrees - remainder) // Snaps in clockwise.
                }
                else if remainder >= 85 || remainder <= -85
                {
                    let remainder = 90 - abs(remainder)
                    
                    if newRotationAngle.degrees > 0
                    {
                        newRotationAngle = .init(degrees: newRotationAngle.degrees + remainder) // Snaps in counter-clockwise when -.
                    }
                    else
                    {
                        newRotationAngle = .init(degrees: newRotationAngle.degrees - remainder) // Snaps in counter-clockwise when +.
                    }
                }
                
                currentRotationAngle = newRotationAngle
            }
            .onEnded
            { _ in
                previousRotationAngle = nil
                photoProperties.rotationAngle = currentRotationAngle
                isAdjustingPhoto = false
            }
    }
    
    private var magnificationGesture: _EndedGesture<_ChangedGesture<MagnificationGesture>>
    {
        MagnificationGesture(minimumScaleDelta: 0)
            .onChanged
            { (value) in
                if !isAdjustingPhoto
                {
                    isAdjustingPhoto = true
                }
                
                if previousLengthSize == nil
                {
                    previousLengthSize = lengthSize
                }
                
                let newLengthSize = previousLengthSize! * value
                
                if newLengthSize >= AdjustablePhotoProperties.defaultMinLengthSize && newLengthSize <= AdjustablePhotoProperties.defaultMaxLengthSize
                {
                    lengthSize = newLengthSize
                }
            }
            .onEnded
            { _ in
                previousLengthSize = nil
                photoProperties.lengthSize = lengthSize
                isAdjustingPhoto = false
                updateSelectedPhoto()
            }
    }
}

