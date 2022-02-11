//
//
//  Project Name: Thecircle 
//  Workspace: Loophole
//  MacOS Version: 11.2
//			
//  File Name: StepperView.swift
//  Creation: 4/18/21 11:03 AM
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

public struct StepperView: View
{
    @Environment(\.colorScheme) private var colorScheme
    
    @Binding private var currentStep: Int
    
    private let range: ClosedRange<Int>
    private let font: Font
    private let signFont: Font
    private let foregroundColor: Color
    private let signForegroundColor: Color
    private let backgroundColor: Color
    private let currentStepStringIndicatorHandler: (_ step: Int) -> String
    
    public init(currentStep: Binding<Int>, range: ClosedRange<Int>, font: Font = .body, signFont: Font = Font.caption2.weight(.black), foregroundColor: Color = .white, signForegroundColor: Color = .black, backgroundColor: Color = .black, _ currentStepStringIndicatorHandler: @escaping (_ step: Int) -> String)
    {
        _currentStep = currentStep
        self.range = range
        self.font = font
        self.signFont = signFont
        self.foregroundColor = foregroundColor
        self.signForegroundColor = signForegroundColor
        self.backgroundColor = backgroundColor
        self.currentStepStringIndicatorHandler = currentStepStringIndicatorHandler
    }
    
    public var body: some View
    {
        ZStack(alignment: .center)
        {
            PageView<AnyView>(currentPage: $currentStep, orientation: .horizontal, isHapticEnabled: false, isAnimationEnabled: true)
            {
                var stepTextIndicators: [AnyView] = []
                
                for step in range
                {
                    // Getting the string that indicates the current step.
                    let currentStepTextIndicator = Text(currentStepStringIndicatorHandler(step))
                    
                    stepTextIndicators.append(AnyView(currentStepTextIndicator))
                }
                
                return stepTextIndicators
            }
            
            GeometryReader
            { proxy in
                VStack(alignment: .center, spacing: 0)
                {
                    HStack(alignment: .center, spacing: 0)
                    {
                        let rangeMin = (range.min() ?? 1) - 1
                        
                        signView(systemSymbolName: "minus", stepperWidth: proxy.size.width, paddingEdgeSet: .trailing)
                            .foregroundColor(signForegroundColor.opacity(currentStep > rangeMin ? 1 : 0.5))
                            .onTapGesture
                            {
                                if currentStep - 1 >= rangeMin
                                {
                                    currentStep -= 1
                                }
                            }
                        
                        Spacer()
                        
                        let rangeMax = (range.max() ?? 1) - 1
                        
                        signView(systemSymbolName: "plus", stepperWidth: proxy.size.width, paddingEdgeSet: .leading)
                            .foregroundColor(signForegroundColor.opacity(currentStep < rangeMax ? 1 : 0.5))
                            .onTapGesture
                            {
                                if currentStep + 1 <= rangeMax
                                {
                                    currentStep += 1
                                }
                            }
                    }
                    .font(signFont)
                }
            }
        }
        .font(font)
        .lineLimit(1)
        .foregroundColor(foregroundColor)
        .background(backgroundColor)
        .clipShape(Capsule(style: .continuous))
    }
    
    private func signView(systemSymbolName: String, stepperWidth: CGFloat, paddingEdgeSet: Edge.Set) -> some View
    {
        Image(systemName: systemSymbolName)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(paddingEdgeSet, stepperWidth / 8)
            .background(backgroundColor.opacity(0.01))
    }
}

struct StepperView_Previews: PreviewProvider
{
    @State static private var currentStep: Int = 0
    
    static var previews: some View
    {
        StepperView(currentStep: $currentStep, range: 0...10, font: Font.body.weight(.semibold))
        { step in
            return "\(String(format: "%.1f", Double(step) / 10))s"
        }
        .frame(width: 80, height: 40, alignment: .center)
    }
}
