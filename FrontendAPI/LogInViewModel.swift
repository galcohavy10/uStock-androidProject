// Making the requests to the server to log in the user and handle all other requests pertaining to logging in the user
import Foundation
import Combine

class LogInViewModel: ObservableObject {
    @Published var errorMessage: String? = nil
    @Published var isSuccess: Bool = false
    
    
    
    
    
    func logInUser(username: String, password: String, completion: @escaping (Bool) -> Void) {
        let body = ["username": username, "password": password] as [String : Any]
        let api = API()
        api.makePostRequest(endpoint: "/api/login", body: body) { result in
            switch result {
            case .success(let data):
                print ("RAW DATA = \(data)")
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
                    } else {
                        DispatchQueue.main.async {
                            self.errorMessage = "Login failed: unable to parse user ID"
                            self.isSuccess = false
                            completion(false)
                        }
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.errorMessage = "Login failed: \(error.localizedDescription)"
                        self.isSuccess = false
                        completion(false)
                    }
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self.errorMessage = "Login failed: \(error.localizedDescription)"
                    self.isSuccess = false
                    completion(false)
                }
            }
        }
    }

}
