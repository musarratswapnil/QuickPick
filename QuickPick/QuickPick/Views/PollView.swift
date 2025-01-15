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
                    Text(vm.pollId)
                        .font(.caption)
                        .textSelection(.enabled)
                }
                
                HStack {
                    Text("Updated at")
                    Spacer()
                    if let updatedAt = vm.poll?.updatedAt {
                        Text(updatedAt, style: .time)
                    }
                }
                
                HStack {
                    Text("Total Vote Count")
                    Spacer()
                    if let totalCount = vm.poll?.totalCount {
                        Text(String(totalCount))
                    }
                }
            }
            
            if let options = vm.poll?.options {
                Section {
                    PollChartView(options: options)
                        .frame(height: 200)
                        .padding(.vertical)
                }
                
                Section("Vote") {
                    ForEach(vm.poll?.options ?? []) { option in
                        Button(action: {
                            vm.incrementOption(option)
                        }, label: {
                            HStack {
                                Text("+1")
                                Text(option.name)
                                Spacer()
                                Text(String(option.count))
                            }
                        })
                    }
                }

            }
        }
        .navigationTitle(vm.poll?.name ?? "")
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
