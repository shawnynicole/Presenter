//
//  DropDown.swift
//  
//
//  Created by DeShawn Jackson on 7/15/21.
//

import SwiftUI

public struct DropDown<Label: View, Content: View>: View {
    
    /// Determines when to present the presentation view
    @Binding public var isPresenting: Bool
    
    public let position: DropDownHorizontalPosition
    
    public let minHeight: CGFloat?
    
    public let maxHeight: CGFloat?
    
    /// The view that will call present and dismiss on the Presenter
    public let label: () -> Label
    
    /// The view that will be presented
    public let content: () -> Content
    
    // MARK: - Init
    
    public init(
        isPresenting: Binding<Bool>,
        position: DropDownHorizontalPosition = .labelWidth,
        minHeight: CGFloat? = nil,
        maxHeight: CGFloat? = nil,
        @ViewBuilder label: @escaping () -> Label,
        @ViewBuilder presents content: @escaping () -> Content
    ) {
        self._isPresenting = isPresenting
        self.position = position
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.label = label
        self.content = content
    }
    
    public var body: some View {
        
        Presentation(isPresenting: $isPresenting, dismissOnExternalTap: true, dismissOnDisappear: true) {
            label()
        } presents: { (labelProxy, presenterProxy) -> AnyView in
            
            // Obtain the frame for the label
            let labelFrame = labelProxy.frame(in: .named("presenter"))
            
            // Used for offset and calculating space between label and bottom and sides of screen
            let screenFrame = UIScreen.main.bounds
            
            // Width is needs to calculate x
            var width = position.width ?? labelFrame.width // defaults to same width as label
            width = min(width, screenFrame.width)
            
            var rect = CGRect(
                x: {
                    switch position.alignment {
                    case .leading: return labelFrame.minX // leading corner of label
                    case .trailing: return labelFrame.maxX - width
                    case .center:
                        let labelCenterX = labelFrame.center.x
                        return labelCenterX - (width / 2)
                    }
                }(),
                y: labelFrame.maxY, // bottom of label
                width: width,
                height: {
                    // Calculate height
                    
                    // Calculate the space between the bottom of screen and bottom of label
                    
                    var height: CGFloat = screenFrame.height - labelFrame.maxY
                    
                    // Calculate max height
                    if let maxHeight = maxHeight {
                        height = min(height, maxHeight)
                    } else {
                        height = min(height, 200) // default max height
                    }
                    
                    // Calculate min height
                    if let minHeight = minHeight {
                        height = max(height, minHeight)
                    } else {
                        height = max(height, 44) // default min height
                    }
                    
                    return height
                }())
            
            // Screen padding is the minimum amount of space to leave betweent the edge of the screen and the presentation view
            let screenPadding: CGFloat = 3
            
            // Adjust the x and width if the presentation view will extend the left side of the screen
            if rect.minX < (screenFrame.minX + screenPadding) {
                
                switch position {
                case .labelWidth, .center, .leading:
                    rect.size.width = screenFrame.width - screenPadding
                    rect.origin.x = screenFrame.minX + screenPadding
                case .trailing:
                    let difference = (screenFrame.minX + screenPadding) - rect.minX 
                    rect.size.width -= difference
                    rect.origin.x += difference
                }
            }

            // Adjust the width if the presentation view will extend the right side of the screen
            if rect.maxX > (screenFrame.maxX - screenPadding) {
                let difference = rect.maxX - (screenFrame.maxX - screenPadding)
                rect.size.width -= difference
            }
            
            return AnyView {
                content()
                    .frame(width: rect.width, height: rect.height)
                    .offset(x: rect.origin.x, y: rect.origin.y)
            }
        }
    }
}
