//
//  LoginView.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/14/22.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct LoginView: View {
    @StateObject private var loginM = LoginModel()
    @EnvironmentObject var authentification: Authentification
    @FocusState private var focusState: Bool
    @State private var loadingLogin: Bool = false
    
    let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.5), .purple.opacity(0.5)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea(.all)
            VStack(alignment: .center, spacing: 15) {
                Spacer()
                Text("My Daily Log")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                TextField("email adress or phone number", text: $loginM.credentials.username)
                    .padding()
                    .background(lightGreyColor)
                    .foregroundColor(.black)
                    .cornerRadius(5.0)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .foregroundColor(.primary)
                SecureField("Password", text: $loginM.credentials.password)
                    .padding()
                    .background(lightGreyColor)
                    .foregroundColor(.black)
                    .cornerRadius(5.0)
                    .focused($focusState)
                HStack {
                    Spacer()
                    Button(action: forgotPassword) {
                        Text("Forgot password?")
                    }
                }
                Button {
                    loadingLogin.toggle()
                    focusState.toggle()
                    loginM.login { result in
                        print("LoginView: \(result)")
                        authentification.updateValidation(result)
                    }
                    loadingLogin.toggle()
                } label: {
                    loadingView(loadingLogin)
                }
                .padding(.bottom, 10)
                labelledDivider(label: "or")
                Spacer()
                Spacer()
            }
            .padding()
        }
        .alert(item: $loginM.error) {error in
            Alert(title: Text("Invalid Login"),
                  message:Text(error.localizedDescription))
        }
    }
    func forgotPassword() { // Move to RecoveryView
        
    }
}

struct loadingView: View {
    var showLoading: Bool = false
    
    init(_ showLoading: Bool = false){
        self.showLoading = showLoading
    }
    var body: some View {
        if !showLoading {
            Text("Log In")
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 300, height: 60)
                .background(Color.blue)
                .cornerRadius(30.0)
        } else {
            ProgressView()
        }
    }
}

// An divider with text in the middle   -----??-----
struct labelledDivider: View {
    let label: String
    let horizontalPadding: CGFloat
    let color: Color
    
    init(label: String, horizontalPadding: CGFloat = 10, color: Color = .black) {
        self.label = label
        self.horizontalPadding = horizontalPadding
        self.color = color
    }
    var body: some View {
        HStack {
            line
            Text(label).foregroundColor(color)
            line
        }
    }
    var line: some View {
        VStack {
            Divider().background(color)
        }.padding(horizontalPadding)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
