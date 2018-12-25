//
//  QueryString.swift
//  MovieNight
//
//  Created by Brandon Mahoney on 12/24/18.
//  Copyright © 2018 Brandon Mahoney. All rights reserved.
//

import Foundation

class QueryString {
    func createQueryString(with userChoices: UserChoices, apiKey: String) -> String {
        let ratings: String = createString(from: userChoices.user1.ratingCertifications, userArray2: userChoices.user2.ratingCertifications)
        let genres: String = createString(from: userChoices.user1.genresIDs, userArray2: userChoices.user2.genresIDs)
        let people: String = createString(from: userChoices.user1.peopleIds, userArray2: userChoices.user2.peopleIds)
        
        let queryString = "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&language=en-US&sort_by=popularity.desc&certification_country=US&certification=\(ratings)&include_adult=false&include_video=false&with_genres=\(genres)&with_people=\(people)"
        
        return queryString
    }
    
    private func createString<T>(from userArray1: [T], userArray2: [T]) -> String {
        let userArray = userArray1 + userArray2
        var userString: String = ""
        
        var newArray: [String] = []
        for object in userArray {
            newArray.append(String(describing: object))
        }
        newArray.removeDuplicates()
        
        for object in newArray {
            if userString.isEmpty {
                let objectString: String = object
                userString += objectString
            } else {
                let objectString: String = object
                userString += "%7C\(objectString)"
            }
        }
        return userString
    }
}
