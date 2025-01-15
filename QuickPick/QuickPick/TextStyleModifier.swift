//
//  TextStyleModifier.swift
//  QuickPick
//
//  Created by Nahian Zarif on 15/1/25.
//

import Foundation

import SwiftUI

struct TextStyleModifier: ViewModifier {
    @AppStorage("fontSize") private var fontSize: Double = 16
    @AppStorage("fontFamily") private var fontFamily: String = "Helvetica"
    @AppStorage("textColor") private var colorIndex: Int = 0
    
    private let availableColors: [Color] = [.black, .blue, .red, .green]
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: fontSize))  // Changed to system font for better compatibility
            .foregroundColor(availableColors[colorIndex])
    }
}

// Add these extensions
extension View {
    func withCustomTextStyle() -> some View {
        modifier(TextStyleModifier())
    }
}

extension Text {
    func withCustomTextStyle() -> some View {
        modifier(TextStyleModifier())
    }
}
