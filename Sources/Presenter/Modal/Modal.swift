//
//  Modal.swift
//  
//
//  Created by DeShawn Jackson on 7/15/21.
//

import SwiftUI

public struct Modal<Label: View, Content: View>: View {
    
    /// Determines when to present the presentation view
    @Binding public var isPresenting: Bool
    
    /// The view that will call present and dismiss on the Presenter
    public let label: () -> Label
    
    /// The view that will be presented
    public let content: () -> Content
    
    public let padding: CGFloat
    
    public let size: CGSize?
    
    public let dismissOnExternalTap: Bool
    
    public let dismissOnDisappear: Bool
    
    // MARK: - Init
    
    public init(
        isPresenting: Binding<Bool>,
        padding: CGFloat = 50,
        dismissOnExternalTap: Bool = false,
        dismissOnDisappear: Bool = false,
        @ViewBuilder label: @escaping () -> Label,
        @ViewBuilder presents content: @escaping () -> Content
    ) {
        self._isPresenting = isPresenting
        self.size = nil
        self.padding = padding
        self.dismissOnExternalTap = dismissOnExternalTap
        self.dismissOnDisappear = dismissOnDisappear
        self.label = label
        self.content = content
    }
    
    public init(
        isPresenting: Binding<Bool>,
        size: CGSize,
        padding: CGFloat = 50,
        dismissOnExternalTap: Bool = false,
        dismissOnDisappear: Bool = false,
        @ViewBuilder label: @escaping () -> Label,
        @ViewBuilder presents content: @escaping () -> Content
    ) {
        self._isPresenting = isPresenting
        self.size = size
        self.padding = padding
        self.dismissOnExternalTap = dismissOnExternalTap
        self.dismissOnDisappear = dismissOnDisappear
        self.label = label
        self.content = content
    }
    
    public var body: some View {
        
        Presentation(isPresenting: $isPresenting, dismissOnExternalTap: dismissOnExternalTap, dismissOnDisappear: dismissOnDisappear) {
            label()
        } presents: { (labelProxy, presenterProxy) -> AnyView in
            
            // Screen padding is the minimum amount of space to leave betweent the edge of the screen and the presentation view
            let screenPadding: CGFloat = 3
            
            if var size = size {
                
                // Vertical insets
                let verticalInsets = presenterProxy.safeAreaInsets.top + presenterProxy.safeAreaInsets.bottom
                
                // Horizontal insets
                let horizontalInsets = presenterProxy.safeAreaInsets.leading + presenterProxy.safeAreaInsets.trailing
                
                // Used for offset and calculating space between label and bottom and sides of screen
                var screenFrame = UIScreen.main.bounds
                screenFrame.size.height -= verticalInsets
                screenFrame.size.width -= horizontalInsets
                
                // Adjust the width if the presentation view will extend the left or right side of the screen
                if (size.width + (padding * 2)) > (screenFrame.width - (screenPadding * 2)) {
                    let difference = (size.width + (padding * 2)) - (screenFrame.width - (screenPadding * 2))
                    size.width -= difference
                }
                
                // Adjust the height if the presentation view will extend the top or bottom of the screen
                if (size.height + (padding * 2)) > (screenFrame.height - (screenPadding * 2)) {
                    let difference = (size.height + (padding * 2)) - (screenFrame.height - (screenPadding * 2))
                    size.height -= difference
                }
                
                // Calculate the offset using the center of the adjusted screen frame and the width of the presentation view
                let screenCenter = screenFrame.center
                let offset = CGPoint(x: screenCenter.x - (size.width / 2) - padding, y: screenCenter.y - (size.height / 2) - padding)
                
                return AnyView {
                    content()
                        .frame(width: size.width, height: size.height)
                        .offset(x: offset.x, y: offset.y)
                        .padding(padding)
                }
            } else {
            
                return AnyView {
                    content()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(padding >= screenPadding ? padding : screenPadding)
                }
            }
        }
    }
}
