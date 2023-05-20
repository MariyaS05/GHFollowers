//
//  ErrorMessage.swift
//  GHFollowers
//
//  Created by Мария  on 22.12.22.
//

import Foundation
enum ErrorMessage : String, Error{
    case invalidUsername = "This username created an invalid request.Please try again"
    case unableToCompleate = "Unable to compleate your request.Please check your internet connection"
    case invalidResponse = "Invalid response from the server.Please try again!"
    case invalidData = "The data received from the server was invalid.Please try again."
    case unableToFavorites = "There was an error favoriting this user.Please try again"
    case alreadyInFavorites = "You've already favorited this user."
    
}
