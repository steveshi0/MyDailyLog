//
//  EntryService.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/16/22.
//

import SwiftUI
import Foundation
import FirebaseFirestore

class DatabaseManager {
    static let shared = DatabaseManager()
    private let db = Firestore.firestore()
    
    enum FireStoreError: String, Error, LocalizedError, Identifiable {
        case failedUpload = "Failed to upload data to Firebase FireStore"
        case failedRetrieval = "Failed to retrieve data from Firebase FireStore"
        
        var id: String {
            self.localizedDescription
        }
    }
    
    private init() {}
    
    // Insert the log info such as uuid, timestamp, body text, image caption within FireStore Database
    // and store the image in FireStorage since the file size would be too big. Ex: one image captured
    // with jpg compressed to 0.8 is roughly 1.95mb, could possibly make that smaller but would reduce quality
    func insertLog(log: Log, email: String, completion: @escaping (Bool) -> Void) {
        let replacedEmail = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        let data: [String: Any] = [
            "id": log.id,
            "timestamp": log.timeStamp,
            "headerImageCap": log.headerImageCap,
            "bodyText": log.bodyText,
            "imagePath": "images/\(replacedEmail)/\(log.id).jpg"
        ]
        db
            .collection("users")
            .document(replacedEmail)
            .collection("logs")
            .document(log.id)
            .setData(data) { err in // If there are no error with storing the log text info then attempt to store the image within Storage
                if err == nil {
                    StorageManager.shared.uploadLogHeaderImage(log: log, withEmail: replacedEmail) {(result: Result<Bool, StorageManager.StorageError>) in
                        switch result {
                        case .success:
                            completion(true)
                        case .failure(let iError):
                            print(iError.rawValue)
                            completion(false)
                        }
                    }
                } else {
                    completion(false)
                }
            }
    }
    
    func getLogs(withEmail email: String, completion: @escaping ([Log]) -> Void) {
        var retrievedLogs: [Log] = []
        let replacedEmail = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        db
            .collection("users")
            .document(replacedEmail)
            .collection("logs")
            .getDocuments { querySnapshot, err in
                if let _ = err {
                    print("Error getting the documents")
                    completion([])
                } else {
                    for document in querySnapshot!.documents {
                        if document.documentID != "userMetaData" {
                            let data = document.data()
                            let imagePath = data["imagePath"] as? String
                            StorageManager.shared.getLogHeaderImage(withPath: imagePath!) { (result: Result<UIImage, StorageManager.StorageError>) in
                                switch result {
                                case .success(let iImage):
                                    guard let id = data["id"] as? String,
                                          let timeStamp = data["timestamp"] as? TimeInterval,
                                          let headerImageCap = data["headerImageCap"] as? String,
                                          let bodyText = data["bodyText"] as? String else {
                                        return
                                    }
                                    let retrievedLog = Log(id: id, timeStamp: timeStamp, headerImageUrl: iImage.jpegData(compressionQuality: 0.8)! , headerImageCap: headerImageCap, bodyText: bodyText)
                                    print(retrievedLog.bodyText)
                                    retrievedLogs.append(retrievedLog)
                                case .failure:
                                    print("Failed to retrived an image")
                                }
                            }
                        }
                    }
                    completion(retrievedLogs)
                }
            }
    }
    
    // Insert an order within the path users/userEmail/logPost/userMetaData, each logPost collection will have one distinct userMetaData doc
    func insertUser(user: User, completion: @escaping (Result<Bool, FireStoreError>) -> Void) {
        let replacedEmail = user.userEmail
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        db
            .collection("users")
            .document(replacedEmail)
            .collection("logs")
            .document("userMetaData")
            .setData(["userName": user.userName, "userEmail": user.userEmail]) { err in // TODO: Figure out why using the user model won't work
                if err != nil {
                    completion(.failure(.failedUpload))
                } else {
                    completion(.success(true))
                }
            }
    }
    
    // Deleting the user by simply deleting the email field thus deleting all information in the subcollection logPosts
    func deleteUser(user: User, completion: @escaping (Result<Bool, FireStoreError>) -> Void) {
        let replacedEmail = user.userEmail
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        db.collection("users")
            .document(replacedEmail)
            .delete() { err in
                if err != nil {
                    completion(.failure(.failedUpload))
                } else {
                    completion(.success(true))
                }
            }
    }
    
    func getUser(withEmail email: String, completion: @escaping (String) -> Void) {
        let replacedEmail = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        db.collection("users")
            .document(replacedEmail)
            .collection("logs")
            .document("userMetaData")
            .getDocument { snapshot, err in
                if let data = snapshot?.data() {
                    let name = data["userName"]
                    completion(name as! String)
                } else {
                    completion("John Smith")
                }
            }
    }
}

