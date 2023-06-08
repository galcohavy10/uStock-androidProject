//
//  SignUpView.swift
//  uStockIOS-V2-AI
//
//  Created by Gal Cohavy on 3/20/23.
//

import SwiftUI
import Foundation

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var username: String = ""
    @State private var dob: Date = Date()
    @State private var alertMessage: String = ""
    @State private var showingAlert: Bool = false
    @StateObject private var signUpViewModel = SignUpViewModel()
    @EnvironmentObject var userPreferences: UserPreferences
    @EnvironmentObject var loadingState: LoadingState
    @State private var shouldScrollToBottom = false
    
    //for phone # and email selector
    @State private var rawPhoneNumber: String = ""

    var phoneNumber: String {
        get {
            selectedCountryCode + rawPhoneNumber
        }
        set {
            // Only update the rawPhoneNumber part, preserving the country code
            rawPhoneNumber = String(newValue.dropFirst(selectedCountryCode.count))
        }
    }

    
    enum PreferredContactMethod {
        case phoneNumber
        case email
    }

    
    @State private var preferredContactMethod = PreferredContactMethod.phoneNumber
    @State private var selectedCountryCode = "+1"
    let countryCodes = ["+1", "+44", "+91", "+234", "+61", "+880", "+63", "+92", "+20", "+49", "+229", "+593", "+212", "+358", "+33", "+504", "+62", "+964", "+353", "+972", "+39", "+81", "+82", "+60", "+254", "+95", "+98", "+31", "+47", "+966", "+94", "+255", "+66", "+90", "+84", "+56", "+260", "+263", "+965", "+213", "+51", "+7", "+48", "+351", "+91", "+64", "+27", "+65", "+886", "+357", "+34", "+81"]
    let countryData = ["🇺🇸 +1", "🇬🇧 +44", "🇮🇳 +91", "🇳🇬 +234", "🇦🇺 +61", "🇧🇩 +880", "🇵🇭 +63", "🇵🇰 +92", "🇪🇬 +20", "🇩🇪 +49", "🇧🇯 +229", "🇪🇨 +593", "🇲🇦 +212", "🇫🇮 +358", "🇫🇷 +33", "🇭🇳 +504", "🇮🇩 +62", "🇮🇶 +964", "🇮🇪 +353", "🇮🇱 +972", "🇮🇹 +39", "🇯🇵 +81", "🇰🇷 +82", "🇲🇾 +60", "🇰🇪 +254", "🇲🇲 +95", "🇮🇷 +98", "🇳🇱 +31", "🇳🇴 +47", "🇸🇦 +966", "🇱🇰 +94", "🇹🇿 +255", "🇹🇭 +66", "🇹🇷 +90", "🇻🇳 +84", "🇨🇱 +56", "🇿🇲 +260", "🇿🇼 +263", "🇰🇼 +965", "🇩🇿 +213", "🇵🇪 +51", "🇷🇺 +7", "🇵🇱 +48", "🇵🇹 +351", "🇮🇳 +91", "🇳🇿 +64", "🇿🇦 +27", "🇸🇬 +65", "🇹🇼 +886", "🇨🇾 +357", "🇪🇸 +34", "🇯🇵 +81"]



    
    let api = API()
    
    @State private var currentStep: Int = 1
    
    var body: some View {
        ZStack {
            Color(.systemGray6).edgesIgnoringSafeArea(.bottom)
            
            ScrollViewReader { proxy in
                ScrollView {
                    VStack {
                        if currentStep == 1 {
                            VStack {
                                step1View
                                // Add a dummy view at the bottom that we can scroll to
                                Color.clear.frame(height: 1).id("bottom")
                            }
                            
                            .onChange(of: lastName) { _ in
                                shouldScrollToBottom = true
                            }
                            
                            .onChange(of: email) { _ in
                                shouldScrollToBottom = true
                            }
                            
                            .onChange(of: phoneNumber) { _ in
                                shouldScrollToBottom = true
                            }
                            
                        } else if currentStep == 2 {
                            VStack {
                                step2View
                                // Add a dummy view at the bottom that we can scroll to
                                Color.clear.frame(height: 1).id("bottom")
                            }
                            
                            .onChange(of: dob) { _ in
                                shouldScrollToBottom = true
                            }
                            
                            .onChange(of: password) { _ in
                                shouldScrollToBottom = true
                            }
                            .onChange(of: confirmPassword) { _ in
                                shouldScrollToBottom = true
                            }
                        }
                    }
                    .onChange(of: shouldScrollToBottom) { newValue in
                        if newValue {
                            withAnimation {
                                proxy.scrollTo("bottom", anchor: .bottom)
                            }
                            shouldScrollToBottom = false
                        }
                    }
                }
            }

            .padding()
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            
            if self.loadingState.isLoading {
                Color.black.opacity(0.5).ignoresSafeArea(.all)
                ProgressView()
            }
        }
    }
    
    @Environment(\.presentationMode) var presentationMode //to go back to authview from step 1

    
    var step1View: some View {
        VStack {
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 15)
                            .foregroundColor(.black) // Change the color
                    }
                }
                .padding(.leading)
                Spacer()
            }
            
            Text ("Ready to invest in yourself?")
                .bold()
                .font(.title)
            TextField("First Name", text: $firstName, onCommit: {
                UIApplication.shared.endEditing()
            })
                .padding()
                .autocapitalization(.words)
                .disableAutocorrection(true)
                .textContentType(.givenName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .toolbar {
                    // Toolbar item to dismiss the keyboard
                    ToolbarItem(placement: .keyboard) {
                        Button(action: {
                            // Dismiss the keyboard
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }) {
                            Text("Done")
                        }
                    }
                }

            
            TextField("Last Name", text: $lastName, onCommit: {
                UIApplication.shared.endEditing()
            })
                .padding()
                .autocapitalization(.words)
                .disableAutocorrection(true)
                .textContentType(.familyName)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            HStack {
                Picker("Preferred Contact Method", selection: $preferredContactMethod) {
                    Text("Phone Number").tag(PreferredContactMethod.phoneNumber)
                    Text("Email").tag(PreferredContactMethod.email)
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            if preferredContactMethod == .phoneNumber {
                VStack{
                    HStack {
                        Picker(selection: $selectedCountryCode, label: Text("Country Code")) {
                            ForEach(countryData, id: \.self) { country in
                                Text(country)
                            }
                        }
                        .frame(width: 100)
                        .clipped()

                        TextField("Phone Number", text: $rawPhoneNumber)
                            .keyboardType(.numberPad)
                    }
                    .padding()
                }

                  .textFieldStyle(RoundedBorderTextFieldStyle())
              } else {
                  VStack{
                      TextField("Email", text: $email)
                          .padding()
                          .autocapitalization(.none)
                          .disableAutocorrection(true)
                          .textContentType(.emailAddress)
                          .textFieldStyle(RoundedBorderTextFieldStyle())
                  }

                    }


            
            Button(action: {
                currentStep = 2
            }) {
                Text("Next")
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color.green)
            .cornerRadius(20)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    var step2View: some View {
        VStack {
            HStack {
                Button(action: {
                    currentStep = 1
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 15)
                            .foregroundColor(.black) // Change the color
                    }
                }
                .padding(.leading)
                Spacer()
            }
            
            Text (firstName + ", we're glad you're joining (⁎˃ᴗ˂⁎)")
                .bold()
                .font(.title3)
            
            TextField("Username", text: $username, onCommit: {
                UIApplication.shared.endEditing()
            })
                .padding()
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .toolbar {
                    // Toolbar item to dismiss the keyboard
                    ToolbarItem(placement: .keyboard) {
                        Button(action: {
                            // Dismiss the keyboard
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }) {
                            Text("Done")
                        }
                    }
                }
            
            Text("Date of Birth")
                .font(.body)
            DatePicker("Date of Birth", selection: $dob, displayedComponents: .date)
                .datePickerStyle(DefaultDatePickerStyle())
                .labelsHidden()
                .padding()
                .textContentType(.dateTime)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            


            
            SecureField("Password", text: $password, onCommit: {
                UIApplication.shared.endEditing()
            })
                .padding()
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .textContentType(.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())


            SecureField("Confirm Password", text: $confirmPassword, onCommit: {
                UIApplication.shared.endEditing()
            })
            .padding()
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .textContentType(.password)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if password != confirmPassword {
                Text("Passwords don't quite match yet (ಥ_ಥ)")
                    .foregroundColor(.black)
                    .padding(.bottom)
            }

            Button(action: {
                if password == confirmPassword {
                    self.loadingState.isLoading = true
                    signUpViewModel.signUpUser(email: email, password: password, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, username: username, dob: dob) { success in
                        if success {
                            print("Calling getUserID")
                            api.getUserID(username: username) { result in
                                switch result {
                                case .success(let userID):
                                    print("User ID is being sent to frontend: \(userID)")
                                    do {
                                        if let jsonData = userID.data(using: .utf8),
                                           let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: String],
                                           let id = json["userID"] {
                                            print ("decoded ID is \(id)")
                                            UserPreferences.shared.userID = id
                                            
                                            //only create wallet if user has been made successfully
                                            api.createWallet(userID: UserPreferences.shared.userID ?? "nothing") { result in
                                                switch result {
                                                case .success(let wallet):
                                                    print("wallet is \(wallet)")
                                                    UserPreferences.shared.walletID = wallet.id
                                                    DispatchQueue.main.async {
                                                        userPreferences.isLoggedIn = true
                                                        self.loadingState.isLoading = false
                                                    }
                                                case .failure(let error):
                                                    print("Error: \(error.localizedDescription)")
                                                    DispatchQueue.main.async {
                                                        self.loadingState.isLoading = false
                                                    }
                                                }
                                            }
                                        } else {
                                            print("Error: could not extract userID from JSON")
                                            DispatchQueue.main.async {
                                                self.loadingState.isLoading = false
                                            }
                                        }
                                    } catch {
                                        print("Error: \(error)")
                                        DispatchQueue.main.async {
                                            self.loadingState.isLoading = false
                                        }
                                    }
                                case .failure(let error):
                                    print("Error: \(error.localizedDescription)")
                                    DispatchQueue.main.async {
                                        self.loadingState.isLoading = false
                                    }
                                }
                            }
                        } else if let errorMessage = signUpViewModel.errorMessage {
                            DispatchQueue.main.async {
                                alertMessage = errorMessage
                                showingAlert = true
                                self.loadingState.isLoading = false
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        alertMessage = "Error: Passwords don't match"
                        showingAlert = true
                    }
                }
            }) {
                Text("Sign Up")
                    .foregroundColor(.white)
            }

            .padding()
            .background(Color.green)
            .cornerRadius(20)
        }
        .navigationBarBackButtonHidden(true)
    }
}

