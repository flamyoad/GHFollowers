//
//  Follower.swift
//  GHFollowers
//
//  Created by flamyoad on 18/02/2024.
//

import Foundation

struct Follower: Codable, Hashable {
    let login: String
    let avatarUrl: String
    
    enum CodingKeys: String, CodingKey {
        case login 
        case avatarUrl = "avatar_url"
    }
}

