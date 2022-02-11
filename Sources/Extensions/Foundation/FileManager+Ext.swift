//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: FileManager+Ext.swift
//  Creation: 4/9/21 1:11 PM
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
import UniformTypeIdentifiers

public extension FileManager
{
    // MARK: - Constants & Variables
    
    /// The String prefix to be used in the file creation/search methods.
    static var fileNamePrefix: String = Bundle.main.bundleIdentifier! + "-"
}

public extension FileManager
{
    // MARK: - Methods
    
    /// Creates an URL with given file name, in directory. If the file name isn't provided, it will create a file name.
    /// - Parameters:
    ///   - fileName: The name of the file that the URL should point at.
    ///   - contentType: The content type of the file the URL should point at.
    ///   - directory: The directory in which the file should be.
    ///   - domainMask: Domain constants specifying base locations to use when you search for significant directories.
    /// - Returns: An URL that points at the file with given file name. This method doesn't create the actual file.
    static func createFileURL(fileName: String? = nil, contentType: UTType? = nil, directory: FileManager.SearchPathDirectory = .cachesDirectory, domainMask: FileManager.SearchPathDomainMask = .userDomainMask) -> URL?
    {
        // Gettings the desired directory URL.
        guard let directoryURL = FileManager.default.urls(for: directory, in: domainMask).first
        else
        {
            return nil
        }
        
        var fileURL: URL?
        
        if let fileName = fileName
        {
            fileURL = directoryURL.appendingPathComponent(fileName)
        }
        
        // Creating a file name when it's not provided.
        else
        {
            let fileName = fileNamePrefix + UUID().uuidString
            
            fileURL = directoryURL.appendingPathComponent(fileName)
        }
        
        // Appending the content type extension if provided.
        if let contentType = contentType
        {
            fileURL = fileURL!.appendingPathExtension(for: contentType)
        }
        
        return fileURL
    }
    
    /// Creates a file with given file name, in directory. If the file name isn't provided, it will create a file name.
    /// - Parameters:
    ///   - fileName: The name of the file to be created.
    ///   - contentType: The content type of the file.
    ///   - data: The data that the file may contain when it's created.
    ///   - directory: The directory in which the file is located.
    ///   - domainMask: Domain constants specifying base locations to use when you search for significant directories.
    ///   - attributes: A dictionary containing the attributes to associate with the new file. You can use these attributes to set the owner and group numbers, file permissions, and modification date. For a list of keys, see FileAttributeKey. If you specify nil for attributes, the file is created with a set of default attributes.
    /// - Returns: An URL that points to the newly created file.
    static func createFile(fileName: String? = nil, contentType: UTType? = nil, data: Data? = nil, directory: FileManager.SearchPathDirectory = .cachesDirectory, domainMask: FileManager.SearchPathDomainMask = .userDomainMask, attributes: [FileAttributeKey : Any]? = nil) -> URL?
    {
        if let fileURL = createFileURL(fileName: fileName, contentType: contentType, directory: directory, domainMask: domainMask)
        {
            if !FileManager.default.fileExists(atPath: fileURL.path)
            {
                if FileManager.default.createFile(atPath: fileURL.path, contents: data, attributes: attributes)
                {
                    return fileURL
                }
            }
        }
        
        return nil
    }
    
    /// Searches a file with given file name and location options.
    /// - Parameters:
    ///   - fileName: The name of the file to be searched.
    ///   - directory: The location of significant directories.
    ///   - domainMask: Domain constants specifying base locations to use when you search for significant directories.
    /// - Returns: If the file exists, will return an URL the points to that file.
    static func searchFile(fileName: String, directory: FileManager.SearchPathDirectory = .allLibrariesDirectory, domainMask: FileManager.SearchPathDomainMask = .allDomainsMask) -> URL?
    {
        guard let directoryURL = FileManager.default.urls(for: directory, in: domainMask).first
        else
        {
            return nil
        }
        
        let fileURL = directoryURL.appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: fileURL.path)
        {
            return fileURL
        }
        
