import SwiftUI

public protocol TextSettingsDelegate {
    var fontSize: Double { get }
    var fontFamily: String { get }
    var textColor: Color { get }
    
    func didUpdateFontSize(_ size: Double)
    func didUpdateFontFamily(_ fontFamily: String)
    func didUpdateTextColor(_ color: Color)
} 