//
//  CreatePollView.swift
//  QuickPick
//
//  Created by Nahian Zarif on 16/1/25.
//

import Foundation
import SwiftUI

struct CreatePollView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var vm = HomeViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Create Poll Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Create a Poll")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        TextField("Enter poll name", text: $vm.newPollName, axis: .vertical)
                            .withCustomStyle()
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)

                        Button("Submit") {
                            Task { await vm.createNewPoll() }
                        }
                        .withCustomStyle()
                        .disabled(vm.isCreateNewPollButtonDisabled)

                        if vm.isLoading {
                            ProgressView()
                        }

                        Text("Enter poll name & add 2-4 options to submit")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(15)
                    
                    // Options Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Options")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        TextField("Enter option name", text: $vm.newOptionName)
                            .withCustomStyle()
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)

                        Button("+ Add Option") {
                            vm.addOption()
                        }
                        .withCustomStyle()
                        .disabled(vm.isAddOptionsButtonDisabled)

                        ForEach(vm.newPollOptions, id: \.self) { option in
                            Text(option)
                                .withCustomStyle()
                        }
                        .onDelete { indexSet in
                            vm.newPollOptions.remove(atOffsets: indexSet)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(15)
                }
                .padding()
            }
            .background(Color.black)
            .navigationTitle("Create Poll")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(.red)
                    }
                }
            }
        }
    }
}
