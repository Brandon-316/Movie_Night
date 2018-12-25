//
//  DataModels.swift
//  MovieNight
//
//  Created by Brandon Mahoney on 12/20/18.
//  Copyright © 2018 Brandon Mahoney. All rights reserved.
//

import Foundation

// MARK: Parameters
struct Parameters {
    var genres: [Genre]
    var ratings: [Rating]
    var people: [Person]
    
    init() {
        self.genres = []
        self.ratings = []
        self.people = []
    }
}

// MARK: User choices
struct UserChoices {
    var user1: User
    var user2: User
}

struct User {
    var genresIDs: [Int] = []
    var ratingCertifications: [String] = []
    var peopleIds: [Int] = []
}

// MARK: Results
class Results: Codable {
    let totalPages: Int?
    var results: [Result]
}

struct Result: Codable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String
    let backdropPath: String?
    let posterPath: String?
    let popularity: Double
}


// MARK: Genres
struct Genres: Codable {
    var genres: [Genre]
}

struct Genre: Codable {
    var id: Int
    var name: String
}


// MARK: Ratings
struct Ratings: Codable {
    let certifications: Country
}

struct Country: Codable {
    let US: [Rating]
}

struct Rating: Codable {
    let certification: String
    let meaning: String
    let order: Int
}


// MARK: People
struct People: Codable {
    let results: [Person]
}

struct Person: Codable {
    let popularity: Double
    let id: Int
    let name: String
}



// MARK: JSON Error Model
struct JSONError {
    let errorMessage: String
}
