//
//  AuthService.swift
//  Instagram
//
//  Created by Guilherme Souza on 3/23/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

enum AuthError: Error {
    case custom(String)
    case firebaseError(Error?)
}

protocol AuthServiceProtocol {
    func login(email: String, password: String, completion: @escaping (_ error: AuthError?) -> Void)
    func register(name: String, email: String, password: String, profileImageData: Data, completion: @escaping (_ error: AuthError?) -> Void)
    
    static func currentUserId() -> String!
    static func isUserLoggedIn() -> Bool
}

struct AuthService: AuthServiceProtocol {
    
    static fileprivate let currentUserIdKey = "currentUserIdKey"
    static fileprivate let isLoggedInKey = "isLoggedInKey"
    
    let auth: FIRAuth?
    let database: FIRDatabase
    let storage: FIRStorage
    
    init() {
        auth = FIRAuth.auth()
        database = FIRDatabase.database()
        storage = FIRStorage.storage()
    }

    static func currentUserId() -> String! {
        return UserDefaults.standard.string(forKey: currentUserIdKey)
    }
    
    static func isUserLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: AuthService.isLoggedInKey)
    }
    
    func login(email: String, password: String, completion: @escaping (_ error: AuthError?) -> Void) {
        auth?.signIn(withEmail: email, password: password) { user, error in
            guard error == nil else {
                completion(AuthError.firebaseError(error))
                return
            }
            
            guard let user = user else {
                completion(AuthError.custom("An unexpect error ocurred, please try again."))
                return
            }
            
            UserDefaults.standard.set(user.uid, forKey: AuthService.currentUserIdKey)
            UserDefaults.standard.set(true, forKey: AuthService.isLoggedInKey)
            completion(nil)
        }
    }
    
    func register(name: String, email: String, password: String, profileImageData: Data, completion: @escaping (_ error: AuthError?) -> Void) {
        auth?.createUser(withEmail: email, password: password) { user, error in
            guard error == nil else {
                completion(AuthError.firebaseError(error))
                return
            }
            
            // FIXME: Return a gereic error here.
            guard let user = user else {
                completion(AuthError.custom("An unexpect error ocurred, please try again."))
                return
            }
            
            let imageName = "profilePicture.jpg"
            
            // FIXME: Refactor uploading to a separate service.
            self.storage.reference()
                .child("users")
                .child(user.uid)
                .child(imageName)
                .put(profileImageData, metadata: nil) { metadata, error in
                    guard let url = metadata?.downloadURL() else {
                        return
                    }
                    
                    let values = ["profileImageURL": url.absoluteString]
                    
                    Router.user(id: user.uid).reference.updateChildValues(values)
            }
            
            let values = [
                "name": name,
                "email": email
            ]
            
            Router.user(id: user.uid).reference.updateChildValues(values)
            
            UserDefaults.standard.set(user.uid, forKey: AuthService.currentUserIdKey)
            UserDefaults.standard.set(true, forKey: AuthService.isLoggedInKey)
            completion(nil)
        }
    }
    
}
