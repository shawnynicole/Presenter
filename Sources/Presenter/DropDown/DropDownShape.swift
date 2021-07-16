//
//  DropDownShape.swift
//  
//
//  Created by DeShawn Jackson on 7/15/21.
//

import SwiftUI
import Border

struct DropDownShape_Previews: PreviewProvider {
    static var previews: some View {
        Color.white
            .dropDown()
            .padding(.horizontal, 50)
            .padding(.vertical, 150)
    }
}

public struct DropDownShape: Shape {
    
    public let cornerRadius: CGFloat
    
    public init(cornerRadius: CGFloat = 15) {
        self.cornerRadius = cornerRadius
    }
    
    public func path(in rect: CGRect) -> Path {
        let border = Border(corners: .bottom(radius: cornerRadius), edges: .all())
        return border.path(in: rect)
    }
}

extension View {
    public func dropDown(cornerRadius: CGFloat = 15, color: Color = .gray) -> some View {
        self
        .clipShape(DropDownShape(cornerRadius: cornerRadius))
        .background {
            // IMPORTANT: Color.invisible does not work here
            // This does not override any background color already being displayed
            //color
            Color.white
                .mask(DropDownShape(cornerRadius: cornerRadius))
                .shadow(color: color, radius: 4, x: 4, y: 4)
        }
    }
}
