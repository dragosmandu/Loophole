//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: TextFieldView.swift
//  Creation: 4/11/21 9:39 AM
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

public struct TextFieldView: View
{
    public static var defaultFont: Font = .body
    public static var defaultColor: Color = .white
    public static var defaultPlaceholder: String = "Write something..."
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @Binding private var text: String
    @Binding private var font: Font
    @Binding private var foregroundColor: Color
    
    private let placeholder: String
    private let onFocusChangeAction: (_ isFocused: Bool) -> Void
    private let onCommitAction: () -> Void
    
    /// - Parameters:
    ///   - text: The current text field string.
    ///   - font: The current font used for the placeholder and text.
    ///   - foregroundColor: The current text and placeholder color. If not provided will use a default color.
    ///   - placeholder: The text to appear when the field isn't focused or no text written yet.
    ///   - onFocusAction: Action to be called when the field focus change.
    ///   - onCommitAction: Action to be called when the return button is pressed.
    public init(text: Binding<String>, font: Binding<Font> = .constant(TextFieldView.defaultFont), foregroundColor: Binding<Color> = .constant(TextFieldView.defaultColor), placeholder: String = TextFieldView.defaultPlaceholder, _ onFocusChangeAction: @escaping (_ isFocused: Bool) -> Void = { _ in }, onCommitAction: @escaping () -> Void = { })
    {
        _text = text
        _font = font
        _foregroundColor = foregroundColor
        self.placeholder = placeholder
        self.onFocusChangeAction = onFocusChangeAction
        self.onCommitAction = onCommitAction
    }
    
    public var body: some View
    {
        ZStack(alignment: .leading)
        {
            if text.count == 0 && placeholder.count > 0
            {
                Text(placeholder)
            }
            
            TextField("", text: $text)
            { (isFocused) in
                onFocusChangeAction(isFocused)
            }
            onCommit:
            {
                onCommitAction()
            }
            .textFieldStyle(PlainTextFieldStyle())
            .accentColor(colorScheme.blue)
        }
        .font(font)
        .foregroundColor(foregroundColor)
        .background(Color.clear)
    }
}

struct TextFieldView_Previews: PreviewProvider
{
    @State static private var text: String = ""
    @State static private var font: Font = .body
    @State static private var foregroundColor: Color = .black
    
    static private let placeholder = "INSERT_PLACEHOLDER"
    
    static var previews: some View
    {
        TextFieldView(text: $text, font: $font, foregroundColor: $foregroundColor, placeholder: placeholder)
        { (isFocused) in
            
        }
        onCommitAction:
        {
            
        }
    }
}
