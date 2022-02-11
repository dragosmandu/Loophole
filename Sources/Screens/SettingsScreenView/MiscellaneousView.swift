//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: MiscellaneousView.swift
//  Creation: 4/17/21 4:52 PM
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
import StoreKit

extension SettingsScreenView
{
    struct MiscellaneousView: View
    {
        @Environment(\.colorScheme) private var colorScheme: ColorScheme
        @EnvironmentObject private var modalViewPresenterManager: ModalViewPresenter.Manager
        
        private var qaViews: [QAView]
        {
            return
                [
                    QAView(question: "How can I create a new loop?", answer: "You have two options to create a new loop. One of them is to long-press on the record button and take the photos your want to create the loop with. The second option is to press on the 'Gallery' button and choose the photos to be used for the new loop.", index: 1),
                    QAView(question: "What media formats a loop may have?", answer: "A loop may be created using either GIF or video format. A GIF loop is infinite and usually larger than a video. Video loops are finite, but depending on the player, they may be replayed infinitely, which makes them look like a GIF.", index: 2),
                    QAView(question: "How can I change the format?", answer: "Swipe right or left on the record button, or tap on the buttons located above the record button. ", index: 3),
                    QAView(question: "What does the infinity symbol do?", answer: "The infinity symbol, located on the upper right corner of the screen, toggles on/off the looping feature. When it's on, a full loop consists of a forward and backward play (reverse).", index: 4),
                    QAView(question: "How can I add stickers, texts or photos?", answer: "You may add one or more stickers and/or texts and/or photos to your loops. To add a new sticker, text or photo, press the sticker, textbox or photo button located in the upper right corner of the screen. You can update their position, rotate and resize them before and after taking a new loop.", index: 5),
                    QAView(question: "How many photos a loop can use?", answer: "The maximum number of photos used in a single loop is currently 20. If the reverse loop (infinity symbol) is on, the loop can have up to 40 photos.", index: 6),
                    QAView(question: "How can I add a filter to a new loop?", answer: "Filters can be added only after the loop has been created, a filter button will appear on the upper right corner of the screen. You can add up to one filter per loop.", index: 7),
                    QAView(question: "What 'HD Quality' field does if it's on?", answer: "If the 'HD Quality' field, located in 'Settings', it's on, all future loops will have a high-definition resolution. This affects the file size of the loop. Default it's on.", index: 8),
                    QAView(question: "What does the 'Capture Delay' field mean?", answer: "This changes the delay between two consecutive photo takes of your phone's camera. A higher value will make the loop look more 'disconnected'.", index: 9),
                    QAView(question: "What does the 'Inter Frame Delay' field mean?", answer: "This changes the delay between two consecutive photos displayed in a created loop. A higher value will make the loop look 'slower'.", index: 10),
                    QAView(question: "What does the 'Video Loops' field mean?", answer: "The total number of loops to play in a video format. It's affecting only the video format.", index: 11),
                ]
        }
        
        init()
        {
            
        }
        
        var body: some View
        {
            VStack(alignment: .leading, spacing: 0)
            {
                VStack(alignment: .center, spacing: 0)
                {
                    titleView
                        .margin(.bottom)
                    
                    NavigationLink(destination: faqView)
                    {
                        faqLabelView
                    }
                    
                    NavigationLink(destination: contentPolicyView)
                    {
                        contentPolicyLabelView
                    }
                    
                    NavigationLink(destination: privacyPolicyView)
                    {
                        privacyPolicyLabelView
                    }
                }
                .margin(.all)
                .background(colorScheme.lightGrayComplement)
                .cornerRadius(Constant.cornerRadius)
            }
        }
        
        private var faqLabelView: some View
        {
            HStack(alignment: .center, spacing: 0)
            {
                Text("FAQ")
                
                Spacer()
                
                Image(systemName: "questionmark.circle.fill")
            }
            .font(itemFont)
            .foregroundColor(colorScheme.darkGrayComplement)
            .lineLimit(1)
            .margin(.vertical)
        }
        
        private var contentPolicyLabelView: some View
        {
            HStack(alignment: .center, spacing: 0)
            {
                Text("Content Policy")
                
                Spacer()
                
                Image(systemName: "doc.text.fill")
            }
            .font(itemFont)
            .foregroundColor(colorScheme.darkGrayComplement)
            .lineLimit(1)
            .margin(.vertical)
        }
        
        private var privacyPolicyLabelView: some View
        {
            HStack(alignment: .center, spacing: 0)
            {
                Text("Privacy Policy")
                
                Spacer()
                
                Image(systemName: "hand.raised.fill")
            }
            .font(itemFont)
            .foregroundColor(colorScheme.darkGrayComplement)
            .lineLimit(1)
            .margin(.vertical)
        }
        
