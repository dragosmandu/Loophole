//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: ShareLoopButtonView.swift
//  Creation: 4/13/21 7:11 PM
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
import CoreHaptics
import PhotosUI

struct ShareLoopButtonView: View
{
    /// The max value of the drag indicator progress can have.
    private let maxDragIndicatorProgress: CGFloat = 1
    
    /// The min value of the drag indicator progress can have.
    private let minDragIndicatorProgress: CGFloat = 0
    
    /// The mindrag indicator progress value in order to happen a change in UI.
    private let minProgressForChange: CGFloat = 0.5
    
    /// An invalid drag indicator start progress value.
    private let invalidStartDragIndicatorProgress: CGFloat = -1
    
    /// Max translation height offset.
    private let maxDragOffsetY: CGFloat = 300
    
    /// The number of sec to auto dismiss a share notification.
    private let shareNotificationAutoDismissSec: Double = 3
    
    private var dragIndicatorAnimation: Animation
    {
        Animation
            .spring(response: 0.35, dampingFraction: 0.7, blendDuration: 0.2)
            .speed(1)
            .delay(0)
    }
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @EnvironmentObject private var modalViewPresenterManager: ModalViewPresenter.Manager
    
    /// A file URL for the final loop which will contain all the text, if any.
    @State private var finalLoopFileURL: URL? = nil
    @State private var isActivityControllerPresented: Bool = false
    @State private var dragIndicatorProgress: CGFloat = 1
    
    /// The start progress of the drag indicator, -1 being invalid start.
    @State private var startDragIndicatorProgress: CGFloat = -1
    
    @State private var previousIsReversed: Bool = false
    @State private var previousInterFrameDelay: Double = -1
    @State private var previousVideoFormatLoopCounter: Int = -1
    @State private var previousSelectedFilterType: CIFilter.FilterType? = nil
    
    /// Text field properties that are already used in the last loop, text combine.
    @State private var previousCombinedAdjustableTextFieldProperties: [AdjustableTextFieldTextProperties] = []
    
    /// Sticker properties that are already used in the last loop, sticker combine.
    @State private var previousCombinedAdjustableStickerProperties: [AdjustableStickerProperties] = []
    
    /// Photo properties that are already used in the last loop, photo combine.
    @State private var previousCombinedAdjustablePhotoProperties: [AdjustablePhotoProperties] = []
    
    /// Shows if currently a loop is combining with the text and/or sticker.
    @Binding private var isCombiningLoop: Bool
    @Binding private var frameFileURLs: [URL]
    @Binding private var adjustableTextFieldViews: [AdjustableTextFieldView]
    @Binding private var adjustableStickerViews: [AdjustableStickerView]
    @Binding private var adjustablePhotoViews: [AdjustablePhotoView]
    @Binding private var isReversed: Bool
    @Binding private var interFrameDelay: Double
    @Binding private var videoFormatLoopCounter: Int
    @Binding private var currentCaptureFileType: CaptureButtonView.CaptureFileType
    @Binding private var isProcessingAd: Bool
    @Binding private var selectedFilterType: CIFilter.FilterType?
    
    init(isCombiningLoop: Binding<Bool>, frameFileURLs: Binding<[URL]>, adjustableTextFieldViews: Binding<[AdjustableTextFieldView]>, adjustableStickerViews: Binding<[AdjustableStickerView]>, adjustablePhotoViews: Binding<[AdjustablePhotoView]>, isReversed: Binding<Bool>, interFrameDelay: Binding<Double>, videoFormatLoopCounter: Binding<Int>, currentCaptureFileType: Binding<CaptureButtonView.CaptureFileType>, isProcessingAd: Binding<Bool>, selectedFilterType: Binding<CIFilter.FilterType?>)
    {
        _isCombiningLoop = isCombiningLoop
        _frameFileURLs = frameFileURLs
        _adjustableTextFieldViews = adjustableTextFieldViews
        _adjustableStickerViews = adjustableStickerViews
        _adjustablePhotoViews = adjustablePhotoViews
        _isReversed = isReversed
        _interFrameDelay = interFrameDelay
        _videoFormatLoopCounter = videoFormatLoopCounter
        _currentCaptureFileType = currentCaptureFileType
        _isProcessingAd = isProcessingAd
        _selectedFilterType = selectedFilterType
    }
    
