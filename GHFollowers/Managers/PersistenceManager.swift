//
//  PersistenceManager.swift
//  GHFollowers
//
//  Created by Мария  on 3.01.23.
//

import Foundation
enum PersistenceActionType {
    case ad,remove
    
}
enum PersistenceManager {
    static private let defaults =  UserDefaults.standard
    enum Keys {
        static let favorites = "favorites"
    }
    static func updateWith(favorite: Follower, actionType : PersistenceActionType, completed : @escaping(ErrorMessage?)-> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(let favorites):
                var retrivedFavorites =  favorites
            switch actionType {
            case .ad:
                guard !retrivedFavorites.contains(favorite) else {
                    completed(.alreadyInFavorites)
                    return
                }
                retrivedFavorites.append(favorite)
            case .remove:
                retrivedFavorites.removeAll{ $0.login == favorite.login}
            }
                completed(save(favorites: retrivedFavorites))
            case .failure(let failure):
                completed(failure)
            }
        }
    }
    
    static func retrieveFavorites(completed : @escaping(Result<[Follower],ErrorMessage>)-> Void){
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([]))
            return
        }
        do {
            let decoder =  JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completed(.success(favorites))
        }catch {
            completed(.failure(.unableToFavorites))
        }
    }
    static func save(favorites :[Follower])-> ErrorMessage? {
        do {
            let encoder = JSONEncoder()
            let encodeFavorites = try encoder.encode(favorites)
            defaults.set(encodeFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorites
        }
    }
   
}
