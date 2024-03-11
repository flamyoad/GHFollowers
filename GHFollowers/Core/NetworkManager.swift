//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by flamyoad on 18/02/2024.
//

import UIKit

protocol NetworkManager {
    func getFollowers(for username: String, page: Int) async throws -> [Follower]
    func getUserInfo(for username: String) async throws -> User
}

class NetworkManagerImpl: NetworkManager {
    
    static let shared = NetworkManagerImpl()
    
    private let baseURL = "https://api.github.com"
    let decoder = JSONDecoder()
    
    private init() {
        decoder.dateDecodingStrategy = .iso8601
    }
    
    func getFollowers(for username: String, page: Int) async throws -> [Follower] {
        let endpoint = baseURL + "/users/\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            throw ApiError.invalidUserName
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw ApiError.invalidResponse
        }
        
        do {
            return try decoder.decode([Follower].self, from: data)
        } catch {
            throw ApiError.invalidData
        }
    }
    
    func getUserInfo(for username: String) async throws -> User {
        let endpoint = baseURL + "/users/\(username)"
        
        guard let url = URL(string: endpoint) else {
            throw ApiError.invalidUserName
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw ApiError.invalidResponse
        }
        
        do {
            return try decoder.decode(User.self, from: data)
        } catch {
            throw ApiError.invalidData
        }
    }
}
