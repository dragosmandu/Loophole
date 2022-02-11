//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.3
//			
//  File Name: NetworkConnectionManager.swift
//  Creation: 5/3/21 10:32 AM
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
import SystemConfiguration

/// Shows if an internet connection is available.
var isConnectedToNetwork: Bool
{
    
    var zeroAddress = sockaddr_in()
    
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    guard let defaultRouteReachability = withUnsafePointer(
        to: &zeroAddress,
        {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1)
            {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }
    )
    else
    {
        return false
    }
    
    var flags: SCNetworkReachabilityFlags = []
    
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags)
    {
        return false
    }
    
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    
    return (isReachable && !needsConnection)
}

