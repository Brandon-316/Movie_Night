//
//  DatabaseService.swift
//  MovieNight
//
//  Created by Brandon Mahoney on 12/18/18.
//  Copyright © 2018 Brandon Mahoney. All rights reserved.
//

import Foundation


class JSONDownloader {
    
    let apiKey: String = "f5303998f327451e1bd20b5bbbb315d3"
    
    func getGenres() {
        
        guard let url: URL = URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=\(self.apiKey)&language=en-US") else { return }
        let session: URLSession = URLSession.shared
        
        // Get first page of data
        let task: URLSessionDownloadTask = session.downloadTask(with: url) { urlLocation, urlResponse, error in
            
            if let error = error {
                NotificationCenter.default.post(name: NSNotifications().networkError, object: error.localizedDescription)
            }
            
            // Decode data and calculate total number of pages
            if let urlLocation = urlLocation {
                if let data = try? Data(contentsOf: urlLocation) {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        let genres = try decoder.decode(Genres.self, from: data)
                        NotificationCenter.default.post(name: NSNotifications().genreRequestDidComplete, object: genres)
                    } catch {
                        
                    }
                }
            }
        }
        task.resume()
    }
    
    func getRatings() {
        
        guard let url: URL = URL(string: "https://api.themoviedb.org/3/certification/movie/list?api_key=\(self.apiKey)") else { return }
        let session: URLSession = URLSession.shared
        
        // Get first page of data
        let task: URLSessionDownloadTask = session.downloadTask(with: url) { urlLocation, urlResponse, error in
            
            if let error = error {
                NotificationCenter.default.post(name: NSNotifications().networkError, object: error.localizedDescription)
            }
            
            // Decode data and calculate total number of pages
            if let urlLocation = urlLocation {
                if let data = try? Data(contentsOf: urlLocation) {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        let genres = try decoder.decode(Ratings.self, from: data)
                        NotificationCenter.default.post(name: NSNotifications().ratingsRequestDidComplete, object: genres)
                    } catch {
                        
                    }
                }
            }
        }
        task.resume()
    }
    
    func getPeople() {
        var people: [Person] = []
        let totalPages: Int = 15
        var jsonError: Error?
        
        DispatchQueue.global(qos: .userInitiated).async {
            let downloadGroup = DispatchGroup()
            for page in stride(from: 1, through: totalPages, by: 1) {
                guard let url: URL = URL(string: "https://api.themoviedb.org/3/person/popular?api_key=\(self.apiKey)&language=en-US&page=\(page)") else { return }
                let session: URLSession = URLSession.shared
                
                downloadGroup.enter()
                let task: URLSessionDownloadTask = session.downloadTask(with: url) { urlLocation, urlResponse, error in
                    if let error = error {
                        NotificationCenter.default.post(name: NSNotifications().networkError, object: error.localizedDescription)
                    }
                    
                    if let urlLocation = urlLocation {
                        if let data = try? Data(contentsOf: urlLocation) {
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            
                            do {
                                let persons = try decoder.decode(People.self, from: data)
                                people.append(contentsOf: persons.results)
                            } catch {
                                jsonError = error
                            }
                            downloadGroup.leave()
                        }
                    }
                }
                task.resume()
            }
            downloadGroup.wait()
            
            // All pages are complete task
            DispatchQueue.main.async {
                self.completeTask(notification: NSNotifications().peopleRequestDidComplete, error: jsonError, results: people)
            }
        }
        
        
    }
    
    
    func getResults(with userChoices: UserChoices) {
        var results: Results?
        var totalPages: Int = 0
        var jsonError: Error?
        // Create JSON request String from user choices
        let queryString: String = QueryString().createQueryString(with: userChoices, apiKey: self.apiKey)
        
        guard let url: URL = URL(string: "\(queryString)&page=1") else { return }
        let session: URLSession = URLSession.shared
        
        // Get first page of data
        let task: URLSessionDownloadTask = session.downloadTask(with: url) { urlLocation, urlResponse, error in
            if let error = error {
                NotificationCenter.default.post(name: NSNotifications().networkError, object: error.localizedDescription)
            }
            
            // Decode data and calculate total number of pages
            if let urlLocation = urlLocation {
                if let data = try? Data(contentsOf: urlLocation) {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        results = try decoder.decode(Results.self, from: data)
                    } catch {
                        jsonError = error
                        self.completeTask(notification: NSNotifications().jsonError, error: jsonError, results: results)
                    }
                }
            }
            
            guard let unwrappedResults = results?.totalPages else { return }
            
            // Get all other pages of data if there are any
            if unwrappedResults > 1 {
                DispatchQueue.global(qos: .userInitiated).async {
                    let downloadGroup = DispatchGroup()
                    
                    if unwrappedResults > 20 {
                        totalPages = 20
                    } else {
                        totalPages = unwrappedResults
                    }
                    
                    for page in stride(from: 2, through: totalPages, by: 1) {
                        guard let url: URL = URL(string: "\(queryString)&page=\(page)") else { return }
                        let session: URLSession = URLSession.shared
                        
                        downloadGroup.enter()
                        let task: URLSessionDownloadTask = session.downloadTask(with: url) { urlLocation, urlResponse, error in
                            
                            if let error = error {
                                NotificationCenter.default.post(name: NSNotifications().networkError, object: error.localizedDescription)
                            }
                            
                            // Decode data and calculate total number of pages
                            if let urlLocation = urlLocation {
                                if let data = try? Data(contentsOf: urlLocation) {
                                    let decoder = JSONDecoder()
                                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                                    do {
                                        let pageResults = try decoder.decode(Results.self, from: data)
                                        results?.results += pageResults.results
                                    } catch {
                                        jsonError = error
                                    }
                                }
                            }
                            downloadGroup.leave()
                        }
                        task.resume()
                    }
                    downloadGroup.wait()
                    DispatchQueue.main.async {
                        guard let results = results else { return }
                        self.completeTask(notification: NSNotifications().resultsRequestDidComplete, error: jsonError, results: results)
                    }
                }
            } else {
                guard let results = results else { return }
                self.completeTask(notification: NSNotifications().resultsRequestDidComplete, error: jsonError, results: results)
            }
        }
        task.resume()
    }
    
    func completeTask(notification: NSNotification.Name, error: Error?, results: Any?) {
        if let error = error {
            let jsonError = JSONError.init(errorMessage: error.localizedDescription)
            NotificationCenter.default.post(name: NSNotifications().jsonError, object: jsonError)
            return
        }
        NotificationCenter.default.post(name: notification, object: results)
    }
}
