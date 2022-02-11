//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.3
//			
//  File Name: Sticker.swift
//  Creation: 5/11/21 2:09 PM
//
//  Company: Thecircle LLC 
//  Contact: dev@thecircle.xyz
//  Website: https://thecircle.xyz
//  Author: Dragos-Costin Mandu
//
//  Copyright © 2021 Thecircle LLC. All rights reserved.
//
//


import Foundation

public struct Sticker: Hashable
{
    let id: UUID
    let symbolName: String
    
    public init(symbolName: String)
    {
        self.symbolName = symbolName
        
        id = UUID()
    }
    
    public func hash(into hasher: inout Hasher)
    {
        hasher.combine(id)
        hasher.combine(symbolName)
    }
    
    public static func == (lhs: Sticker, rhs: Sticker) -> Bool
    {
        return lhs.id == rhs.id && lhs.symbolName == rhs.symbolName
    }
}

public extension Sticker
{
    enum Set: CaseIterable
    {
        case set1
        case set2
        case set3
        case set4
        case set5
        case set6
        case set7
        case set8
        case set9
        case set10
        
        public var stickers: [Sticker]
        {
            switch self
            {
                case .set1:
                    return createStickerSetIn(stickerSet: 1, range: 1...25)
                    
                case .set2:
                    return createStickerSetIn(stickerSet: 2, range: 1...20)
                    
                case .set3:
                    return createStickerSetIn(stickerSet: 3, range: 1...20)
                    
                case .set4:
                    return createStickerSetIn(stickerSet: 4, range: 1...21)
                    
                case .set5:
                    return createStickerSetIn(stickerSet: 5, range: 1...20)
                    
                case .set6:
                    return createStickerSetIn(stickerSet: 6, range: 1...15)
                    
                case .set7:
                    return createStickerSetIn(stickerSet: 7, range: 1...20)
                    
                case .set8:
                    return createStickerSetIn(stickerSet: 8, range: 1...20)
                    
                case .set9:
                    return createStickerSetIn(stickerSet: 9, range: 1...23)
                    
                case .set10:
                    return createStickerSetIn(stickerSet: 10, range: 1...20)
            }
        }
    }
}

private extension Sticker.Set
{
    func createStickerSetIn(stickerSet: Int, range: ClosedRange<Int>) -> [Sticker]
    {
        var stickers: [Sticker] = []
        
        for index in range
        {
            stickers.append(Sticker(symbolName: "StickerSet\(stickerSet)-Sticker\(index)"))
        }
        
        return stickers
    }
}
