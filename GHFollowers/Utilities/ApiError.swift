//
//  ErrorMessage.swift
//  GHFollowers
//
//  Created by flamyoad on 18/02/2024.
//

import Foundation

// https://www.swiftyplace.com/blog/understanding-swift-enumeration-enum-with-raw-value-and-associated-values#:~:text=Raw%20values%20are%20default%20values,an%20integer%20or%20a%20string.
enum ApiError: String, Error {
    case invalidUserName = "This username created invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from server. Please try again."
    case invalidData = "The data received from server was invalid. Please try again."
    
    case unableToFavourite = "There was error adding this user to favourites."
    case alreadyInFavourite = "You already favourited this user."
}
