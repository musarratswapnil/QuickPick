import SwiftUI
import FirebaseFirestore

struct JoinPollView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var vm: HomeViewModel
    @State private var pollId: String = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Text("Join a Poll")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                    
                    TextField("Enter Poll ID", text: $pollId)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .colorScheme(.dark)
                    
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
                    .background(pollId.isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .disabled(pollId.isEmpty || isLoading)
                    
                    Spacer()
                }
                .padding(.top, 30)
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
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
            
            vm.modalPollId = pollId
            dismiss()
        }
    }
}

#Preview {
    JoinPollView()
} 