        private var titleView: some View
        {
            HStack(alignment: .center)
            {
                Text("Miscellaneous")
                    .font(headlineFont)
                    .foregroundColor(colorScheme.gray)
                    .lineLimit(1)
                
                Spacer()
            }
        }
        
        private var faqView: some View
        {
            VStack(alignment: .center)
            {
                HStack(alignment: .center, spacing: 0)
                {
                    Text("FAQ")
                        .padding(.trailing, factor: 2)
                    
                    Image(systemName: "questionmark.circle.fill")
                        .foregroundColor(colorScheme.blue)
                    
                    Spacer()
                }
                .font(titleFont)
                .foregroundColor(colorScheme.blackComplement)
                .lineLimit(1)
                .margin(.vertical)
                .margin(.bottom)
                
                ScrollView(.vertical, showsIndicators: false)
                {
                    LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [])
                    {
                        ForEach(qaViews, id: \.self)
                        { qaView in
                            qaView
                                .margin(.vertical)
                        }
                    }
                    .font(Font.body.weight(.regular))
                }
                .foregroundColor(colorScheme.blackComplement)
                .cornerRadius(Constant.cornerRadius)
                
                // Margin bottom for iPhone SE like.
                .margin(UIApplication.safeAreaInsets.bottom == 0 ? .bottom : [])
            }
            .margin(.horizontal)
            .background(colorScheme.whiteComplement)
        }
        
        private var contentPolicyView: some View
        {
            VStack(alignment: .center)
            {
                HStack(alignment: .center, spacing: 0)
                {
                    Text("Content Policy")
                        .padding(.trailing, factor: 2)
                    
                    Image(systemName: "doc.text.fill")
                        .foregroundColor(colorScheme.violet)
                    
                    Spacer()
                }
                .font(titleFont)
                .foregroundColor(colorScheme.blackComplement)
                .lineLimit(1)
                .margin(.vertical)
                .margin(.bottom)
                
                ScrollView(.vertical, showsIndicators: false)
                {
                    LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [])
                    {
                        Text("Last updated May 7, 2021")
                            .fontWeight(.semibold)
                            .margin(.vertical)
                        
                        Text("Thecircle LLC (“we” or “us” or “our”) is the company that manages Loophole (the “Application”).")
                            .margin(.bottom)
                        
                        Text("CONTENT OWNERSHIP")
                            .fontWeight(.semibold)
                            .margin(.vertical)
                        
                        Text("All the media content, such as IMAGES, ANIMATED IMAGES or VIDEOS, processed, unprocessed or edited within the Application are solely owned by you, the User.")
                            .margin(.bottom)
                        
                        Text("The Application may add a WATERMARK on media content that has been processed and/or edited within the Application.")
                            .margin(.bottom)
                        
                        Text("CHANGES TO THE CONTENT POLICY")
                            .fontWeight(.semibold)
                            .margin(.vertical)
                        
                        Text("We reserve the right to make changes to this Content Policy at any time and for any reason. We will alert you about any changes by updating the “Last updated” date of this Content Policy. Your continued use of the Application after any modification to the Content Policy will constitute your acceptance of such modification.")
                            .margin(.bottom)
                        
                        Text("IF YOU DO NOT AGREE WITH THE TERMS OF THIS CONTENT POLICY, PLEASE DO NOT ACCESS THE APPLICATION.")
                            .fontWeight(.medium)
                            .margin(.bottom)
                        
                        Text("If you have any questions about the Content Policy or the Application, please contact us at support@thecircle.xyz.")
                            .margin(.bottom)
                    }
                    .font(Font.body.weight(.regular))
                }
                .foregroundColor(colorScheme.blackComplement)
                .cornerRadius(Constant.cornerRadius)
                
                // Margin bottom for iPhone SE like.
                .margin(UIApplication.safeAreaInsets.bottom == 0 ? .bottom : [])
            }
            .margin(.horizontal)
            .background(colorScheme.whiteComplement)
        }
        
        private var privacyPolicyView: some View
        {
            VStack(alignment: .center)
            {
                HStack(alignment: .center, spacing: 0)
                {
                    Text("Privacy Policy")
                        .padding(.trailing, factor: 2)
                    
                    Image(systemName: "hand.raised.fill")
                        .foregroundColor(colorScheme.red)
                    
                    Spacer()
                }
                .font(titleFont)
                .foregroundColor(colorScheme.blackComplement)
                .lineLimit(1)
                .margin(.vertical)
                .margin(.bottom)
                
                ScrollView(.vertical, showsIndicators: false)
                {
                    LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [])
                    {
                        Text("Last updated May 7, 2021")
                            .fontWeight(.semibold)
                            .margin(.vertical)
                        
                        Text("Thecircle LLC (“we” or “us” or “our”) is the company that manages Loophole (the “Application”). We respect the privacy of our users (“user” or “you” or “yours”). This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use Loophole. Please read this Privacy Policy carefully.")
                            .margin(.bottom)
                        
                        Text("This Privacy Policy does not apply to the third-party online or mobile store from which you install the Application. We are not responsible for any of the data collected by any such third party.")
                            .margin(.bottom)
                        
                        Text("COLLECTION OF YOUR DATA")
                            .fontWeight(.semibold)
                            .margin(.vertical)
                        
                        Text("We DO NOT COLLECT, SEND, RENT or SELL any personal or sensitive data of any kind.")
                            .margin(.bottom)
                        
                        Text("You may voluntarily request to SHARE materials to a desired destination, such as Message, Email, Social Media Platform, a different application, or any other possible destination. We are not responsible for the actions of third parties with whom you SHARE such materials, and we have no authority to manage or control third-party solicitations.")
                            .margin(.bottom)
                        
                        Text("CHANGES TO THE PRIVACY POLICY")
                            .fontWeight(.semibold)
                            .margin(.vertical)
                        
                        Text("We reserve the right to make changes to this Privacy Policy at any time and for any reason. We will alert you about any changes by updating the “Last updated” date of this Privacy Policy. Your continued use of the Application after any modification to the Privacy Policy will constitute your acceptance of such modification.")
                            .margin(.bottom)
                        
                        Text("IF YOU DO NOT AGREE WITH THE TERMS OF THIS PRIVACY POLICY, PLEASE DO NOT ACCESS THE APPLICATION.")
                            .fontWeight(.medium)
                            .margin(.bottom)
                        
                        Text("If you have any questions about the Privacy Policy or the Application, please contact us at support@thecircle.xyz.")
                            .margin(.bottom)
                    }
                    .font(Font.body.weight(.regular))
                }
                .foregroundColor(colorScheme.blackComplement)
                .cornerRadius(Constant.cornerRadius)
                
                // Margin bottom for iPhone SE like.
                .margin(UIApplication.safeAreaInsets.bottom == 0 ? .bottom : [])
            }
            .margin(.horizontal)
            .background(colorScheme.whiteComplement)
        }
    }
}

