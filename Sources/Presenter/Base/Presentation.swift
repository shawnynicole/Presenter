//
//  Presentation.swift
//  
//
//  Created by DeShawn Jackson on 7/15/21.
//

import SwiftUI
import Colors

/// Call .presents on the "label" view
public struct Presentation<Label: View, Content: View>: View {
    
    // MARK: - Controller
    
    // A controller is needed to assign the label's GeometryProxy for the positioning of the presentation view
    // Using @State private var proxy: GeometryProxy! will result in mutating errors/undesired behavior.
    public class Controller: ObservableObject {
        @Published var proxy: GeometryProxy!
    }
    
    // MARK: - Environment
    
    // Extract the presenter
    @Environment(\.presenter) var presenter
        
    // MARK: - Stored Properties
        
    // A controller is needed to assign the label's GeometryProxy for the positioning of the presentation view
    // Using @State private var proxy: GeometryProxy! will result in mutating errors/undesired behavior.
    @StateObject private var controller: Controller = .init()
    
    /// Determines when to present the presentation view
    @Binding public var isPresenting: Bool
    
    ///
    public let dismissOnExternalTap: Bool
    
    ///
    public let dismissOnDisappear: Bool
    
    /// The view that will call present and dismiss on the Presenter
    public let label: () -> Label
    
    /// The view that will be presented
    public let content: ((label: GeometryProxy, presenter: GeometryProxy)) -> Content
    
    // MARK: - Init
    
    internal init(
        isPresenting: Binding<Bool>,
        dismissOnExternalTap: Bool,
        dismissOnDisappear: Bool,
        label: @escaping () -> Label,
        presents content: @escaping ((label: GeometryProxy, presenter: GeometryProxy)) -> Content
    ) {
        self._isPresenting = isPresenting
        self.dismissOnExternalTap = dismissOnExternalTap
        self.dismissOnDisappear = dismissOnDisappear
        self.label = label
        self.content = content
    }
    
    // MARK: - View
    
    public var body: some View {
        label()
            .geometryReader { proxy in
                // IMPORTANT: Check if the proxy is already updated; Otherwise an infinite view update loop will initiate.
                if controller.proxy == nil {
                    controller.proxy = proxy
                }
            }
            .onChange(of: isPresenting) { isPresenting in
                isPresenting ? present() : dismiss()
            }
            .onDisappear {
                if dismissOnDisappear {
                    isPresenting = false // IMPORTANT: Do not call dismiss(). dismiss() DOES NOT update isPresenting. isPresenting DOES call dismiss()
                }
            }
    }
    
    /// Present the presentation view. Only call this function when isPresenting changes. Do not update isPresenting in this method.
    private func present() {
        
        // Present the view (with the adjust offset and frame)
        presenter?.present({
            // Wrap the content in a tappable view to dismiss when user taps outside of presentation view
            // NOTE: To dismiss touches in SwiftUI navigation bar, ContentView().presenter(). Custom navigation bar works regardless.
            // Register tap to dismiss touches to presenter using Color.invisible
            // IMPORTANT: Color.clear/clear views do not accept touches. Without the color onTapGesture doesn't work
            Color.invisible
                .edgesIgnoringSafeArea(.top)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onTapGesture {
                    if dismissOnExternalTap {
                        isPresenting = false // IMPORTANT: Do not call dismiss(). dismiss() DOES NOT update isPresenting. isPresenting DOES call dismiss()
                    }
                }
                .geometryReader { proxy in
                    content((label: controller.proxy, presenter: proxy))
                }
        })
    }
    
    /// Dismiss the presentation view. Only call this function when isPresenting changes. Do not update isPresenting in this method.
    private func dismiss() {
        guard presenter?.isPresenting == true else {
            return
        }
        
        presenter?.dismiss()
    }
}
