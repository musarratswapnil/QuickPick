import SwiftUI
import FirebaseCore
import FirebaseAuth

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    @State private var confirmPassword = ""
    @State private var isLoggedIn = false
    @State private var isSignUp = false

    var body: some View {
        NavigationView {
            VStack {
                if isLoggedIn {
                    HomeView(
                        isLoggedIn: $isLoggedIn,
                        email: $email,
                        password: $password
                    )
                } else {
                    if isSignUp {
                        SignUpView(
                            email: $email,
                            username: $username,
                            password: $password,
                            confirmPassword: $confirmPassword,
                            isSignUp: $isSignUp,
                            isLoggedIn: $isLoggedIn
                        )
                    } else {
                        LoginView(
                            email: $email,
                            password: $password,
                            isSignUp: $isSignUp,
                            isLoggedIn: $isLoggedIn
                        )
                    }
                }
            }
            .onAppear {
                do {
                    try Auth.auth().signOut()
                    isLoggedIn = false
                } catch {
                    print("Failed to log out: \(error.localizedDescription)")
                }
            }

            .navigationBarHidden(true)
        }
    }
}





struct WelcomeView: View {
    @Binding var isLoggedIn: Bool
    @Binding var email: String
    @Binding var password: String
    @Binding var username: String
    @Binding var confirmPassword: String

    var body: some View {
        VStack {
            Text("Welcome!")
                .foregroundColor(.white)
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .padding()

            Text("You are successfully logged in.")
                .foregroundColor(.white)
                .padding()

            Button("Logout") {
                do {
                    try Auth.auth().signOut()
                    isLoggedIn = false
                    resetFields()
                } catch let error {
                    print("Failed to log out: \(error.localizedDescription)")
                }
            }
            .foregroundColor(.white)
            .frame(width: 200, height: 40)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [.pink, .red]),
                        startPoint: .top,
                        endPoint: .bottomTrailing
                    ))
            )
            .padding(.top)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.pink, .red]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .ignoresSafeArea()
    }

    func resetFields() {
        email = ""
        password = ""
        username = ""
        confirmPassword = ""
    }
}


struct BackgroundView: View {
    var body: some View {
        Color.black
            .ignoresSafeArea()

        RoundedRectangle(cornerRadius: 30, style: .continuous)
            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.pink, .red]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(width: 1000, height: 200)
            .rotationEffect(.degrees(135))
    }
}

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String

    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .foregroundColor(.white)

            // Optionally, you can add an icon or additional action here.
        }
        .padding(.horizontal)
        .frame(height: 40)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.white, lineWidth: 1)
        )
    }
}



struct CustomSecureField: View {
    let placeholder: String
    @Binding var text: String
    @State private var isSecure: Bool = true

    var body: some View {
        HStack {
            if isSecure {
                SecureField(placeholder, text: $text)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .foregroundColor(.white)
            } else {
                TextField(placeholder, text: $text)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .foregroundColor(.white)
            }

            Button(action: { isSecure.toggle() }) {
                Image(systemName: isSecure ? "eye.slash" : "eye")
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal)
        .frame(height: 40)
        .background(Color.clear)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.white, lineWidth: 1)
        )
    }
}




extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
