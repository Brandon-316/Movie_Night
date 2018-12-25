//
//  NSNotifications.swift
//  MovieNight
//
//  Created by Brandon Mahoney on 12/19/18.
//  Copyright © 2018 William Mahoney. All rights reserved.
//

import Foundation

class NSNotifications {
    let userSelectionSaved = NSNotification.Name(rawValue: "userSelectionSaved")
    
    let jsonError = NSNotification.Name("jsonError")
    let genreRequestDidComplete = NSNotification.Name(rawValue: "genreRequestDidComplete")
    let ratingsRequestDidComplete = NSNotification.Name(rawValue: "ratingsRequestDidComplete")
    let peopleRequestDidComplete = NSNotification.Name(rawValue: "peopleRequestDidComplete")
    let resultsRequestDidComplete = NSNotification.Name(rawValue: "resultsRequestDidComplete")
    let networkError = NSNotification.Name(rawValue: "networkError")
}