    var body: some View
    {
        VStack(alignment: .center, spacing: 0)
        {
            DragIndicatorView(progress: .constant(dragIndicatorProgress >= 0 ? dragIndicatorProgress : 0), fillColor: colorScheme.white)
                .margin(.bottom, factor: dragIndicatorProgress > minProgressForChange ? 1 : 2)
            
            if dragIndicatorProgress > minProgressForChange
            {
                Text("Share")
                    .font(Font.body.weight(.semibold))
                    .foregroundColor(colorScheme.white)
                    .animation(nil)
                    .transition()
            }
            
            if dragIndicatorProgress == 0
            {
                creatingLoopProgressView
                    .animation(nil)
                    .transition()
            }
        }
        .margin(dragIndicatorProgress < minProgressForChange ? .all : [.top, .horizontal])
        .frame(maxWidth: .infinity)
        .background(colorScheme.black.transparent().opacity(dragIndicatorProgress < minProgressForChange ? 1.01 - Double(dragIndicatorProgress) : 0.01))
        .cornerRadius(Constant.cornerRadius)
        .onTapGesture
        {
            onTapAction()
        }
        .simultaneousGesture(!isActivityControllerPresented ? dragGesture : nil)
        .onChange(of: isActivityControllerPresented)
        { isActivityControllerPresented in
            if isActivityControllerPresented
            {
                if !UserDefaults.hasInformedAboutAds
                {
                    self.isActivityControllerPresented = false
                    presentAdsInformerModalView() // Inform user ads may be presented. One time.
                }
                
                //                else if !isConnectedToNetwork
                //                {
                //                    self.isActivityControllerPresented = false
                //                    presentNoNetworkConnectionModalView() // Inform used network issue.
                //                }
                
                else if UserDefaults.createdLoopsCounter > Constant.createdLoopsWithNoAd
                {
                    #if !targetEnvironment(simulator)
                    if !isLoopAlreadyGenerated
                    {
                        isCombiningLoop = true
                        combineLoop()
                    }
                    
                    isProcessingAd = true // Load + show ad. This will also starts combining loop if not combined yet.
                    #else
                    if isLoopAlreadyGenerated
                    {
                        
                        // We already created the loop with the latest updates.
                        presentActivityViewController()
                    }
                    else
                    {
                        isCombiningLoop = true
                        combineLoop()
                    }
                    #endif
                }
                else
                {
                    if isLoopAlreadyGenerated
                    {
                        
                        // We already created the loop with the latest updates.
                        presentActivityViewController()
                    }
                    else
                    {
                        isCombiningLoop = true
                        combineLoop()
                    }
                }
            }
        }
        .onChange(of: isCombiningLoop)
        { isCombiningLoop in
            if !isProcessingAd && !isCombiningLoop && isActivityControllerPresented && finalLoopFileURL != nil
            {
                presentActivityViewController()
            }
        }
        .onChange(of: isProcessingAd)
        { isProcessingAd in
            if !isProcessingAd && !isCombiningLoop && isActivityControllerPresented && finalLoopFileURL != nil
            {
                presentActivityViewController()
            }
        }
    }
    
    private func combineLoop()
    {
        combineLoopFor(
            frameFileURLs: frameFileURLs,
            adjustableTextFieldProperties: adjustableTextFieldViews.map
            {
                return $0.textProperties
            },
            adjustableStickerProperties: adjustableStickerViews.map
            {
                return $0.stickerProperties
            },
            adjustablePhotoProperties: adjustablePhotoViews.map
            {
                return $0.photoProperties
            },
            isReversed: isReversed,
            captureFileType: currentCaptureFileType,
            interFrameDelay: interFrameDelay,
            videoFormatLoopCounter: videoFormatLoopCounter,
            selectedFilterType: selectedFilterType,
            isAddingWatermark: true
        )
        { loopFileURL in
            if let loopFileURL = loopFileURL
            {
                
                // Updating the previous used text field properties.
                previousCombinedAdjustableTextFieldProperties = adjustableTextFieldViews.map
                {
                    $0.textProperties.copy() as! AdjustableTextFieldTextProperties
                }
                
                // Updating the previous used sticker properties.
                previousCombinedAdjustableStickerProperties = adjustableStickerViews.map
                {
                    $0.stickerProperties.copy() as! AdjustableStickerProperties
                }
                
                // Updating the previous used sticker properties.
                previousCombinedAdjustablePhotoProperties = adjustablePhotoViews.map
                {
                    $0.photoProperties.copy() as! AdjustablePhotoProperties
                }
                
                previousIsReversed = isReversed
                previousInterFrameDelay = interFrameDelay
                previousVideoFormatLoopCounter = videoFormatLoopCounter
                previousSelectedFilterType = selectedFilterType
                
                if let finalLoopFileURL = finalLoopFileURL
                {
                    
                    // Deleting the previous created loop, if any.
                    try? FileManager.deleteFile(fileURL: finalLoopFileURL)
                }
                
                finalLoopFileURL = loopFileURL
            }
            
            isCombiningLoop = false
        }
    }
    
