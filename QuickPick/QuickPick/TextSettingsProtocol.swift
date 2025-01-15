//
//  TextSettingsProtocol.swift
//  QuickPick
//
//  Created by Nahian Zarif on 15/1/25.
//

import Foundation

import SwiftUI

// Protocol definition
protocol TextSettingsDelegate: AnyObject {
    func didUpdateFontSize(_ size: Double)
    func didUpdateFontFamily(_ fontFamily: String)
    func didUpdateTextColor(_ color: Color)
}
