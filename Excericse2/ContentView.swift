//
//  ContentView.swift
//  Excericse2
//
//  Created by emre on 12.09.26.
//

import SwiftUI

struct ContentView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    enum Field: Hashable {
            case email
            case password
        }
    @FocusState private var focusedField: Field?
    @State private var showEmptyError = false
    @State private var showProgressView = false
    @State private var showLoginError = false
    @State private var showLoginSucc = false
    
    var body: some View {
        // In portrait mode the keyboard takes up a large amount of space when clicking on a textfield
        VStack(alignment: .leading, spacing: 8) {
            Text("Email")
                .font(.system(size: 17))
                .foregroundColor(.black)
            

                TextField("yourname@example.com", text: $email)
                    .padding(.horizontal, 12)
                    .frame(height: 44)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                .keyboardType(.emailAddress)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .padding(.bottom, 16)
                .focused($focusedField, equals: .email)
                .submitLabel(.next)
            
            Text("Password")
                .font(.system(size: 17))
                .foregroundColor(.black)
            

                SecureField("Your password", text: $password)
                    .padding(.horizontal, 12)
                    .frame(height: 44)
                    .focused($focusedField, equals: .password)
                    .submitLabel(.go)
            
                .padding(.horizontal, 12)
                .frame(height: 44)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
                .padding(.bottom, 24)
            
            Button(action: {
                // Handle login action
                loginAction()
            }) {
                Text("Login")
                    .font(.system(size: 22))
                    .foregroundColor(Color(red: 0.0, green: 0.48, blue: 1.0))
                    .frame(maxWidth: .infinity)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .onSubmit {
            switch focusedField {
            case .email:
                focusedField = .password
            case .password:
                loginAction()
            case nil:
                break
            }
        }
        .overlay{
            if showProgressView{
                ZStack {
                                    Color.black.opacity(0.4)
                                        .ignoresSafeArea()
                                    
                                    ProgressView("Please wait...")
                                        .padding()
                                        .background(.ultraThinMaterial)
                                        .cornerRadius(10)
                                }
            }

        }
        .disabled(showProgressView)
        .alert("Login error", isPresented: $showEmptyError){
            Button("Ok", role: .close){
                showEmptyError = false
            }
        } message:{
            Text("Email and password is required!")
        }
        .alert("Login error", isPresented: $showLoginError){
            Button("Ok", role: .close){
                showLoginError = false
            }
        } message:{
            Text("Credentials are wrong")
        }
        .alert("Login success", isPresented: $showLoginSucc){
            Button("Ok", role: .confirm){
                showLoginSucc = false
            }
        } message:{
            Text("Login works")
        }
    }
    
    func loginAction() {
        print("Login tapped with email: \(email)")
        guard !email.isEmpty && !password.isEmpty else {
            showEmptyError = true
            return
        }
        
        showProgressView = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        // This code executes after 2 seconds
        // Check here if the login was successful
            guard email == "test@test.com" && password == "test" else {
                showLoginError = true
                showProgressView = false
                return
            }
            showLoginSucc = true
            showProgressView = false
            
        }
    }
}

#Preview {
    ContentView()
}
