//
//  SendPostViewModel.swift
//  Instagram
//
//  Created by Guilherme Souza on 3/27/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import RxSwift

class SendPostViewModel {
    
    fileprivate let postService: PostServiceProtocol
    var caption = Variable<String?>(nil)
    
    init(postService: PostServiceProtocol) {
        self.postService = postService
    }
    
    func sharePost() {
        
    }
}
