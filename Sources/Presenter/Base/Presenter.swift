//
//  Presenter.swift
//  
//
//  Created by DeShawn Jackson on 7/15/21.
//

import SwiftUI

/// Do not call initiation directly. Call .presenter() on the desired presenter view.
public struct Presenter: View {
    
    // MARK: - Computed Properties
    
    public var isPresenting: Bool { presentation != nil }
    
    // MARK: - Stored Properties
    
    /// The view whom registered to be a presenter
    public let presenter: AnyView
    
    /// The view to present onto the presenter view
    @State private var presentation: AnyView?
    
    // MARK: - Init
    
    /// Do not call initiation directly. Call .presenter() on the desired presenter view.
    internal init<Presenter: View>(_ presenter: Presenter)  {
        self.presenter = AnyView(presenter)
    }
    
    // MARK: - View
    
    public var body: some View {
        presenter
            // Used in Presentation view to calculate the presentation view offset position
            .coordinateSpace(name: "presenter")
            // Register this Presenter view to the presenter's descendant views
            // Used in the Presentaton view to present/dismiss a presentation view
            .environment(\.presenter, self)
            // Attach presentation to presenter when presentation is presenting
            .overlay {
                presentation?
                    .transition {
                        .opacity
                            .animation(.spring())
                            .animation(.easeInOut(duration: 1))
                    }
            }
    }
    
    /// If a view is being presented, dismiss it. Used by Presentation view.
    internal func dismiss() {
        guard isPresenting else { return }
        self.presentation = nil
    }
    
    /// Present a view. Used by Presentation view.
    internal func present<Content: View>(_ content: Content) {
        self.presentation = AnyView(content)
    }
    
    /// Present a view. Used by Presentation view.
    internal func present<Content: View>(_ content: @escaping () -> Content) {
        self.presentation = AnyView(content)
    }
}

extension View {

    /// Register this view as a presenter. Wraps this view in a `Presenter` view.
    public func presenter() -> some View {
        Presenter(self)
    }
}
