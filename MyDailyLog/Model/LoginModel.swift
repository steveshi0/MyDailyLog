//
//  LoginModel.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/15/22.
//

import Foundation

class LoginModel: ObservableObject {
    @Published var error: Authentification.AuthentificationError?
    
    func login(withEmail userEmail: String, withPassword userPassword: String, completion: @escaping (Bool) -> Void) {
        LoginManager.shared.login(withEmail: userEmail, withPassword: userPassword) { [unowned self](result: Result<Bool, Authentification.AuthentificationError>) in
            switch result {
            case .success:
                completion(true)
            case.failure(let iError):
                error = iError
                completion(false)
            }
        }
    }
    
    func resetPassword(withEmail userEmail: String, completion: @escaping (Bool) -> Void) {
        LoginManager.shared.resetPassword(withEmail: userEmail) { [unowned self](result: Result<Bool, Authentification.AuthentificationError>) in
            switch result {
            case .success:
                completion(true)
            case .failure(let iError):
                error = iError
                completion(false)
            }
        }
    }
    
    func signup(withEmail userEmail: String, withPassword userPassword: String, completion: @escaping (Bool) -> Void) {
        LoginManager.shared.signUp(withEmail: userEmail, withPassword: userPassword) { [unowned self](result: Result<Bool, Authentification.AuthentificationError>) in
            switch result {
            case .success:
                completion(true)
            case .failure(let iError):
                error = iError
                completion(false)
            }
        }
    }
}