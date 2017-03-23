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

protocol AuthServiceProtocol {
    func isUserLoggedIn() -> Bool
    func login(email: String, password: String, completion: @escaping (_ error: Error?) -> Void)
    func register(name: String, email: String, password: String, profileImageData: Data, completion: @escaping (_ error: Error?) -> Void)
}

struct AuthService: AuthServiceProtocol {
    
    let isLoggedInKey = "isLoggedInKey"
    let auth: FIRAuth?
    let database: FIRDatabase
    let storage: FIRStorage
    
    init() {
        auth = FIRAuth.auth()
        database = FIRDatabase.database()
        storage = FIRStorage.storage()
    }

    func isUserLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: isLoggedInKey)
    }
    
    func login(email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
        auth?.signIn(withEmail: email, password: password) { user, error in
            guard error == nil else {
                completion(error)
                return
            }
            
            UserDefaults.standard.set(true, forKey: self.isLoggedInKey)
        }
    }
    
    func register(name: String, email: String, password: String, profileImageData: Data, completion: @escaping (_ error: Error?) -> Void) {
        auth?.createUser(withEmail: email, password: password) { user, error in
            guard error == nil else {
                completion(error)
                return
            }
            
            // FIXME: Return a gereic error here.
            guard let user = user else {
                return
            }
            
            let imageName = UUID().uuidString + ".jpg"
            
            // FIXME: Refactor uploading to a separate service.
            self.storage.reference()
                .child("users")
                .child(user.uid)
                .child(imageName)
                .put(profileImageData, metadata: nil) { metadata, error in
                    guard let url = metadata?.downloadURL() else {
                        return
                    }
                    
                    let values = ["profilePictureURL": url.absoluteString]
                    
                    self.database.reference()
                        .child("users")
                        .child(user.uid)
                        .updateChildValues(values)
            }
            
            let values = [
                "name": name,
                "email": email
            ]
            
            // FIXME: Refactor database to a separate service.
            let database = FIRDatabase.database()
            database.reference()
                .child("users")
                .child(user.uid)
                .updateChildValues(values)
            
            UserDefaults.standard.set(true, forKey: self.isLoggedInKey)
            completion(nil)
        }
    }
    
}