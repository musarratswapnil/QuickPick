import Foundation
import SwiftUI
import FirebaseAuth
// If PollCard is in a different module, import it here

// Add this class to handle the delegate
class HomeViewCoordinator: TextSettingsDelegate {
    func didUpdateFontSize(_ size: Double) {
        UserDefaults.standard.set(size, forKey: "fontSize")
    }
    
    func didUpdateFontFamily(_ fontFamily: String) {
        UserDefaults.standard.set(fontFamily, forKey: "fontFamily")
    }
    
    func didUpdateTextColor(_ color: Color) {
        if let colorIndex = TextSettingsViewModel().availableColors.firstIndex(where: { $0.color == color }) {
            UserDefaults.standard.set(colorIndex, forKey: "textColor")
        }
    }
}

struct HomeView: View {
    @Bindable var vm = HomeViewModel()
    @State private var showReviews = false
    @State private var showSettings = false
    @State private var showLogoutAlert = false
    @State private var showLivePolls = false
    @State private var showCreatePoll = false
    @State private var showAllPolls = false
    @State private var showTrendingPolls = false
    @State private var showJoinPoll = false
    private let coordinator = HomeViewCoordinator()
    @Binding var isLoggedIn: Bool
    @Binding var email: String
    @Binding var password: String

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Join a Poll Card
                    PollCard(
                        title: "Join a Poll",
                        subtitle: "Participate in live polls",
                        backgroundColor: LinearGradient(colors: [Color.purple, Color.blue], startPoint: .topLeading, endPoint: .bottomTrailing),
                        iconName: "person.3.fill"
                    )
                    .onTapGesture {
                        showJoinPoll = true
                    }

                    // Latest Live Polls Card
                    PollCard(
                        title: "Latest Live Polls",
                        subtitle: "See the latest polls",
                        backgroundColor: LinearGradient(colors: [Color.orange, Color.pink], startPoint: .topLeading, endPoint: .bottomTrailing),
                        iconName: "chart.bar.xaxis"
                    )
                    .onTapGesture {
                        showLivePolls = true
                    }
                    .sheet(isPresented: $showLivePolls) {
                        LatestLivePollsView(vm: vm)
                    }

                    // Trending Polls Card
                    PollCard(
                        title: "Trending Polls",
                        subtitle: "Top 3 most voted polls",
                        backgroundColor: LinearGradient(colors: [Color.red, Color.orange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing),
                        iconName: "flame.fill"
                    )
                    .onTapGesture {
                        showTrendingPolls = true
                    }

                    // All Polls Card
                    PollCard(
                        title: "All Polls",
                        subtitle: "View all available polls",
                        backgroundColor: LinearGradient(colors: [Color.blue, Color.purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing),
                        iconName: "list.bullet.circle.fill"
                    )
                    .onTapGesture {
                        showAllPolls = true
                    }

                    // Create a Poll Card
                    PollCard(
                        title: "Create a Poll",
                        subtitle: "Make your own poll",
                        backgroundColor: LinearGradient(colors: [Color.green, Color.blue], startPoint: .topLeading, endPoint: .bottomTrailing),
                        iconName: "plus.circle.fill"
                    )
                    .onTapGesture {
                        showCreatePoll = true
                    }
                    
                    // Reviews Section
                    reviewsSection
                }
                .padding()
                .background(Color.black.edgesIgnoringSafeArea(.all))
            }
            .navigationTitle("QuickPick")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button(action: {
//                        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
//                    }) {
//                        HStack {
//                            Image(systemName: "chevron.left")
//                            Text("Back")
//                        }
//                        .foregroundColor(.red)
//                    }
//                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 16) {
                        Button(action: {
                            showSettings = true
                        }) {
                            Image(systemName: "gearshape.fill")
                                .foregroundColor(.red)
                        }
                        .accessibilityLabel("Settings")

                        Button(action: {
                            showReviews = true
                        }) {
                            Image(systemName: "star.circle")
                                .foregroundColor(.red)
                        }
                        .accessibilityLabel("Show Reviews")

                        Button(action: {
                            showLogoutAlert = true
                        }) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.red)
                        }
                        .accessibilityLabel("Logout")
                    }
                }
            }
            .alert("Logout", isPresented: $showLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Logout", role: .destructive) {
                    handleLogout()
                }
            } message: {
                Text("Are you sure you want to log out from QuickPick?")
                    .font(.body)
            }
            .alert("Error", isPresented: .constant(vm.error != nil)) {
                Button("OK", role: .cancel) { vm.error = nil }
            } message: {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Something went wrong")
                        .font(.headline)
                    Text(vm.error ?? "An unexpected error occurred. Please try again.")
                        .font(.body)
                }
            }
            .sheet(item: $vm.modalPollId) { id in
                NavigationStack {
                    PollView(vm: .init(pollId: id))
                }
            }
            .sheet(isPresented: $showReviews) {
                ReviewsView()
            }
            .sheet(isPresented: $showSettings) {
                TextSettingsView(delegate: coordinator)
            }
            .sheet(isPresented: $showCreatePoll) {
                CreatePollView()
            }
            .sheet(isPresented: $showAllPolls) {
                AllPollsView()
            }
            .sheet(isPresented: $showTrendingPolls) {
                TrendingPollsView()
            }
            .sheet(isPresented: $showJoinPoll) {
                JoinPollView()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func handleLogout() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
            email = ""
            password = ""
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }

    var reviewsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Reviews")
                .font(.title2)
                .bold()
                .foregroundColor(.white)

            Button("View Reviews") {
                showReviews = true
            }
            .withCustomStyle()
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
    }
}

extension View {
    func withCustomStyle() -> some View {
        modifier(CustomTextStyle())
    }
}

extension String: Identifiable {
    public var id: Self { self }
}

struct CustomTextStyle: ViewModifier {
    @AppStorage("fontSize") private var fontSize: Double = 16
    @AppStorage("fontFamily") private var fontFamily: String = "Helvetica"
    @AppStorage("textColor") private var colorIndex: Int = 0
    
    private let availableColors: [Color] = [.black, .blue, .red, .green]
    
    func body(content: Content) -> some View {
        content
            .font(.custom(fontFamily, size: fontSize))
            .foregroundColor(availableColors[colorIndex])
    }
}

#Preview {
    NavigationStack {
        HomeView(
            isLoggedIn: .constant(true),
            email: .constant(""),
            password: .constant("")
        )
    }
}
