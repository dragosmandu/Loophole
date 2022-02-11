//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: DownloadTaskManager.swift
//  Creation: 4/9/21 2:18 PM
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

public class DownloadTaskManager: NSObject, ObservableObject
{
    enum DownloadState
    {
        case none
        case downloading
        case finished
        case failed
    }
    
    /// The location URL of the cached file downloaded under the latest download call, if any.
    @Published private(set) var fileURL: URL? = nil
    
    /// The latest external URL.
    @Published private(set) var externalURL: URL? = nil
    
    /// The latest download state.
    @Published private(set) var downloadState: DownloadState = .none
    
    /// The latest progress percentage (0 for no download progress, 100 for finished).
    @Published private(set) var downloadProgress: Double = 0
    
    private var session: URLSession!
    private var task: URLSessionDownloadTask?
    private var resumeData: Data?
    
    public override init()
    {
        super.init()
        
        session = .init(configuration: .default, delegate: self, delegateQueue: nil)
    }
    
    deinit
    {
        reset()
        
        if let session = session
        {
            session.invalidateAndCancel()
        }
    }
    
    /// Checks the Cache directory for the file under the given external URL, if it doesn't exist, will start downloading it.
    /// - Parameter externalURL: The URL to download the file from.
    public func download(externalURL: URL)
    {
        reset()
        
        downloadState = .downloading
        self.externalURL = externalURL
        
        if let cachedFileURL = FileManager.searchCache(externalURL: externalURL)
        {
            downloadState = .finished
            downloadProgress = 100
            fileURL = cachedFileURL
        }
        else
        {
            if let resumeData = resumeData
            {
                // Resumes the download task with the downloaded resume Data.
                task = session.downloadTask(withResumeData: resumeData)
            }
            else
            {
                // Create a new download task.
                task = session.downloadTask(with: externalURL)
            }
            
            task?.resume()
        }
    }
    
    private func reset()
    {
        fileURL = nil
        self.externalURL = nil
        downloadState = .none
        downloadProgress = 0
    }
}

extension DownloadTaskManager: URLSessionDownloadDelegate, URLSessionTaskDelegate
{
    // MARK: - Delegates
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)
    {
        if let externalURL = externalURL
        {
            do
            {
                // Cache the file for the external URL were it was downloaded from.
                if let cachedFileURL = try FileManager.cacheFile(fileURL: location, externalURL: externalURL)
                {
                    resumeData = nil
                    
                    DispatchQueue.main.async
                    {
                        self.fileURL = cachedFileURL
                        self.downloadState = .finished
                    }
                    
                    return
                }
            }
            catch
            {
                debugPrint(error)
            }
        }
        
        downloadState = .failed
    }
    
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?)
    {
        if let error = error
        {
            debugPrint(error)
        }
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)
    {
        if let error = error
        {
            debugPrint(error)
            
            DispatchQueue.main.async
            {
                self.downloadState = .failed
            }
            
            let userInfo = (error as NSError).userInfo
            if let resumeData = userInfo[NSURLSessionDownloadTaskResumeData] as? Data
            {
                self.resumeData = resumeData
            }
            
            return
        }
        
        DispatchQueue.main.async
        {
            self.downloadState = .finished
        }
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
    {
        DispatchQueue.main.async
        {
            if self.downloadState != .downloading
            {
                self.downloadState = .downloading
            }
            
            self.downloadProgress = Double(totalBytesWritten * 100) / Double(totalBytesExpectedToWrite)
        }
    }
}

