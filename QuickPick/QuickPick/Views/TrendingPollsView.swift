//
//  TrendingPollsView.swift
//  QuickPick
//
//  Created by Nahian Zarif on 16/1/25.
//

import SwiftUI

struct TrendingPollsView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var vm = HomeViewModel()
    @State private var selectedPollId: String? = nil
    
    var trendingPolls: [Poll] {
        Array(vm.polls.sorted { $0.totalCount > $1.totalCount }.prefix(3))
    }
    
    var body: some View {
        NavigationView {
            List(trendingPolls) { poll in
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(poll.name)
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                        Text("\(poll.totalCount) votes")
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.vertical, 5)
                    
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
            .background(Color.black)
            .navigationTitle("Trending Polls")
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
        .sheet(item: $selectedPollId) { pollId in
            NavigationStack {
                PollView(vm: PollViewModel(pollId: pollId))
            }
        }
    }
}

#Preview {
    TrendingPollsView()
}
