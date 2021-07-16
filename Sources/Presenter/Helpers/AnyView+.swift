//
//  AnyView.swift
//  
//
//  Created by DeShawn Jackson on 7/15/21.
//

import SwiftUI

extension AnyView {
    public init<Content: View>(_ content: @escaping () -> Content) {
        self.init(content())
    }
}
