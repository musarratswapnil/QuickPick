extension View {
    func withSheets(vm: HomeViewModel,
                   showReviews: Binding<Bool>,
                   showSettings: Binding<Bool>,
                   showCreatePoll: Binding<Bool>,
                   showAllPolls: Binding<Bool>,
                   showTrendingPolls: Binding<Bool>,
                   showLivePolls: Binding<Bool>,
                   coordinator: HomeViewCoordinator) -> some View {
        self
            .sheet(item: $vm.modalPollId) { id in
                NavigationStack {
                    PollView(vm: .init(pollId: id))
                }
            }
            .sheet(isPresented: showLivePolls) {
                LatestLivePollsView(vm: vm)
            }
            .sheet(isPresented: showReviews) {
                ReviewsView()
            }
            // ... other sheets ...
    }
    
    func withAlerts(vm: HomeViewModel,
                   showLogoutAlert: Binding<Bool>,
                   handleLogout: @escaping () -> Void) -> some View {
        self
            .alert("Logout", isPresented: showLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Logout", role: .destructive) {
                    handleLogout()
                }
            } message: {
                Text("Are you sure you want to logout?")
                    .withCustomStyle()
            }
            .alert("Error", isPresented: .constant(vm.error != nil)) {
            } message: {
                Text(vm.error ?? "an error occurred")
                    .withCustomStyle()
            }
    }
} 