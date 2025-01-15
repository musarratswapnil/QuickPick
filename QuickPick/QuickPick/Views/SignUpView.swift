//
//  SignupView.swift
//  QuickPick
//
//  Created by Nahian Zarif on 15/1/25.
//

import Foundation

import SwiftUI

import FirebaseCore
import FirebaseAuth


struct SignUpView: View {
    @Binding var email: String
    @Binding var username: String
    @Binding var password: String
    @Binding var confirmPassword: String
    @Binding var isSignUp: Bool
    @Binding var isLoggedIn: Bool
    @State private var errorMessage: String?
    @State private var isLoading = false

    var body: some View {
        ZStack {
            BackgroundView()

            VStack(spacing: 20) {
                Text("Sign Up")
                    .foregroundColor(.white)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .padding(.bottom, 40)

                CustomTextField(placeholder: "Email", text: $email)

                CustomTextField(placeholder: "Username", text: $username)

                CustomSecureField(placeholder: "Password", text: $password)

                CustomSecureField(placeholder: "Confirm Password", text: $confirmPassword)

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.white)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding()
                }

                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding()
                } else {
                    Button(action: signUp) {
                        Text("Sign Up")
                            .bold()
                            .frame(width: 200, height: 40)
                            .background(RoundedRectangle(cornerRadius: 10).fill(LinearGradient(gradient: Gradient(colors: [.black, .pink]), startPoint: .top, endPoint: .bottomTrailing)))
                            .foregroundColor(.white)
                    }
                    .padding(.top)
                }

                Button(action: { isSignUp.toggle() }) {
                    Text("Already have an account? Login")
                        .bold()
                        .foregroundColor(.white)
                }
            }
            .frame(width: 350)
            .overlay(alignment: .topLeading) {
                Button(action: {
                    UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.white)
                    .padding(.top, 8)
                    .padding(.leading, 8)
                }
            }
        }
    }

    func signUp() {
        guard !email.isEmpty, !username.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }

        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters long."
            return
        }

        isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            isLoading = false

            if let error = error {
                errorMessage = error.localizedDescription
                return
            }

            isSignUp = false
        }
    }
}

