//
//  EnvironmentValues.swift
//  
//
//  Created by DeShawn Jackson on 7/15/21.
//

import SwiftUI

private struct PresenterEnvironmentKey: EnvironmentKey {
    static let defaultValue: Presenter? = nil
}

extension EnvironmentValues {
    public var presenter: Presenter? {
        get { self[PresenterEnvironmentKey.self] }
        set { self[PresenterEnvironmentKey.self] = newValue }
    }
}
