//
//  User.swift
//  GHFollowers
//
//  Created by flamyoad on 18/02/2024.
//

import Foundation

struct User: Codable {
    let login: String
    let avatarUrl: String
    let name: String?
    let location: String?
    let bio: String?
    let publicRepos: Int
    let publicGists: Int
    let htmlUrl: String
    let following: Int
    let followers: Int
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
        case name
        case location
        case bio
        case publicRepos = "public_repos"
        case publicGists = "public_gists"
        case htmlUrl = "html_url"
        case following
        case followers
        case createdAt = "created_at"
    }
}
