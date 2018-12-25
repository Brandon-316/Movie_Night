//
//  ResultsTableVC.swift
//  MovieNight
//
//  Created by Brandon Mahoney on 12/24/18.
//  Copyright © 2018 Brandon Mahoney. All rights reserved.
//

import Foundation
import UIKit

class ResultsTableVC: UITableViewController {
    
    var results: Results?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        results?.results.sort(by: {$0.popularity > $1.popularity})
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let results = results?.results else { return 0 }
        return results.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultsCell", for: indexPath) as! ResultsCell
        guard let results = results else { return cell }
        
        let isEven: Bool = indexPath.row % 2 == 0
        
        cell.initializeWith(results.results[indexPath.row], isEven: isEven)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
// MARK: Actions
    @IBAction func donePressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
