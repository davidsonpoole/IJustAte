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
            SecureField("Password", text: $password)
            
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
    
    // Not reachable: ContentView hardcodes authenticated = true.
    //
    // If this is ever built out, credentials must not be stored in Core Data.
    // UserEntity previously carried a plaintext `password` attribute, and the
    // implementation sketched here matched on it with a fetch predicate, which
    // would have put passwords in an unencrypted SQLite file inside the shared
    // app group. Verify against the server and keep nothing but a token, in
    // the Keychain.
    func login() {
        authenticated = true
    }
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
