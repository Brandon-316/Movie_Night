//
//  ResultsCell.swift
//  MovieNight
//
//  Created by Brandon Mahoney on 12/24/18.
//  Copyright © 2018 Brandon Mahoney. All rights reserved.
//

import Foundation
import UIKit

class ResultsCell: UITableViewCell {
    
    let color1: UIColor = UIColor(hex: "#AADCF0")
    let color2: UIColor = UIColor(hex: "#C1E8F7")
    
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initializeWith(_ result: Result, isEven: Bool) {
        var year: String = result.releaseDate
        
        // Some movies do not have a recorded release date
        if year.count == 10 {
            year.removeLast(6)
            self.yearLabel.text = year
        } else {
            // If release date is doesn't exist add empty space so label does not disappear
            self.yearLabel.text = " "
        }
        
        self.titleLabel.text = result.title
        
        // Stagger imageView colors
        if isEven {
            movieImage.backgroundColor = color1
        } else {
            movieImage.backgroundColor = color2
        }
    }
    
    
}
