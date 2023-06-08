class SignUpViewModel: ObservableObject {
    @Published var errorMessage: String? = nil
    @Published var isSuccess: Bool = false
    
    func signUpUser(email: String, password: String, firstName: String, lastName: String, phoneNumber: String, username: String, dob: Date, completion: @escaping (Bool) -> Void) {
        let dobTimestamp = Int(dob.timeIntervalSince1970)
        let body = ["email": email, "password": password, "firstName": firstName, "lastName": lastName, "phoneNumber": phoneNumber, "username": username, "dob": dobTimestamp] as [String : Any]
        let api = API()
        api.makePostRequest(endpoint: "/api/signup", body: body) { result in
            switch result {
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    print("JSON: \(String(describing: json))") // Debug print statement
                    if let userID = json?["userID"] as? String {
                        print("User ID is: \(userID)")
                        DispatchQueue.main.async {
                            self.errorMessage = nil
                            self.isSuccess = true
                            completion(true)
                        }
                    } else if let error = json?["error"] as? String {
                        // Server returned an error message
                        DispatchQueue.main.async {
                            self.errorMessage = "Sign Up failed: \(error)"
                            self.isSuccess = false
                            completion(false)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.errorMessage = "Sign Up failed: unexpected response"
                            self.isSuccess = false
                            completion(false)
                        }
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.errorMessage = "Sign Up failed: \(error.localizedDescription)"
                        self.isSuccess = false
                        completion(false)
                    }
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self.errorMessage = "Sign Up failed: \(error.localizedDescription)"
                    self.isSuccess = false
                    completion(false)
                }
            }
        }
    }

}