private extension SettingsScreenView.MiscellaneousView
{
    struct QAView: View, Hashable
    {
        private let qFont = Font.body.weight(.semibold)
        private let aFont = Font.subheadline.weight(.regular)
        
        private var animation: Animation
        {
            return Animation
                .linear(duration: 0.2)
                .delay(0)
                .speed(1)
        }
        
        @Environment(\.colorScheme) private var colorScheme: ColorScheme
        
        @State private var didShowAnswer: Bool = false
        
        private let question: String
        private let answer: String
        private let index: Int
        
        init(question: String, answer: String, index: Int)
        {
            self.question = question
            self.answer = answer
            self.index = index
        }
        
        var body: some View
        {
            VStack(alignment: .leading, spacing: 0)
            {
                questionButtonView
                    .margin(.bottom)
                
                if didShowAnswer
                {
                    answerView
                }
            }
            .foregroundColor(colorScheme.blackComplement)
            .animation(didShowAnswer ? .viewInsertionAnimation : .viewRemovalAnimation)
        }
        
        private var questionButtonView: some View
        {
            Button
            {
                didShowAnswer.toggle()
            }
            label:
            {
                HStack(alignment: .center, spacing: 0)
                {
                    Text("\(index). " + question)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                    
                    Group
                    {
                        if didShowAnswer
                        {
                            Image(systemName: "chevron.up")
                                .transition()
                        }
                        else
                        {
                            Image(systemName: "chevron.down")
                                .transition()
                        }
                    }
                    .margin(.leading)
                }
            }
            .font(qFont)
        }
        
        private var answerView: some View
        {
            Text(answer)
                .font(aFont)
        }
        
        // MARK: - Hashable
        
        func hash(into hasher: inout Hasher)
        {
            hasher.combine(question)
            hasher.combine(answer)
        }
        
        static func == (lhs: SettingsScreenView.MiscellaneousView.QAView, rhs: SettingsScreenView.MiscellaneousView.QAView) -> Bool
        {
            return lhs.question == rhs.question && lhs.answer == rhs.answer
        }
    }
}
