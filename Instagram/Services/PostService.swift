//
//  PostService.swift
//  Instagram
//
//  Created by Guilherme Souza on 3/27/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation

protocol PostServiceProtocol {
    func fetchPosts(completion: @escaping ([Post]?) -> Void)
}

struct PostService: PostServiceProtocol {
    func fetchPosts(completion: @escaping ([Post]?) -> Void) {
        Router.posts.reference.observe(.value, with: { snapshot in
            if let value = snapshot.value as? [[String: Any]] {
                let posts = value.map(Post.init)
                completion(posts)
            } else {
                completion(nil)
            }
        })
    }
}
