//
//  LoginModel.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/15/22.
//

import Foundation

class LoginModel: ObservableObject {
    @Published var credentials = Credentials()
    @Published var error: Authentification.AuthentificationError?
    
    var disableLogin: Bool {
        credentials.username.isEmpty || credentials.password.isEmpty
    }
    
    
    func login(completion: @escaping (Bool) -> Void) {
        LoginService.shared.login(credentials: credentials) { [unowned self](result: Result<Bool, Authentification.AuthentificationError>) in
            switch result {
            case .success:
                completion(true)
            case.failure(let authError):
                credentials = Credentials()
                error = authError
                completion(false)
            }
        }
    }
    
    func resetPassword(withEmail email: String, completion: @escaping (Bool) -> Void) {
        LoginService.shared.resetPassword(email: email) { [unowned self](result: Result<Bool, Authentification.AuthentificationError>) in
            print("LOGIN MODEL: \(result)")
            switch result {
            case .success:
                completion(true)
            case .failure:
                error = .failedRecovery
                completion(false)
            }
        }
    }
    
    
}
