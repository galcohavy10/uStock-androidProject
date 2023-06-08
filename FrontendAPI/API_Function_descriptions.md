# API_Function_descriptions.md

Let's talk about a couple of important functions you'll be working with in the app. They are key for letting users log in and sign up. Let's dive into it.

## 1. LogInViewModel

The LogInViewModel is a class that manages user login. It primarily contains a method named logInUser() which is responsible for making requests to the server to log in the user. Here's a breakdown of its functionality:

- It first creates a `body` dictionary with the username and password.
- Then it calls the `makePostRequest()` function of an `API()` instance, hitting the "/api/login" endpoint.
- If the server responds with success, it attempts to parse the `userID` from the returned JSON.
- If it can get a `userID`, it sets `errorMessage` to `nil`, `isSuccess` to `true`, and calls the completion block with `true`.
- If there's a problem, it sets an error message, `isSuccess` to `false`, and calls the completion block with `false`.

Take a look:
func logInUser(username: String, password: String, completion: @escaping (Bool) -> Void) {
    // Body of the request
    let body = ["username": username, "password": password] as [String : Any]
    
    // API instance
    let api = API()
    
    // Making a POST request to "/api/login"
    api.makePostRequest(endpoint: "/api/login", body: body) { result in
        // Handling the result
        switch result {
        // In case of success
        case .success(let data):
            // Processing the received data
            ...
        // In case of failure
        case .failure(let error):
            ...
        }
    }
}


## 2. SignUpViewModel

The SignUpViewModel is another class that manages user registration. It includes a signUpUser() function for making requests to the server to sign up the user. Here's a breakdown of how it works:

- It first converts the user's date of birth (`dob`) to a timestamp.
- Then it creates a `body` dictionary with all the user details.
- It calls `makePostRequest()` on an `API()` instance, this time hitting the "/api/signup" endpoint.
- If the server responds with success, it attempts to parse the `userID` from the JSON response.
- If it gets a `userID`, it sets `errorMessage` to `nil`, `isSuccess` to `true`, and calls the completion block with `true`.
- If the server returns an error message, it sets `errorMessage` to the server's error message, `isSuccess` to `false`, and calls the completion block with `false`.
- If something else weird happens, it sets `errorMessage` to a generic message, `isSuccess` to `false`, and calls the completion block with `false`.

How it's done: 

func signUpUser(email: String, password: String, firstName: String, lastName: String, phoneNumber: String, username: String, dob: Date, completion: @escaping (Bool) -> Void) {
    // Converting DOB to timestamp and preparing the request body
    let dobTimestamp = Int(dob.timeIntervalSince1970)
    let body = ["email": email, "password": password, "firstName": firstName, "lastName": lastName, "phoneNumber": phoneNumber, "username": username, "dob": dobTimestamp] as [String : Any]
    
    // API instance
    let api = API()
    
    // Making a POST request to "/api/signup"
    api.makePostRequest(endpoint: "/api/signup", body: body) { result in
        // Handling the result
        switch result {
        // In case of success
        case .success(let data):
            // Processing the received data
            ...
        // In case of failure
        case .failure(let error):
            ...
        }
    }
}


You're gonna need to recreate this same kind of logic in Kotlin. Take some time to understand it and see how you can adapt it to your Android code.

Best of luck, and happy coding!
