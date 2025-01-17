//
//  JoinPollsView.swift
//  QuickPick
//
//  Created by Nahian Zarif on 16/1/25.
//

import Foundation


import SwiftUI
import FirebaseFirestore

struct JoinPollView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var pollId: String = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var selectedPollId: String? = nil
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Join a Poll")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                
                TextField("Enter Poll ID", text: $pollId)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: validateAndJoinPoll) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Join Poll")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
                .background(Color.red)
                .cornerRadius(10)
                .padding(.horizontal)
                .disabled(pollId.isEmpty || isLoading)
                
                Spacer()
            }
            .padding()
            .background(Color.black)
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .sheet(item: $selectedPollId) { id in
                NavigationStack {
                    PollView(vm: .init(pollId: id))
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
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
    
    private func validateAndJoinPoll() {
        isLoading = true
        let db = Firestore.firestore()
        
        db.collection("polls").document(pollId).getDocument { snapshot, error in
            isLoading = false
            
            if let error = error {
                errorMessage = error.localizedDescription
                showError = true
                return
            }
            
            guard let snapshot = snapshot, snapshot.exists else {
                errorMessage = "No poll found with this ID"
                showError = true
                return
            }
            
            selectedPollId = pollId
        }
    }
}
