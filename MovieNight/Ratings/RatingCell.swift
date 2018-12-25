//
//  RatingCell.swift
//  MovieNight
//
//  Created by Brandon Mahoney on 12/21/18.
//  Copyright © 2018 Brandon Mahoney. All rights reserved.
//

import UIKit

class RatingCell: UITableViewCell {
    
    var isChecked: Bool = false {
        didSet {
            if isChecked {
                checkmarkImage.image = UIImage(named: "SelectedCircle")
            } else {
                checkmarkImage.image = UIImage(named: "UnselectedCircle")
            }
        }
    }
    
    @IBOutlet weak var checkmarkImage: UIImageView!
    @IBOutlet weak var ratingLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initializeWith(_ rating: Rating, isSelected: Bool) {
        self.ratingLbl.text = rating.certification
        self.isChecked = isSelected
    }
    
    
}
