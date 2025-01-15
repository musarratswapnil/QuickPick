//
//  AllPolls.swift
//  QuickPick
//
//  Created by Nahian Zarif on 16/1/25.
//

import Foundation

import SwiftUI

struct AllPollsView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var vm = HomeViewModel()
    @State private var selectedPollId: String? = nil

    var body: some View {
        NavigationView {
            List(vm.polls) { poll in
                VStack(alignment: .leading, spacing: 10) {
                    Text(poll.name)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 5)
                    
                    HStack {
                        Image(systemName: "chart.bar.xaxis")
                            .foregroundColor(.white)
                        Text("Total Votes: \(poll.totalCount)")
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    PollChartView(options: poll.options)
                        .frame(height: 160)
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .listRowBackground(Color.black)
                .onTapGesture {
                    selectedPollId = poll.id // Correctly pass the poll ID
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.black)
            .navigationTitle("All Polls")
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
            .onAppear {
                Task {
                    await vm.listenToLivePolls()
                }
            }
        }
        // Open PollView in a sheet
        .sheet(item: $selectedPollId) { id in
            NavigationStack {
                PollView(vm: PollViewModel(pollId: id))
            }
        }
    }
}
