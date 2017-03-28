//
//  FeedViewModel.swift
//  Instagram
//
//  Created by Guilherme Souza on 3/27/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import RxSwift

class FeedViewModel {
    
    fileprivate let postService: PostServiceProtocol
    
    var posts = Variable<[Post]>([])
    
    init(postService: PostServiceProtocol) {
        self.postService = postService
    }
    
    func fetchPosts() {
        postService.fetchPosts { posts in
            if let posts = posts {
                self.posts.value = posts
            }
        }
    }
    
}
