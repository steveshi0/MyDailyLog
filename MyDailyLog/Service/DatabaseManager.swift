//
//  EntryService.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/16/22.
//

import Foundation
import FirebaseFirestore

class DatabaseManager {
    static let shared = DatabaseManager()
    private let storage = Firestore.firestore()
    
    private init() {}
    
    func insertBlog(blogPost: BlogPost, user: User, completion: @escaping (Bool) -> Void) {
        
    }
    func deleteBlog(blogPost: BlogPost, user: User, completion: @escaping (Bool) -> Void) {
        
    }
    func getAllPost(completion: @escaping ([BlogPost]) -> Void) {
        
    }
    func getPost(forUser user: User, completion: @escaping (BlogPost) -> Void) {
        
    }
    func insertUser(user: User, completion: @escaping (Bool) -> Void) {
        
    }
}
