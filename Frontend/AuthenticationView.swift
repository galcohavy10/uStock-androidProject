//
//  AuthenticationView.swift
//  uStockIOS-V2-AI
//
//  Created by Gal Cohavy on 3/20/23.
//

import SwiftUI

struct AuthenticationView: View {

    @EnvironmentObject var userPreferences: UserPreferences
    @StateObject private var signUpViewModel = SignUpViewModel()

    var body: some View {
            NavigationView {
                ZStack {
                    Color.gray.opacity(0.1)
                VStack {
                    Spacer()
                    
                    HStack{
                        Image("logoNoBackground")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 100)
                        Text("uStock")
                            .font(.system(size: 40, weight: .bold, design: .monospaced))
                    }
                   


                    Text("   Invest in Yourself.")//spaces for formatting
                        .fontWeight(.thin)
                        .font(.title)
                    
                    

                    Spacer()
                    Spacer()
                    
                    NavigationLink(destination: SignUpView()) {
                        Text("Create Account")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .frame(width: 300, height: 70)
                            .background(Color.green.opacity(1))
                            .cornerRadius(25)
                    }

                    NavigationLink(destination: LoginView()) {
                        Text("Log In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 280, height: 40)
                            .background(Color.blue.opacity(0.8))
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 10)
                    

                    NavigationLink(destination: LearnMoreView()) {
                        Text("Learn More")
                            .foregroundColor(.blue)
                            .padding(.bottom, 10)
                    }
                    Spacer()
                }
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
            }
        }
 
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}


