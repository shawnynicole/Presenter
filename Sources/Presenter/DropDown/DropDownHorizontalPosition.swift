//
//  SwiftUIView.swift
//  
//
//  Created by DeShawn Jackson on 7/15/21.
//

import SwiftUI

public enum DropDownHorizontalPosition {
    
    case labelWidth
    case center(width: CGFloat)
    case leading(width: CGFloat)
    case trailing(width: CGFloat)
    
    public var alignment: LabelHorizontalAlignment {
        switch self {
        case .labelWidth: return .leading
        case .center: return .center
        case .leading: return .leading
        case .trailing: return .trailing
        }
    }
    
    public var width: CGFloat? {
        switch self {
        case .labelWidth: return nil
        case .center(let width): return width
        case .leading(let width): return width
        case .trailing(let width): return width
        }
    }
    
    public enum LabelHorizontalAlignment {
        case center
        case leading
        case trailing
    }
}
