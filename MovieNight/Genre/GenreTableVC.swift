//
//  GenreTableVC.swift
//  MovieNight
//
//  Created by Brandon Mahoney on 12/20/18.
//  Copyright © 2018 Brandon Mahoney. All rights reserved.
//

import UIKit

class GenreTableVC: UITableViewController {
    
//MARK: Properties
    var parameters: Parameters?
    var userChoices: UserChoices?
    var selectedIDs: [Int] = []
    var currentSelectedUser: Users?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        parameters?.genres.sort(by: { $0.name < $1.name })

    }

// MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let genres = parameters?.genres else { return 0 }
        return genres.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "genreCell", for: indexPath) as! GenreCell
        guard let genres = parameters?.genres else { return cell }
        let isSelected = selectedIDs.contains(genres[indexPath.row].id)
        cell.initializeWith(genres[indexPath.row], isSelected: isSelected)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as? GenreCell
        guard let isChecked = cell?.isChecked else { return }
        if checkMaxSelections(if: isChecked) {
            AlertUser().generalAlert(title: "Maximum Selections Made", message: "You've already made 3 selections. Uncheck one before making another", vc: self)
            print("Max checked")
            return
        }
        cell?.isChecked = !isChecked
        handleStoreGenre(for: indexPath, selected: !isChecked)
        print(selectedIDs)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ratingsSegue" {
            guard let destinationController = segue.destination as? RatingsTableVC else { return }
            destinationController.parameters = self.parameters
            destinationController.currentSelectedUser = self.currentSelectedUser
            destinationController.userChoices = self.userChoices
        }
    }
    
//MARK: Methods
    func checkMaxSelections(if isChecked: Bool) -> Bool {
        if selectedIDs.count == 3 && isChecked == false {
            return true
        } else {
            return false
        }
    }
    func handleStoreGenre(for indexPath: IndexPath, selected: Bool) {
        guard let genreID = parameters?.genres[indexPath.row].id else { return }
        if selected {
            selectedIDs.append(genreID)
        } else {
            selectedIDs.removeAll { $0 == genreID }
        }
        
    }
    
    // Complete selection
    func checkIfSelectionMade() {
        if selectedIDs.count == 0 {
            AlertUser().generalAlert(title: "Genre Not Selected", message: "Please select atleast on genre", vc: self)
        } else {
            commitSelections()
            self.performSegue(withIdentifier: "ratingsSegue", sender: nil)
        }
    }
    
    func commitSelections() {
        guard let currentSelectedUser = self.currentSelectedUser else { return }
        switch currentSelectedUser {
        case .user1: self.userChoices?.user1.genresIDs = self.selectedIDs
        case .user2: self.userChoices?.user2.genresIDs = self.selectedIDs
        }
    }
    
    
//MARK: Actions
    @IBAction func nextPressed(_ sender: Any) {
        checkIfSelectionMade()
    }
    
}
