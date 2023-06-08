//
//  LearnMoreView.swift
//  uStockIOS-V2-AI
//
//  Created by Gal Cohavy on 3/20/23.
//

import SwiftUI
import UIKit

struct LearnMoreView: View {

    var body: some View {
        ZStack {
            Color.gray.opacity(0.1)
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {

                        Text("Hey (＾Д＾)ﾉ , want to learn more? ")
                            .font(.system(size: 30, weight: .bold, design: .serif))
                            .padding(.top, 20)
                        
                        Text("uStock improves your personal growth and connection. \n-Gain access to growth aspect communities\n-Use personalized community tools and the members around you to improve.\n-Improve your stock by achieving personal goals, winning competitions and helping your peers. \n\nFinally, the app made for YOU. Improving your stock means you've improved in ways YOU deem most important. So, sign up now. \n(ﾉ◕ヮ◕)ﾉ: Sign up!")
                            .font(.system(size: 20))
                            .lineSpacing(10)
                        
                        Spacer ()
                        
                        Text("How does it work❓")
                            .font(.system(size: 30, weight: .medium, design: .rounded))
                        
                        Button(action: {
                            if let url = URL(string: "https://vimeo.com/830038059?share=copy") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("Watch Video")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 280, height: 50)
                                .background(LinearGradient(gradient: Gradient(colors: [.red, .orange]), startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            if let url = URL(string: "https://www.getustock.com/About") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("Read Docs")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 280, height: 50)
                                .background(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(10)
                        }
                        
                        Spacer()
                        
                        
                        Text("Invest in Yourself ✧")
                            .font(.system(size: 30, weight: .medium, design: .default))
                        
                        NavigationLink(destination: SignUpView()) {
                            Text("Create Account")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                                .frame(width: 250, height: 70)
                                .background(Color.green.opacity(1))
                                .cornerRadius(25)
                        }
                        
                    }
                    .padding()
                }
            }
        }
    }



struct LearnMoreView_Previews: PreviewProvider {
    static var previews: some View {
        LearnMoreView()
    }
}
