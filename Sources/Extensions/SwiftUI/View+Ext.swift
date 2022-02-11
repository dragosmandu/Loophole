//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: View+Ext.swift
//  Creation: 4/9/21 2:19 PM
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
import PhotosUI

extension View
{
    /// Sets a magnification gesture that changes the content mode relative to the pinch magnitude. The gesture disappears when isActive is false.
    func toggle(contentMode: Binding<ContentMode>, isActive: Bool = true) -> some View
    {
        ModifiedContent(content: self, modifier: ContentModeModifier(contentMode: contentMode, isActive: isActive))
    }
    
    /// Adding the View transition to the current View.
    /// - Returns: A modified View that will transition with the default View transition.
    func transition() -> some View
    {
        ModifiedContent(content: self, modifier: TransitionModifier())
    }
    
    /// - Returns: A View that pads the current View inside the specified edge insets with a default unit of padding multiplied by a given factor.
    func padding(_ edges: Edge.Set, factor: Int = 1) -> some View
    {
        ModifiedContent(content: self, modifier: PaddingModifier(edges: edges, factor: factor))
    }
    
    /// - Returns: A View that pads the current View inside the specified edge insets with a default unit of padding multiplied by a default margin factor.
    func margin(_ edges: Edge.Set, factor: Int = 1) -> some View
    {
        ModifiedContent(content: self, modifier: MarginModifier(edges: edges, factor: factor))
    }
    
    /// Sets the current View's transparency to a default value when isActive is true.
    /// When isActive is false, the current View is fully opaque.
    func transparent(isActive: Bool = true) -> some View
    {
        ModifiedContent(content: self, modifier: TransparencyModifier(isActive: isActive))
    }
    
    /// Clips the current View into a rounded rectangle with given corner radius with continuous style.
    func cornerRadius(_ cornerRadius: CGFloat) -> some View
    {
        ModifiedContent(content: self, modifier: CornerRadiusModifier(cornerRadius: cornerRadius))
    }
    
    /// Adds a tap gesture with an animation on the content View, when isActive is true.
    /// - Parameter onTapAction: Action called when the content tap animation ended.
    /// - Returns: The original View that will be animated when receives a tap gesture and calls the given action.
    func onAnimatedTapGesture(isActive: Bool, _ onTapAction: @escaping () -> Void) -> some View
    {
        ModifiedContent(content: self, modifier: AnimatedTapGestureModifier(isActive: isActive, onTapAction: onTapAction))
    }
    
    /// Adds a shadow with a default radius if isActive is true.
    func shadow(_ isActive: Bool = true) -> some View
    {
        ModifiedContent(content: self, modifier: ShadowModifier(isActive))
    }
    
    /// - Parameters:
    ///   - observedValue: The value to observe, changed by an animation.
    ///   - changedHandler: Notifies, with the current value of the observed value, when the observed value changed.
    ///   - endedHandler: Notifies when the observed value has reached the target value.
    /// - Returns: The View that has an onbserver on the animated value.
    func observeAnimation<Value: VectorArithmetic>(for value: Value, changedHandler: @escaping (_ currentValue: Value) -> Void = { _ in }, endedHandler: @escaping () -> Void = { }) -> ModifiedContent<Self, AnimationObserverModifier<Value>>
    {
        ModifiedContent(content: self, modifier: AnimationObserverModifier(observedValue: value, changedHandler: changedHandler, endedHandler: endedHandler))
    }
    
    /// Sets a background blur to the current View.
    func backgroundBlur(blurStyle: UIBlurEffect.Style? = nil, vibrancyStyle: UIVibrancyEffectStyle? = nil, isActive: Bool = true) -> some View
    {
        ModifiedContent(content: self, modifier: BackgroundBlurModifier(blurStyle: blurStyle, vibrancyStyle: vibrancyStyle, isActive: isActive))
    }
    
    /// Sets the modal presentation to the current View.
    /// - Returns: The original View.
    func setModalViewPresenter() -> some View
    {
        ModifiedContent(content: self, modifier: ModalViewPresenter.Modifier())
    }
    
    /// On isPresented true, will present the media picker screen. If isPresented is false, the media picker screen is dismissed.
    func mediaPicker(isPresented: Binding<Bool>, selectedAssets: Binding<[Int : PHAsset]>, maxNoSelectedAssets: Int = 1) -> some View
    {
        ModifiedContent(content: self, modifier: MediaPickerScreen.MediaPickerScreenPresentModifier(isPresented: isPresented, selectedAssets: selectedAssets, maxNoSelectedAssets: maxNoSelectedAssets))
    }
    
    /// Adds a notification plublisher to the View. When the notification is launched, the given action will be called.
    /// - Parameters:
    ///   - appState: The state of the app in which the notification to be triggered.
    ///   - onReceiveAction: The action to be done when the notification for that state has launched.
    func notifyOnApp(appState: ApplicationStateNotifierModifier.ApplicationState, _ onReceiveAction: @escaping () -> Void) -> some View
    {
        ModifiedContent(content: self, modifier: ApplicationStateNotifierModifier(appState: appState, onReceiveAction))
    }
    
    /// Adds a shadow gradient overlay on the current View.
    /// - Parameters:
    ///     - startPoint: The point where the shadow starts.
    ///     - endPoint: The point where the shadow ends.
    ///     - heightRatio: The ratio between the height of the overlay and the View.
    func shadowOverlay(startPoint: UnitPoint = .bottom, endPoint: UnitPoint = .top, heightRatio: CGFloat = 0.33) -> some View
    {
        ModifiedContent(content: self, modifier: ShadowOverlayModifier(startPoint: startPoint, endPoint: endPoint, heightRatio: heightRatio))
    }
    
    func hideKeyboard()
    {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
