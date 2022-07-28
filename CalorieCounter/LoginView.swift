//
//  LoginView.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/15/22.
//

import SwiftUI

struct LoginView: View {
    @Binding var authenticated: Bool
    @Binding var user: UserEntity?
    
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
            TextField("Password", text: $password)
            
            Text("Login")
                .padding()
                .background(.gray)
                .cornerRadius(10)
                .foregroundColor(.black)
                .onTapGesture {
                    login()
                }
        }
    }
    
    func login() {
//        verifyCredentials()
//        @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "username == %@ && password == %@", username, password)) var user: FetchedResults<User>
//        self.user = user.first
//        if (self.user != nil) {authenticated = true}
        authenticated = true
    }
    
    func verifyCredentials() { }
}

struct LoginView_PreviewHelper: View {
    @State private var value = false
    @State private var user: UserEntity? = nil
    
    var body: some View {
        LoginView(authenticated: $value, user: $user)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView_PreviewHelper()
    }
}