    private var creatingLoopProgressView: some View
    {
        ProgressView("Creating Loop")
            .progressViewStyle(CircularProgressViewStyle(tint: colorScheme.white))
            .font(Font.body.weight(.semibold))
            .foregroundColor(colorScheme.white)
            .padding(.vertical, factor: 2)
            .padding(.horizontal, factor: 4)
            .margin(.bottom, factor: 1)
    }
    
    private func onTapAction()
    {
        if !isActivityControllerPresented
        {
            withAnimation(dragIndicatorAnimation)
            {
                dragIndicatorProgress = minDragIndicatorProgress
            }
            
            if !isActivityControllerPresented
            {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35)
                {
                    isActivityControllerPresented = true
                }
            }
        }
    }
    
    private func presentNoNetworkConnectionModalView()
    {
        if !modalViewPresenterManager.isPresented
        {
            modalViewPresenterManager.presentModal(presentationStart: .top, isBlockingBackground: false, isShadowEnabled: true, isGestureDismissable: true)
            {
                let systemSymbolName = "wifi.slash"
                let title = "Internet Connection Issue"
                let description = "Please check your internet connection or try again later. Tap to go to Settings."
                
                AnyView(
                    DialogBoxView(systemSymbolName: systemSymbolName, title: title, description: description, isTappable: true)
                    {
                        UIApplication.openSettings()
                    }
                    .margin(.all)
                )
            }
        }
        
        withAnimation(dragIndicatorAnimation)
        {
            dragIndicatorProgress = maxDragIndicatorProgress
        }
    }
    
    private func presentAdsInformerModalView()
    {
        modalViewPresenterManager.presentModal(presentationStart: .bottom, isBlockingBackground: true, isShadowEnabled: false, isGestureDismissable: true)
        {
            AnyView(
                VStack(alignment: .center, spacing: 0)
                {
                    DragIndicatorView(progress: .constant(0), fillColor: nil, isTranslucent: false)
                        .margin(.bottom)
                    
                    VStack(alignment: .leading, spacing: 0)
                    {
                        Text("Hey 👋, welcome to Loophole!")
                            .font(Font.title3.weight(.semibold))
                            .margin(.vertical)
                        
                        Text("We have a short message for you.")
                            .font(Font.body)
                            .padding(.bottom, factor: 2)
                        
                        Text("In order to keep Loophole free and continuously improved, you may get an ad before you can share your newly created loop.")
                            .font(Font.body)
                            .margin(.bottom)
                        
                        Text("Have fun looping!")
                            .font(Font.body.weight(.semibold))
                    }
                    .foregroundColor(colorScheme.blackComplement)
                }
                .onAppear
                {
                    UserDefaults.standard.setValue(true, forKey: UserDefaults.Key.hasInformedAboutAdsKey)
                }
                .onDisappear
                {
                    isActivityControllerPresented = true
                }
                .frame(maxWidth: .infinity)
                .margin(.all)
                .background(colorScheme.whiteComplement)
                .cornerRadius(Constant.cornerRadius)
                .margin(.all)
            )
        }
    }
    
    private var dragGesture: _EndedGesture<_ChangedGesture<DragGesture>>
    {
        func updateDragIndicatorProgressOnChange(dragGestureValue: DragGesture.Value)
        {
            if startDragIndicatorProgress == invalidStartDragIndicatorProgress
            {
                startDragIndicatorProgress = dragIndicatorProgress
            }
            
            let translationY = dragGestureValue.translation.height
            
            guard !translationY.isNaN, !translationY.isInfinite, !translationY.isZero
            else
            {
                return
            }
            
            let newDragIndicatorProgress = startDragIndicatorProgress + translationY / maxDragOffsetY
            
            if newDragIndicatorProgress >= minDragIndicatorProgress && newDragIndicatorProgress <= maxDragIndicatorProgress
            {
                withAnimation(dragIndicatorAnimation)
                {
                    self.dragIndicatorProgress = newDragIndicatorProgress
                }
            }
        }
        
        func updateDragIndicatorProgressOnEnd()
        {
            if dragIndicatorProgress <= minProgressForChange
            {
                withAnimation(dragIndicatorAnimation)
                {
                    dragIndicatorProgress = minDragIndicatorProgress
                }
                
                if !isActivityControllerPresented
                {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35)
                    {
                        isActivityControllerPresented = true
                    }
                }
            }
            else if dragIndicatorProgress > minProgressForChange
            {
                withAnimation(dragIndicatorAnimation)
                {
                    dragIndicatorProgress = maxDragIndicatorProgress
                }
            }
            
            startDragIndicatorProgress = invalidStartDragIndicatorProgress
        }
        
        return DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged
            { value in
                updateDragIndicatorProgressOnChange(dragGestureValue: value)
            }
            .onEnded
            { _ in
                updateDragIndicatorProgressOnEnd()
            }
    }
    
    private func presentActivityViewController()
    {
        let activityItems: [Any] =
            [
                finalLoopFileURL as Any
            ]
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        UINavigationController.isNavigationBarHidden = false
        
        activityViewController.excludedActivityTypes = [.addToReadingList, .assignToContact, .copyToPasteboard, .markupAsPDF, .openInIBooks, .print]
        activityViewController.completionWithItemsHandler =
            { activityType, completed, _, error in
                isActivityControllerPresented = false
                activityCompletionHandler(activityType: activityType, completed: completed, error: error)
            }
        
        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true)
        {
            dragIndicatorProgress = 1
        }
    }
    
    private func dialogBoxTextWith(activityType: UIActivity.ActivityType, systemSymbolName: inout String, description: inout String, title: inout String, hasFailed: Bool)
    {
        if hasFailed
        {
            systemSymbolName = "xmark.circle.fill"
            title = "Something went wrong"
        }
        else
        {
            systemSymbolName = "checkmark.circle.fill"
            title = "Success"
        }
        
        switch activityType
        {
            case .airDrop:
                if hasFailed
                {
                    description += "We couldn't share your loop via AirDrop."
                }
                else
                {
                    description += "Your loop has been successfully shared via AirDrop."
                }
                
            case .mail:
                if hasFailed
                {
                    description += "We couldn't send your loop via email."
                }
                else
                {
                    description += "Your loop has been successfully sent via email."
                }
                
            case .message:
                if hasFailed
                {
                    description += "We couldn't send your loop as a message."
                }
                else
                {
                    description += "Your loop has been successfully sent as a message."
                }
                
            case .postToFacebook:
                if hasFailed
                {
                    description += "We couldn't share your loop on Facebook."
                }
                else
                {
                    description += "Your loop has been successfully shared on Facebook."
                }
                
            case .postToFlickr:
                if hasFailed
                {
                    description += "We couldn't share your loop on Flickr."
                }
                else
                {
                    description += "Your loop has been successfully shared on Flickr."
                }
                
            case .postToTencentWeibo:
                if hasFailed
                {
                    description += "We couldn't share your loop on Weibo."
                }
                else
                {
                    description += "Your loop has been successfully shared on Weibo."
                }
                
            case .postToTwitter:
                if hasFailed
                {
                    description += "We couldn't share your loop on Twitter."
                }
                else
                {
                    description += "Your loop has been successfully shared on Twitter."
                }
                
            case .postToVimeo:
                if hasFailed
                {
                    description += "We couldn't share your loop on Vimeo."
                }
                else
                {
                    description += "Your loop has been successfully shared on Vimeo."
                }
                
            case .postToWeibo:
                if hasFailed
                {
                    description += "We couldn't share your loop on Weibo."
                }
                else
                {
                    description += "Your loop has been successfully shared on Weibo."
                }
                
            case .saveToCameraRoll:
                if hasFailed
                {
                    description += "We couldn't save your loop to Photos Library."
                }
                else
                {
                    description += "Your loop has been successfully saved to Photos Library."
                }
                
            default:
                if hasFailed
                {
                    description += "We couldn't share your loop."
                }
                else
                {
                    description += "Your loop has been successfully shared."
                }
        }
        
        if hasFailed
        {
            description += " Please try again!"
        }
    }
    
    private func activityCompletionHandler(activityType: UIActivity.ActivityType?, completed: Bool, error: Error?)
    {
        if completed, let activityType = activityType
        {
            var systemSymbolName = ""
            var description = ""
            var title = ""
            var hasFailed = false
            
            if let error = error
            {
                debugPrint(error)
                hasFailed = true
            }
            
            dialogBoxTextWith(activityType: activityType, systemSymbolName: &systemSymbolName, description: &description, title: &title, hasFailed: hasFailed)
            
            // Presents a modal with the current state of sharing for current loop.
            modalViewPresenterManager.presentModal(presentationStart: .top, isBlockingBackground: false, isShadowEnabled: true)
            {
                AnyView(
                    DialogBoxView(systemSymbolName: systemSymbolName, title: title, description: description, isTappable: false)
                        .margin(.all)
                )
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + shareNotificationAutoDismissSec)
            {
                modalViewPresenterManager.dismiss()
            }
        }
    }
    
    private func didChangeAdjustableTextFieldViews() -> Bool
    {
        for adjustableTextFieldView in adjustableTextFieldViews
        {
            var exists: Bool = false
            
            for previousCombinedAdjustableTextFieldProperty in previousCombinedAdjustableTextFieldProperties
            {
                if previousCombinedAdjustableTextFieldProperty == adjustableTextFieldView.textProperties
                {
                    
                    // Means the text field was added to the previous loop with the same properties.
                    exists = true
                    break
                }
            }
            
            if !exists
            {
                return true
            }
        }
        
        return false
    }
    
    private func didChangeAdjustableStickerViews() -> Bool
    {
        for adjustableStickerView in adjustableStickerViews
        {
            var exists: Bool = false
            
            for previousCombinedAdjustableStickerProperty in previousCombinedAdjustableStickerProperties
            {
                if previousCombinedAdjustableStickerProperty == adjustableStickerView.stickerProperties
                {
                    
                    // Means the sticker was added to the previous loop with the same properties.
                    exists = true
                    break
                }
            }
            
            if !exists
            {
                return true
            }
        }
        
        return false
    }
    
    private func didChangeAdjustablePhotoViews() -> Bool
    {
        for adjustablePhotoView in adjustablePhotoViews
        {
            var exists: Bool = false
            
            for previousCombinedAdjustablePhotoProperty in previousCombinedAdjustablePhotoProperties
            {
                if previousCombinedAdjustablePhotoProperty == adjustablePhotoView.photoProperties
                {
                    
                    // Means the photo was added to the previous loop with the same properties.
                    exists = true
                    break
                }
            }
            
            if !exists
            {
                return true
            }
        }
        
        return false
    }
    
    /// Shows if the previous loop has been generated already by checking all the previous added text fields and stickers.
    private var isLoopAlreadyGenerated: Bool
    {
        var isLoopAlreadyGenerated =
            
            // If we don't have a file, it's pointless to check.
            finalLoopFileURL != nil &&
            
            // Text fields may persist in equality but new ones may be added.
            adjustableTextFieldViews.count == previousCombinedAdjustableTextFieldProperties.count &&
            
            // Stickers may persist in equality but new ones may be added.
            adjustableStickerViews.count == previousCombinedAdjustableStickerProperties.count &&
            
            // Photos may persist in equality but new ones may be added.
            adjustablePhotoViews.count == previousCombinedAdjustablePhotoProperties.count &&
            
            previousIsReversed == isReversed &&
            previousInterFrameDelay == interFrameDelay &&
            previousVideoFormatLoopCounter == videoFormatLoopCounter &&
            previousSelectedFilterType == selectedFilterType
        
        if isLoopAlreadyGenerated
        {
            isLoopAlreadyGenerated = !(
                didChangeAdjustableStickerViews() ||
                    didChangeAdjustableTextFieldViews() ||
                    didChangeAdjustablePhotoViews()
            )
        }
        
        return isLoopAlreadyGenerated
    }
}
