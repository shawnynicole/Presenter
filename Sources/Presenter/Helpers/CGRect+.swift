//
//  CGRect+.swift
//  
//
//  Created by DeShawn Jackson on 7/15/21.
//

import SwiftUI

extension CGRect {
    public var center: CGPoint {
        CGPoint(x: (minX + maxX) / 2, y: (minY + maxY) / 2)
    }
}
