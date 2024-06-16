//
//  TextModifier.swift
//  swiftui-omdb
//
//  Created by Taufiq Ichwanusofa on 16/06/24.
//

import SwiftUI

class TextModifier {
    struct Regular_17: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(.system(size: 17, weight: .regular))
        }
    }

    struct SemiBold_20: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(.system(size: 20, weight: .semibold))
        }
    }
}
