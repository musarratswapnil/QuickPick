import Foundation

import SwiftUI

// Delegator
class TextSettingsViewModel: ObservableObject {
    weak var delegate: TextSettingsDelegate?
    
    @Published var fontSize: Double = UserDefaults.standard.double(forKey: "fontSize") {
        didSet {
            UserDefaults.standard.set(fontSize, forKey: "fontSize")
            delegate?.didUpdateFontSize(fontSize)
        }
    }
    
    @Published var selectedFont: String = UserDefaults.standard.string(forKey: "fontFamily") ?? "Helvetica" {
        didSet {
            UserDefaults.standard.set(selectedFont, forKey: "fontFamily")
            delegate?.didUpdateFontFamily(selectedFont)
        }
    }
    
    @Published var selectedColorIndex: Int = UserDefaults.standard.integer(forKey: "textColor") {
        didSet {
            UserDefaults.standard.set(selectedColorIndex, forKey: "textColor")
            delegate?.didUpdateTextColor(availableColors[selectedColorIndex].color)
        }
    }
    
    let availableFonts = [
        "Helvetica",
        "Arial",
        "Georgia",
        "Times New Roman",
        "San Francisco"
    ]
    
    let availableColors: [(name: String, color: Color)] = [
        ("Black", .black),
        ("Blue", .blue),
        ("Red", .red),
        ("Green", .green)
    ]
}

struct TextSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = TextSettingsViewModel()
    
    init(delegate: TextSettingsDelegate) {
        _viewModel = StateObject(wrappedValue: TextSettingsViewModel())
        viewModel.delegate = delegate
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Font Size Section
                Section("Font Size") {
                    VStack {
                        Text("Sample Text Size: \(Int(viewModel.fontSize))")
                            //.font(.system(size: viewModel.fontSize))
                            .withCustomStyle()
                        
                        Slider(value: $viewModel.fontSize, in: 12...24, step: 1)
                    }
                }
                
                // Font Style Section
                Section("Font Style") {
                    Picker("Select Font", selection: $viewModel.selectedFont) {
                        ForEach(viewModel.availableFonts, id: \.self) { font in
                            Text(font)
                                .withCustomStyle()
                        }
                    }
                    .pickerStyle(.menu)
                    
                    Text("Sample Text")
                        //.font(.custom(viewModel.selectedFont, size: 16))
                        .withCustomStyle()
                }
                
                // Color Section
                Section("Text Color") {
                    Picker("Select Color", selection: $viewModel.selectedColorIndex) {
                        ForEach(0..<viewModel.availableColors.count, id: \.self) { index in
                            HStack {
                                Circle()
                                    .fill(viewModel.availableColors[index].color)
                                    .frame(width: 20, height: 20)
                                Text(viewModel.availableColors[index].name)
                            }
                        }
                    }
                    .pickerStyle(.menu)
                    
                    Text("Sample Text")
                        .foregroundColor(viewModel.availableColors[viewModel.selectedColorIndex].color)
                }
            }
            .navigationTitle("Text Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .withCustomStyle()
                }
            }
        }
    }
}
