//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.3
//			
//  File Name: LaunchScreenView.swift
//  Creation: 5/10/21 2:50 PM
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

struct LaunchScreenView: View
{
    private let minTimeToLaunch = 2
    private let maxTimeToLaunch = 5
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @State private var timeToLaunch: Int = 0
    
    @Binding private var didFinishInitializingGADMobileSDK: Bool
    
    init(didFinishInitializingGADMobileSDK: Binding<Bool>)
    {
        _didFinishInitializingGADMobileSDK = didFinishInitializingGADMobileSDK
    }
    
    var body: some View
    {
        GeometryReader
        { proxy in
            ZStack(alignment: .bottom)
            {
                VStack(alignment: .center)
                {
                    Spacer()
                    
                    HStack(alignment: .center)
                    {
                        Spacer()
                        
                        let length = proxy.size.width / 4
                        
                        Rectangle()
                            .fill(Color.clear)
                            .background(logoColorGrandient)
                            .frame(width: length, height: length, alignment: .center)
                            .mask(logoSFSymbol(length: length))
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                
                HStack(alignment: .center, spacing: 0)
                {
                    Text("Created by Thecircle LLC")
                        .font(Font.footnote.weight(.semibold))
                        .foregroundColor(colorScheme.gray)
                        .padding(.trailing, factor: 1)
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: colorScheme.gray))
                        .scaleEffect(0.75)
                }
                .padding(.bottom, UIApplication.safeAreaInsets.bottom)
                
                // Add padding only on iPhone SE like phones.
                .padding(UIApplication.safeAreaInsets.bottom > 0 ? [] : .bottom, factor: 1)
            }
        }
        .onAppear
        {
            onAppearAction()
        }
        .background(colorScheme.whiteComplement)
        .edgesIgnoringSafeArea(.all)
    }
    
    private func finishInitializing()
    {
        DispatchQueue.main.async
        {
            timeToLaunch = 0
            didFinishInitializingGADMobileSDK = true
        }
    }
    
    private func updateSDKInitialization()
    {
        DispatchQueue.global(qos: .default).async
        {
            while !didFinishInitializingGADMobileSDK
            {
                if timeToLaunch >= minTimeToLaunch
                {
                    finishInitializing()
                }
                
                sleep(1)
            }
        }
    }
    
    private func initializeADSDK()
    {
        #if !targetEnvironment(simulator)
        initializeGADMobileSDK
        {
            updateSDKInitialization()
        }
        #else
        updateSDKInitialization()
        #endif
    }
    
    private func setAppInstallTimestamp()
    {
        if UserDefaults.appInstallTimestamp == 0 // Sets the time when the app has been installed.
        {
            let appInstallTimestamp: Double = Date().timeIntervalSince1970
            
            UserDefaults.standard.setValue(appInstallTimestamp, forKey: UserDefaults.Key.appInstallTimestampKey)
        }
    }
    
    private func onAppearAction()
    {
        let timeToLaunchTimer: Timer = .scheduledTimer(withTimeInterval: 1, repeats: true)
        { timer in
            timeToLaunch += 1
            
            let didReachMaxLaunchTime = timeToLaunch >= maxTimeToLaunch
            let didFinishSDKInit = timeToLaunch >= minTimeToLaunch && didFinishInitializingGADMobileSDK
            let didFinishLaunch = didReachMaxLaunchTime || didFinishSDKInit
            
            if didFinishLaunch
            {
                timer.invalidate()
            }
        }
        
        timeToLaunchTimer.fire()
        
        initializeADSDK()
        setAppInstallTimestamp()
    }
    
    private var logoColorGrandient: some View
    {
        return LinearGradient(gradient: Gradient(colors: [colorScheme.red, colorScheme.violet]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    private func logoSFSymbol(length: CGFloat) -> some View
    {
        return Image("LoopholeLogo")
            .font(Font.system(size: length, weight: .regular))
    }
}
