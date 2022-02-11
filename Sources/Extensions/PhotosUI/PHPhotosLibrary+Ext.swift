//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: PHPhotosLibrary+Ext.swift
//  Creation: 4/9/21 2:33 PM
//
//  Company: Thecircle LLC 
//  Contact: dev@thecircle.xyz
//  Website: https://thecircle.xyz
//  Author: Dragos-Costin Mandu
//
//  Copyright © 2021 Thecircle LLC. All rights reserved.
//
//


import PhotosUI

public extension PHPhotoLibrary
{
    // MARK: - Methods
    
    /// Saves the given Data as a  media file in Photos Library of given media type, if possible.
    /// - Parameters:
    ///   - mediaData: The data of the media object to be saved.
    ///   - mediaResourceType: The resource type of the media object to be saved.
    ///   - completion: Called when the saving process has ended.
    ///   - success: True if the process has ended successfully, false otherwise.
    static func saveMediaWith(mediaData: Data, mediaResourceType: PHAssetResourceType, _ completion: @escaping (_ success: Bool) -> Void = { _ in })
    {
        PHPhotoLibrary.requestAuthorization
        { status in
            if status == .authorized
            {
                PHPhotoLibrary.shared().performChanges
                {
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    
                    creationRequest.addResource(with: mediaResourceType, data: mediaData, options: nil)
                } completionHandler:
                { (success, error) in
                    if let error = error
                    {
                        debugPrint(error)
                    }
                    
                    completion(success)
                }
            }
            else
            {
                completion(false)
            }
        }
    }
    
    /// Moves or copies the media object from given file URL.
    /// - Parameters:
    ///   - mediaFileURL: The URL of the media file to be moved or copied to Photos Library.
    ///   - mediaResourceType: The resource type of the media object.
    ///   - shouldMoveFile: If true, will move the file from current location, otherwise the file will be copied.
    ///   - completion: Called when the saving process has ended.
    ///   - success: True if the process has ended successfully, false otherwise.
    static func saveMediaWith(mediaFileURL: URL, mediaResourceType: PHAssetResourceType, shouldMoveFile: Bool = true, _ completion: @escaping (_ success: Bool) -> Void = { _ in })
    {
        PHPhotoLibrary.requestAuthorization
        { status in
            if status == .authorized
            {
                PHPhotoLibrary.shared().performChanges
                {
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    let creationOptions = PHAssetResourceCreationOptions()
                    
                    creationOptions.shouldMoveFile = shouldMoveFile
                    creationRequest.addResource(with: mediaResourceType, fileURL: mediaFileURL, options: creationOptions)
                } completionHandler:
                { (success, error) in
                    if let error = error
                    {
                        debugPrint(error)
                    }
                    
                    completion(success)
                }
            }
            else
            {
                completion(false)
            }
        }
    }
}



