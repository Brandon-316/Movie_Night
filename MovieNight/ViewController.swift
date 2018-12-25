//
//  ViewController.swift
//  MovieNight
//
//  Created by Brandon Mahoney on 12/18/18.
//  Copyright © 2018 Brandon Mahoney. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
// MARK: Properties
    var parameters: Parameters = Parameters.init()
    var userChoices: UserChoices = UserChoices.init(user1: User(), user2: User())
    var results: Results?
    
    var currentSelectedUser: Users = Users.user1
    var user1DidFinish: Bool = false
    var user2DidFinish: Bool = false
    
    var packagesReceived: Int = 0
    
    var bubbleStackMultiplier: CGFloat = 0
    
// MARK: Outlets
    @IBOutlet weak var user1Btn: UIButton!
    @IBOutlet weak var user2Btn: UIButton!
    @IBOutlet weak var bubbleStack: UIStackView!
    @IBOutlet weak var bubbleStackCenter: NSLayoutConstraint!
    
    @IBOutlet weak var viewResultsBtn: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    
// MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBubbleStack()
        activityIndicator.startAnimating()
        JSONDownloader().getGenres()
        JSONDownloader().getRatings()
        JSONDownloader().getPeople()
        roundViewResultsBtn()
        
        NotificationCenter.default.addObserver(forName: NSNotifications().userSelectionSaved, object: nil, queue: nil){ notification in
            guard let userChoices = notification.object as? UserChoices else { return }
            self.userChoices = userChoices
            switch self.currentSelectedUser {
                case .user1:
                    self.user1DidFinish = true
                    self.user1Btn.imageView?.image = UIImage(named: "BubbleSelected")
                case .user2:
                    self.user2DidFinish = true
                    self.user2Btn.imageView?.image = UIImage(named: "BubbleSelected")
            }
            print(self.userChoices)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotifications().genreRequestDidComplete, object: nil, queue: nil) { notification in
            guard let genres = notification.object as? Genres else { return }
            self.parameters.genres = genres.genres
            self.packagesReceived += 1
            self.checkDownloads()
            print("Genres downloaded")
            print(self.parameters.genres.count)
        }
        NotificationCenter.default.addObserver(forName: NSNotifications().ratingsRequestDidComplete, object: nil, queue: nil) { notification in
            guard let ratings = notification.object as? Ratings else { return }
            self.parameters.ratings = ratings.certifications.US
            self.packagesReceived += 1
            self.checkDownloads()
            print("Ratings downloaded")
            print(self.parameters.ratings.count)
        }
        NotificationCenter.default.addObserver(forName: NSNotifications().peopleRequestDidComplete, object: nil, queue: nil) { notification in
            guard let people = notification.object as? [Person] else { return }
            self.parameters.people = people
            self.packagesReceived += 1
            self.checkDownloads()
            print("People downloaded")
            print(self.parameters.people.count)
        }
        NotificationCenter.default.addObserver(forName: NSNotifications().resultsRequestDidComplete, object: nil, queue: nil) { notification in
            guard let results = notification.object as? Results else { print("Guard returned on Notification"); return }
            self.results = results
            print("Results count in notification \(String(describing: self.results?.results.count))")
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.performSegue(withIdentifier: "resultsSegue", sender: nil)
            }
        }
        NotificationCenter.default.addObserver(forName: NSNotifications().jsonError, object: nil, queue: nil) { notification in
            if let jsonError = notification.object as? JSONError {
                AlertUser().generalAlert(title: "Error", message: jsonError.errorMessage, vc: self)
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
            }
        }
        NotificationCenter.default.addObserver(forName: NSNotifications().networkError, object: nil, queue: nil) { notification in
            if let networkError = notification.object as? String {
                AlertUser().generalAlert(title: "Network Error", message: networkError, vc: self)
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "genreSegue" {
            guard let destinationController = segue.destination as? GenreTableVC else { return }
            destinationController.parameters = self.parameters
            destinationController.currentSelectedUser = self.currentSelectedUser
            destinationController.userChoices = self.userChoices
        }
        
        if segue.identifier == "resultsSegue" {
            guard let destinationController = segue.destination as? ResultsTableVC else { return }
            destinationController.results = self.results
        }
    }

    
// MARK: Methods
    func roundViewResultsBtn() {
        self.viewResultsBtn.layer.cornerRadius = 5
    }
    
    // Check if all JSON data has been recieved
    func checkDownloads() {
        if self.packagesReceived != 3 {
            return
        }
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.loadingLabel.isHidden = true
            self.animateBubbleButtons()
            self.viewResultsBtn.isUserInteractionEnabled = true
            self.viewResultsBtn.isHighlighted = false
        }
    }
    
    // Do initial move of bubbles off screen
    func setupBubbleStack() {
        let newConstraint = self.bubbleStackCenter.constraintWithMultiplier(2.5)
        self.view.removeConstraint(self.bubbleStackCenter)
        self.bubbleStackCenter = newConstraint
        self.view.addConstraint(newConstraint)
        self.view.layoutIfNeeded()
    }
    
    // Handles slide up animation of bubbles after parameters load
    func animateBubbleButtons() {
        let newConstraint = self.bubbleStackCenter.constraintWithMultiplier(0.85)
        self.view.removeConstraint(self.bubbleStackCenter)
        self.bubbleStackCenter = newConstraint
        self.view.addConstraint(self.bubbleStackCenter)
        UIView.animate(
            withDuration: 1.0,
            delay: 0,
            usingSpringWithDamping: 0.65,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                self.view.layoutIfNeeded()
        }, completion: nil
        )
    }

    
// MARK: Actions
    @IBAction func clearSelections(_ sender: UIButton) {
        self.userChoices = UserChoices.init(user1: User(), user2: User())
        user1Btn.imageView?.image = UIImage(named: "BubbleNotSelected")
        user2Btn.imageView?.image = UIImage(named: "BubbleNotSelected")
        user1DidFinish = false
        user2DidFinish = false
        print(userChoices)
    }
    
    @IBAction func userSelected(_ sender: UIButton) {
        switch sender {
            case user1Btn: self.currentSelectedUser = .user1
            case user2Btn: self.currentSelectedUser = .user2
            default: return
        }
        self.performSegue(withIdentifier: "genreSegue", sender: nil)
        print(currentSelectedUser)
    }
    
    @IBAction func viewResults(_ sender: UIButton) {
        print("viewResults pressed")
        if user1DidFinish && user2DidFinish {
            activityIndicator.startAnimating()
            JSONDownloader().getResults(with: userChoices)
        } else {
            AlertUser().generalAlert(title: "Selections Not Complete", message: "Please complete selections for both users", vc: self)
        }
    }
}
