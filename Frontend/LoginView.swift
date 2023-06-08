import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showingAlert: Bool = false
    @State private var alertMessage: String = ""
    @StateObject private var logInViewModel = LogInViewModel()
    @EnvironmentObject var userPreferences: UserPreferences
    let api = API()
    @EnvironmentObject var loadingState: LoadingState





    var body: some View {
        ZStack {
            Color(.systemGray6).edgesIgnoringSafeArea(.bottom) // Move the background color here
            VStack {
                TextField("Username", text: $username)
                    .padding()
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                
                SecureField("Password", text: $password)
                    .padding()
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                
                Button(action: {
                    self.loadingState.isLoading = true
                    logInViewModel.logInUser(username: username, password: password) { success in
                        if success {
                            userPreferences.clearPreferences()
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

                                            //get the wallet if successful
                                            api.getWallet(userID: UserPreferences.shared.userID ?? "nothing") { result in
                                                switch result {
                                                case .success(let wallet):
                                                    print("wallet is \(wallet)")
                                                    UserPreferences.shared.walletID = wallet.id
                                                    DispatchQueue.main.async {
                                                        self.loadingState.isLoading = false
                                                        userPreferences.isLoggedIn = true
                                                    }
                                                case .failure(let error):
                                                    print("Error: \(error.localizedDescription)")
                                                    let errorMessage = logInViewModel.errorMessage
                                                    DispatchQueue.main.async {
                                                        alertMessage = errorMessage ?? "no error"
                                                        showingAlert = true
                                                    }
                                                }
                                            }
                                        } else {
                                            print("Error: could not extract userID from JSON")
                                        }
                                    } catch {
                                        print("Error: \(error)")
                                    }

                                case .failure(let error):
                                    print("Error: \(error.localizedDescription)")
                                    let errorMessage = logInViewModel.errorMessage
                                    DispatchQueue.main.async {
                                        alertMessage = errorMessage ?? "no error"
                                        showingAlert = true
                                        self.loadingState.isLoading = false
                                    }
                                }
                            }
                        } else if let errorMessage = logInViewModel.errorMessage {
                            DispatchQueue.main.async {
                                alertMessage = errorMessage
                                showingAlert = true
                                self.loadingState.isLoading = false
                            }
                        }
                    }
                })  {
                    Text("Login")
                        .foregroundColor(.white)
                }


                .padding()
                .background(Color.green)
                .cornerRadius(20)
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
}

