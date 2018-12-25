//
//  RatingsTableVC.swift
//  MovieNight
//
//  Created by Brandon Mahoney on 12/21/18.
//  Copyright © 2018 Brandon Mahoney. All rights reserved.
//

import UIKit

class RatingsTableVC: UITableViewController {
    
    //MARK: Properties
    var parameters: Parameters?
    var selectedRatings: [String] = []
    var currentSelectedUser: Users?
    var userChoices: UserChoices?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parameters?.ratings.sort(by: { $0.order < $1.order })
        
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let ratings = parameters?.ratings else { return 0 }
        return ratings.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ratingCell", for: indexPath) as! RatingCell
        guard let ratings = parameters?.ratings else { return cell }
        let isSelected = selectedRatings.contains(ratings[indexPath.row].certification)
        cell.initializeWith(ratings[indexPath.row], isSelected: isSelected)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as? RatingCell
        guard let isChecked = cell?.isChecked else { return }
        cell?.isChecked = !isChecked
        handleStoreRating(for: indexPath, selected: !isChecked)
        print(selectedRatings)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "peopleSegue" {
            guard let destinationController = segue.destination as? PeopleTableVC else { return }
            destinationController.parameters = self.parameters
            destinationController.currentSelectedUser = self.currentSelectedUser
            destinationController.userChoices = self.userChoices
        }
    }
    
    //MARK: Methods
    func handleStoreRating(for indexPath: IndexPath, selected: Bool) {
        guard let certification = parameters?.ratings[indexPath.row].certification else { return }
        if selected {
            selectedRatings.append(certification)
        } else {
            selectedRatings.removeAll { $0 == certification }
        }
        
    }
    
    // Commit selection
    func checkIfSelectionMade() {
        if selectedRatings.count == 0 {
            AlertUser().generalAlert(title: "Rating Not Selected", message: "Please select atleast one rating", vc: self)
        } else {
            commitSelections()
            self.performSegue(withIdentifier: "peopleSegue", sender: nil)
        }
    }
    
    func commitSelections() {
        guard let currentSelectedUser = self.currentSelectedUser else { return }
        switch currentSelectedUser {
            case .user1: self.userChoices?.user1.ratingCertifications = self.selectedRatings
            case .user2: self.userChoices?.user2.ratingCertifications = self.selectedRatings
        }
    }
    
    //MARK: Actions
    @IBAction func nextPressed(_ sender: Any) {
        checkIfSelectionMade()
    }
    
}