        return nil
    }
    
    /// Searches Cache directory for the file that was downloaded from the given external URL.
    /// - Parameter externalURL: The external URL the file was downloaded from.
    /// - Returns: The URL to the file in Cache.
    ///
    /// The search is made with the file name composed from the file name prefix and the SHA1 hash of the external URL.
    ///
    static func searchCache(externalURL: URL) -> URL?
    {
        var fileName: String?
        
        if let sha1HashString = externalURL.absoluteString.sha1HashString
        {
            fileName = fileNamePrefix + sha1HashString
            
            return searchFile(fileName: fileName!, directory: .cachesDirectory, domainMask: .userDomainMask)
        }
        
        return nil
    }
    
    /// Copies a file from a given file URL to a new location with given options. If a new file name for the copy isn't provided, the copy will use the same file name as the original, if it doesn't already exists.
    /// - Parameters:
    ///   - fileURL: The URL to the file to be copied.
    ///   - newFileName: A new given file name for the copy.
    ///   - contentType: The content type of the file copy.
    ///   - directory: The location of significant directories.
    ///   - domainMask: Domain constants specifying base locations to use when you search for significant directories.
    /// - Throws: If the copy fails, will throw an error.
    /// - Returns: The URL that points to the copy of the file.
    static func copyFile(fileURL: URL, newFileName: String? = nil, contentType: UTType? = nil, directory: FileManager.SearchPathDirectory = .cachesDirectory, domainMask: FileManager.SearchPathDomainMask = .userDomainMask) throws -> URL?
    {
        var newFileURL: URL?
        
        // The file to copy should exist first.
        if FileManager.default.fileExists(atPath: fileURL.path)
        {
            if let newFileName = newFileName
            {
                if let fileURL = createFileURL(fileName: newFileName, contentType: contentType, directory: directory, domainMask: domainMask)
                {
                    newFileURL = fileURL
                }
                else
                {
                    let oldFileName = fileURL.lastPathComponent
                    
                    if let fileURL = createFileURL(fileName: oldFileName, contentType: contentType, directory: directory, domainMask: domainMask)
                    {
                        newFileURL = fileURL
                    }
                }
            }
            
            // When a new file name isn't provided, the copy will also have the same file name as in the initial url.
            else
            {
                let oldFileName = fileURL.lastPathComponent
                
                if let fileURL = createFileURL(fileName: oldFileName, contentType: contentType, directory: directory, domainMask: domainMask)
                {
                    newFileURL = fileURL
                }
            }
            
            if let newFileURL = newFileURL, !FileManager.default.fileExists(atPath: newFileURL.path)
            {
                try FileManager.default.copyItem(at: fileURL, to: newFileURL)
            }
        }
        
        return newFileURL
    }
    
    /// Moves a file from a given file URL to a new location with given options. If a new file name for the file at new location isn't provided, the new location file will use the same file name as the original, if it doesn't already exists.
    /// - Parameters:
    ///   - fileURL: The URL to the file to be moved.
    ///   - newFileName: A new given file name for the moved file.
    ///   - contentType: The content type of the moved file.
    ///   - directory: The location of significant directories.
    ///   - domainMask: Domain constants specifying base locations to use when you search for significant directories.
    /// - Throws: If the move fails, will throw an error.
    /// - Returns: The URL that points to the file at the new location.
    static func moveFile(fileURL: URL, newFileName: String? = nil, contentType: UTType? = nil, directory: FileManager.SearchPathDirectory = .cachesDirectory, domainMask: FileManager.SearchPathDomainMask = .userDomainMask) throws -> URL?
    {
        var newFileURL: URL?
        
        if FileManager.default.fileExists(atPath: fileURL.path)
        {
            if let newFileName = newFileName
            {
                if let fileURL = createFileURL(fileName: newFileName, contentType: contentType, directory: directory, domainMask: domainMask)
                {
                    newFileURL = fileURL
                }
                else
                {
                    let oldFileName = fileURL.lastPathComponent
                    
                    if let fileURL = createFileURL(fileName: oldFileName, contentType: contentType, directory: directory, domainMask: domainMask)
                    {
                        newFileURL = fileURL
                    }
                }
            }
            
            // When a new file name isn't provided, the file to move will also have the same file name as in the initial url.
            else
            {
                let oldFileName = fileURL.lastPathComponent
                
                if let fileURL = createFileURL(fileName: oldFileName, contentType: contentType, directory: directory, domainMask: domainMask)
                {
                    newFileURL = fileURL
                }
            }
            
            if let newFileURL = newFileURL, !FileManager.default.fileExists(atPath: newFileURL.path)
            {
                try FileManager.default.moveItem(at: fileURL, to: newFileURL)
            }
        }
        
        return newFileURL
    }
    
    /// Moves or copies the file from given URL to Cache directory for an external URL. Searching a cached file for the same external URL will return it.
    /// - Parameters:
    ///   - fileURL: The file URL that should be moved or copied in Cache directory.
    ///   - url: The external URL where the file was downloaded from.
    ///   - contentType: The content type of the file
    ///   - shouldMove: If true, will move the file from file URL, otherwise will copy it.
    /// - Throws: Throws error if the copy or move fails.
    /// - Returns: Returns the file URL of the cached file, from Cache directory.
    static func cacheFile(fileURL: URL, externalURL: URL, contentType: UTType? = nil, shouldMove: Bool = true) throws -> URL?
    {
        var cachedFileURL: URL?
        
        if let sha1HashString = externalURL.absoluteString.sha1HashString
        {
            let cachedFileName = fileNamePrefix + sha1HashString
            
            if shouldMove
            {
                // The file will from given file URL will be moved to the Cache directory.
                cachedFileURL = try moveFile(fileURL: fileURL, newFileName: cachedFileName, contentType: contentType, directory: .cachesDirectory, domainMask: .userDomainMask)
            }
            else
            {
                cachedFileURL = try copyFile(fileURL: fileURL, newFileName: cachedFileName, contentType: contentType, directory: .cachesDirectory, domainMask: .userDomainMask)
            }
        }
        
        return cachedFileURL
    }
    
    /// Deletes a file at given URL, if exists and is deletable.
    /// - Parameter fileURL: The URL of the file to be deleted.
    /// - Throws: Throws an error if the file couldn't be removed.
    static func deleteFile(fileURL: URL) throws
    {
        if FileManager.default.fileExists(atPath: fileURL.path) && FileManager.default.isDeletableFile(atPath: fileURL.path)
        {
            try FileManager.default.removeItem(atPath: fileURL.path)
        }
    }
}

