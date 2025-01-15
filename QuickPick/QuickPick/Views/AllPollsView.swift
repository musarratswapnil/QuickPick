import SwiftUI

struct AllPollsView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var vm = HomeViewModel()
    @State private var selectedPollId: String? = nil
    
    var body: some View {
        NavigationView {
            List(vm.polls) { poll in
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(poll.name)
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Image(systemName: "chart.bar.xaxis")
                            .foregroundColor(.white)
                        Text("\(poll.totalCount) votes")
                            .foregroundColor(.white.opacity(0.8))
                        
                        if let updatedAt = poll.updatedAt {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.white)
                            Text(updatedAt, style: .relative)
                                .foregroundColor(.white.opacity(0.8))
                        }
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
                    vm.modalPollId = poll.id
                    dismiss()
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
    }
}

#Preview {
    AllPollsView()
} 