//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.3
//			
//  File Name: CIFilter+Ext.swift
//  Creation: 5/4/21 11:34 AM
//
//  Company: Thecircle LLC 
//  Contact: dev@thecircle.xyz
//  Website: https://thecircle.xyz
//  Author: Dragos-Costin Mandu
//
//  Copyright © 2021 Thecircle LLC. All rights reserved.
//
//


import CoreImage

public extension CIFilter
{
    enum FilterType: CaseIterable
    {
        case mono
        case linearToSRGBToneCurve
        case colorFalse
        case vibrance
        case posterize
        case vignette
        case bloom
        case edges
        case crystallize
        case highlightShadowAdjust
        case convolution5X5
        case hexagonalPixellate
        case chrome
        case fade
        case instant
        case noir
        case process
        case tonal
        case transfer
        case sepia
        
        var name: String
        {
            switch self
            {
                case .mono: return "CIPhotoEffectMono"
                case .linearToSRGBToneCurve: return "CILinearToSRGBToneCurve"
                case .colorFalse: return "CIFalseColor"
                case .vibrance: return "CIVibrance"
                case .posterize: return "CIColorPosterize"
                case .vignette: return "CIVignette"
                case .bloom: return "CIBloom"
                case .edges: return "CIEdges"
                case .crystallize: return "CICrystallize"
                case .highlightShadowAdjust: return "CIHighlightShadowAdjust"
                case .convolution5X5: return "CIConvolution5X5"
                case .hexagonalPixellate: return "CIHexagonalPixellate"
                case .chrome: return "CIPhotoEffectChrome"
                case .fade: return "CIPhotoEffectFade"
                case .instant: return "CIPhotoEffectInstant"
                case .noir: return "CIPhotoEffectNoir"
                case .process: return "CIPhotoEffectProcess"
                case .tonal: return "CIPhotoEffectTonal"
                case .transfer: return "CIPhotoEffectTransfer"
                case .sepia: return "CISepiaTone"
            }
        }
        
        var title: String
        {
            switch self
            {
                case .mono: return "Mono"
                case .linearToSRGBToneCurve: return "SRGB Tone Curve"
                case .colorFalse: return "False"
                case .vibrance: return "Vibrance"
                case .posterize: return "Posterize"
                case .vignette: return "Vignette"
                case .bloom: return "Bloom"
                case .edges: return "Edges"
                case .crystallize: return "Crystallize"
                case .highlightShadowAdjust: return "Highlight Shadow"
                case .convolution5X5: return "Convolution 5X5"
                case .hexagonalPixellate: return "Hexagonal Pixellate"
                case .chrome: return "Chrome"
                case .fade: return "Fade"
                case .instant: return "Instant"
                case .noir: return "Noir"
                case .process: return "Process"
                case .tonal: return "Tonal"
                case .transfer: return "Transfer"
                case .sepia: return "Sepia"
            }
        }
    }
}
