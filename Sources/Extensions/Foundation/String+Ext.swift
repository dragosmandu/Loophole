//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: String+Ext.swift
//  Creation: 4/9/21 1:17 PM
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

public extension String
{
    // MARK: - Constants & Variables
    
    /// An empty String.
    static let empty: String = ""
    
    /// The SHA1 hash string representation of the current String.
    /// Don't use it for cryptographic meanings.
    var sha1HashString: String?
    {
        var sha1HashString: String?
        
        if let data = self.data(using: .utf8)
        {
            sha1HashString = data.sha1HashString
        }
        
        return sha1HashString
    }
}

public extension String
{
    // MARK: - Methods
    
    /// Draws the text for current bitmap-based graphics context.
    /// - Parameters:
    ///   - location: The CGPoint of the text's location.
    ///   - rotationAngleRad: Text's rotation angle in radians.
    /// - Returns: True if succeeded, false otherwise.
    func drawTextWith(font: UIFont = .preferredFont(forTextStyle: .body), color: UIColor = .black, location: CGPoint = .zero, rotationAngleRad: CGFloat = .zero) -> Bool
    {
        let textAttributes =
            [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: color
            ] as [NSAttributedString.Key : Any]
        
        let textSize: CGSize = self.size(withAttributes: textAttributes)
        
        guard let context: CGContext = UIGraphicsGetCurrentContext()
        else
        {
            return false
        }
        
        let locationTransform: CGAffineTransform = .init(translationX: location.x, y: location.y)
        let rotationTransform: CGAffineTransform = .init(rotationAngle: rotationAngleRad)
        
        context.concatenate(locationTransform)
        context.concatenate(rotationTransform)
        
        self.draw(at: CGPoint(x: -1 * textSize.width / 2, y: -1 * textSize.height / 2), withAttributes: textAttributes)
        
        return true
    }
}
