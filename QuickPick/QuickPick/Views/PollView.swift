//
//  PollView.swift
//  QuickPick
//
//  Created by Nahian Zarif on 3/1/25.
//

import SwiftUI

struct PollView: View {
    
    var vm: PollViewModel
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading) {
                    Text("Poll ID")
                        .foregroundColor(.red)
                    Text(vm.pollId)
                        .font(.caption)
                        .foregroundColor(.red)
                        .textSelection(.enabled)
                }
                
                HStack {
                    Text("Updated at")
                        .foregroundColor(.red)
                    Spacer()
                    if let updatedAt = vm.poll?.updatedAt {
                        Text(updatedAt, style: .time)
                            .foregroundColor(.red)
                    }
                }
                
                HStack {
                    Text("Total Vote Count")
                        .foregroundColor(.red)
                    Spacer()
                    if let totalCount = vm.poll?.totalCount {
                        Text(String(totalCount))
                            .foregroundColor(.red)
                    }
                }
            }
            .listRowBackground(Color.black)
            
            if let options = vm.poll?.options {
                Section {
                    PollChartView(options: options)
                        .frame(height: 200)
                        .padding(.vertical)
                }
                .listRowBackground(Color.black)
                
                Section {
                    ForEach(vm.poll?.options ?? []) { option in
                        Button(action: {
                            vm.incrementOption(option)
                        }, label: {
                            HStack {
                                Text("+1")
                                    .foregroundColor(.red)
                                Text(option.name)
                                    .foregroundColor(.red)
                                Spacer()
                                Text(String(option.count))
                                    .foregroundColor(.red)
                            }
                        })
                    }
                } header: {
                    Text("Vote")
                        .foregroundColor(.red)
                }
                .listRowBackground(Color.black)
            }
        }
        .navigationTitle(vm.poll?.name ?? "")
        .toolbarColorScheme(.dark, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(vm.poll?.name ?? "")
                    .foregroundColor(.red)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.black)
        .tint(.red)
        .listStyle(.insetGrouped)
        .onAppear {
            vm.listenToPoll()
        }
    }
}

#Preview {
    NavigationStack {
        PollView(vm: .init(pollId: "44C0E46F-89A9-4DEB-A9A5-F6C55978A71F"))
    }
}
