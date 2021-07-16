//
//  View+.swift
//  
//
//  Created by DeShawn Jackson on 7/15/21.
//

import SwiftUI

// MARK: - Helpers

extension View {
    
    /// Use a closure to assign an overlay view
    public func transition(_ transition: @escaping () -> AnyTransition) -> some View {
        self.transition(transition())
    }

    /// Use a closure to assign an overlay view
    public func overlay<Overlay: View>(_ overlay: @escaping () -> Overlay) -> some View {
        self.overlay(overlay())
    }

    /// Use a closure to assign a background view
    public func background<Background: View>(_ background: @escaping () -> Background) -> some View {
        self.background(background())
    }

    /// Presents the GeometryReader as an overlay to the view
    public func geometryReader(_ proxy: @escaping (GeometryProxy) -> Void) -> some View {
        overlay(GeometryReader { value -> Color in
            proxy(value)
            return .clear
        })
    }

    /// Presents the GeometryReader as an overlay to the view
    public func geometryReader<Content: View>(_ proxy: @escaping (GeometryProxy) -> Content) -> some View {
        overlay(GeometryReader { proxy($0) })
    }
}
