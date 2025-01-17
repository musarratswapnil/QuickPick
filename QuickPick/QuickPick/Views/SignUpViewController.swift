//
//  SignUpViewController.swift
//  QuickPick
//
//  Created by Nahian Zarif on 30/12/24.
//

import SwiftUI
import FirebaseAuth

struct SignUpViewController: View {
    @Binding var isLoggedIn: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    @State private var isLoading = false
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    Text("Create Account")
                        .font(.largeTitle)
                        .bold()
                        .padding(.vertical, 30)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .foregroundColor(.gray)
                        TextField("Enter your email", text: $email)
                            .whitePlaceholder()
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .foregroundColor(.gray)
                        HStack {
                            if showPassword {
                                TextField("Enter your password", text: $password)
                                    .whitePlaceholder()
                            } else {
                                SecureField("Enter your password", text: $password)
                                    .whitePlaceholder()
                            }
                            Button(action: { showPassword.toggle() }) {
                                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.white)
                            }
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        if !password.isEmpty {
                            PasswordStrengthView(password: password)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Confirm Password")
                            .foregroundColor(.gray)
                        HStack {
                            if showConfirmPassword {
                                TextField("Confirm your password", text: $confirmPassword)
                                    .whitePlaceholder()
                            } else {
                                SecureField("Confirm your password", text: $confirmPassword)
                                    .whitePlaceholder()
                            }
                            Button(action: { showConfirmPassword.toggle() }) {
                                Image(systemName: showConfirmPassword ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.white)
                            }
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        if !confirmPassword.isEmpty {
                            if password == confirmPassword {
                                Text("Passwords match")
                                    .foregroundColor(.green)
                                    .font(.caption)
                            } else {
                                Text("Passwords don't match")
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                        }
                    }
                    
                    Button(action: handleSignUp) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Sign Up")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                        }
                    }
                    .background(isValidInput ? Color.blue : Color.gray)
                    .cornerRadius(10)
                    .disabled(isLoading || !isValidInput)
                    .padding(.top, 20)
                }
                .padding()
            }
            .alert(alertTitle, isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private var isValidInput: Bool {
        !email.isEmpty && 
        !password.isEmpty && 
        !confirmPassword.isEmpty && 
        password == confirmPassword &&
        password.count >= 6 &&
        isValidEmail(email)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func handleSignUp() {
        guard isValidInput else {
            alertTitle = "Invalid Input"
            alertMessage = "Please check your input:\n" +
                (email.isEmpty ? "• Email is required\n" : "") +
                (!isValidEmail(email) ? "• Invalid email format\n" : "") +
                (password.isEmpty ? "• Password is required\n" : "") +
                (password.count < 6 ? "• Password must be at least 6 characters\n" : "") +
                (password != confirmPassword ? "• Passwords don't match" : "")
            showAlert = true
            return
        }
        
        isLoading = true
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            isLoading = false
            
            if let error = error {
                alertTitle = "Sign Up Failed"
                alertMessage = error.localizedDescription
                showAlert = true
            } else {
                isLoggedIn = true
            }
        }
    }
}

struct PasswordStrengthView: View {
    let password: String
    
    private var strength: (String, Color) {
        if password.count < 6 {
            return ("Weak", .red)
        } else if password.count < 10 {
            return ("Medium", .orange)
        } else {
            return ("Strong", .green)
        }
    }
    
    var body: some View {
        HStack(spacing: 10) {
            Text("Strength:")
                .font(.caption)
                .foregroundColor(.gray)
            Text(strength.0)
                .font(.caption)
                .foregroundColor(strength.1)
        }
    }
}
