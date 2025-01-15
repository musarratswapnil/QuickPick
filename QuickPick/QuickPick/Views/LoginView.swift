//
//  LoginView.swift
//  QuickPick
//
//  Created by Nahian Zarif on 15/1/25.
//

import Foundation

import SwiftUI

import FirebaseCore
import FirebaseAuth


struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var email: String
    @Binding var password: String
    @Binding var isSignUp: Bool
    @Binding var isLoggedIn: Bool
    @State private var errorMessage: String?
    @State private var isLoading = false

    var body: some View {
        ZStack {
            BackgroundView()

            VStack(spacing: 20) {
                Text("Login")
                    .foregroundColor(.white)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .padding(.bottom, 40)

                CustomTextField(placeholder: "Email", text: $email)

                CustomSecureField(placeholder: "Password", text: $password)

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
                    Button(action: login) {
                        Text("Login")
                            .bold()
                            .frame(width: 200, height: 40)
                            .background(RoundedRectangle(cornerRadius: 10).fill(LinearGradient(gradient: Gradient(colors: [.black, .pink]), startPoint: .top, endPoint: .bottomTrailing)))
                            .foregroundColor(.white)
                    }
                    .padding(.top)
                }

                Button(action: { isSignUp.toggle() }) {
                    Text("Don't have an account? Sign Up")
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

    func login() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }

        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            isLoading = false

            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                case .userNotFound:
                    errorMessage = "Email is not registered."
                case .wrongPassword:
                    errorMessage = "Incorrect password."
                case .invalidEmail:
                    errorMessage = "Invalid email address."
                default:
                    errorMessage = error.localizedDescription
                }
                return
            }

            isLoggedIn = true
        }
    }
}
