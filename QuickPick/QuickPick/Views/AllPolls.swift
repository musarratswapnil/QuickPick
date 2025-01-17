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
    @State private var searchText = ""
    
    private var filteredPolls: [Poll] {
        if searchText.isEmpty {
            return vm.polls
        } else {
            return vm.polls.filter { poll in
                poll.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search polls...", text: $searchText)
                        .foregroundColor(.white)
                        .withCustomTextStyle()
                }
                .padding(8)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
                
                List(filteredPolls) { poll in
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
                        selectedPollId = poll.id
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
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
        .sheet(item: $selectedPollId) { id in
            NavigationStack {
                PollView(vm: PollViewModel(pollId: id))
            }
        }
    }
}
