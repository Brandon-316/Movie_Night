//
//  PeopleTableVC.swift
//  MovieNight
//
//  Created by Brandon Mahoney on 12/21/18.
//  Copyright © 2018 Brandon Mahoney. All rights reserved.
//

import UIKit

class PeopleTableVC: UITableViewController {
    //MARK: Properties
    var parameters: Parameters?
    var selectedPeople: [Int] = []
    var currentSelectedUser: Users?
    var userChoices: UserChoices?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parameters?.people.sort(by: { $0.popularity > $1.popularity })
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let people = parameters?.people else { return 0 }
        return people.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as! PersonCell
        guard let people = parameters?.people else { return cell }
        let isSelected = selectedPeople.contains(people[indexPath.row].id)
        cell.initializeWith(people[indexPath.row], isSelected: isSelected)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as? PersonCell
        guard let isChecked = cell?.isChecked else { return }
        if checkMaxSelections(if: isChecked) {
            AlertUser().generalAlert(title: "Maximum Selections Made", message: "You've already made 5 selections. Uncheck one before making another", vc: self)
            print("Max checked")
            return
        }
        cell?.isChecked = !isChecked
        handleStorePerson(for: indexPath, selected: !isChecked)
        print(selectedPeople)
    }
    
    
    //MARK: Methods
    func checkMaxSelections(if isChecked: Bool) -> Bool {
        if selectedPeople.count == 5 && isChecked == false {
            return true
        } else {
            return false
        }
    }
    func handleStorePerson(for indexPath: IndexPath, selected: Bool) {
        guard let person = parameters?.people[indexPath.row].id else { return }
        if selected {
            selectedPeople.append(person)
        } else {
            selectedPeople.removeAll { $0 == person }
        }
        
    }
    
    func checkIfSelectionMade() {
        if selectedPeople.count == 0 {
            AlertUser().generalAlert(title: "Rating Not Selected", message: "Please select atleast one people", vc: self)
        } else {
            commitSelections()
            NotificationCenter.default.post(name: NSNotifications().userSelectionSaved, object: self.userChoices)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func commitSelections() {
        guard let currentSelectedUser = self.currentSelectedUser else { return }
        switch currentSelectedUser {
            case .user1: self.userChoices?.user1.peopleIds = self.selectedPeople
            case .user2: self.userChoices?.user2.peopleIds = self.selectedPeople
        }
    }
    
    //MARK: Actions
    @IBAction func donePressed(_ sender: Any) {
        checkIfSelectionMade()
    }
}
