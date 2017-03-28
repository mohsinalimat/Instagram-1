//
//  Post.swift
//  Instagram
//
//  Created by Guilherme Souza on 3/27/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation

struct Post {
    var id: String?
    var imageURL: String?
    var username: String?
    var profileImageURL: String?
}

extension Post: JSONDecodable {
    
    init(json: [String : Any]) {
        id = json["id"] as? String
        imageURL = json["imageURL"] as? String
        username = json["username"] as? String
        profileImageURL = json["profileImageURL"] as? String
    }
    
}
