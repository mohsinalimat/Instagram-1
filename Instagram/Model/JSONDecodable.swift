//
//  JSONDecodable.swift
//  Instagram
//
//  Created by Guilherme Souza on 3/27/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation

protocol JSONDecodable {
    init(json: [String: Any])
}
