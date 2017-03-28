//
//  Router.swift
//  Instagram
//
//  Created by Guilherme Souza on 3/27/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import FirebaseDatabase

enum Router {
    static fileprivate let baseRef = FIRDatabase.database().reference()
    
    case myProfile
    case users
    case user(id: String)
    case posts
    case post(id: String)
    
    var reference: FIRDatabaseReference {
        switch self {
        case .myProfile:
            return Router.user(id: AuthService.currentUserId()).reference
        case .users:
            return Router.baseRef.child("users")
        case .user(let id):
            return Router.users.reference.child(id)
        case .posts:
            return Router.baseRef.child("posts")
        case .post(let id):
            return Router.posts.reference.child(id)
        }
    }
}
