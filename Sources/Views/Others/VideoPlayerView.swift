//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: VideoPlayerView.swift
//  Creation: 4/19/21 1:21 PM
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
import AVKit

struct VideoPlayerView: View
{
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @State private var timeControlStatus: AVPlayer.TimeControlStatus = .paused
    @State private var observations: [NSKeyValueObservation] = []
    @State private var player: AVPlayer = .init()
    @State private var isUpdatingPlayer: Bool = true
    
    @Binding private var url: URL?
    
    init(url: Binding<URL?>)
    {
        _url = url
    }
    
    var body: some View
    {
        Group
        {
            if !isUpdatingPlayer
            {
                VideoPlayer(player: player)
                    .onChange(of: timeControlStatus)
                    { timeControlStatus in
                        guard let durationSec = player.currentItem?.duration.seconds
                        else
                        {
                            return
                        }
                        
                        // Replays the video when on end.
                        if player.currentTime().seconds >= durationSec
                        {
                            player.seek(to: .zero)
                            player.play()
                        }
                    }
                    .transition()
            }
            else
            {
                PlaceholderView()
                    .onAppear
                    {
                        invalidateObserversForPlayer()
                        setObserversForPlayer()
                        
                        if let url = url
                        {
                            updatePlayerItemFor(newURL: url)
                        }
                    }
                    .transition()
            }
        }
        .onChange(of: url)
        { url in
            if let url = url
            {
                updatePlayerItemFor(newURL: url)
            }
        }
    }
    
    private func updatePlayerItemFor(newURL: URL)
    {
        isUpdatingPlayer = true
        
        // Makes a smooth transition between the old loop and the new one.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
        {
            defer
            {
                isUpdatingPlayer = false
            }
            
            let playerItem = AVPlayerItem(url: newURL)
            
            player.replaceCurrentItem(with: playerItem)
        }
    }
    
    private func setObserversForPlayer()
    {
        let timeControlStatusObservation = player.observe(\.timeControlStatus)
        { player, _ in
            timeControlStatus = player.timeControlStatus
        }
        
        observations.append(timeControlStatusObservation)
    }
    
    private func invalidateObserversForPlayer()
    {
        for observation in observations
        {
            observation.invalidate()
        }
    }
}

struct VideoPlayerView_Previews: PreviewProvider
{
    @State static private var url = URL(string: "INSERT_URL")
    
    static var previews: some View
    {
        VideoPlayerView(url: $url)
    }
}
