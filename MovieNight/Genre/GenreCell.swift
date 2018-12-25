//
//  GenreCell.swift
//  MovieNight
//
//  Created by Brandon Mahoney on 12/20/18.
//  Copyright © 2018 Brandon Mahoney. All rights reserved.
//

import UIKit

class GenreCell: UITableViewCell {
    
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
    @IBOutlet weak var genreLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initializeWith(_ genre: Genre, isSelected: Bool) {
        self.genreLbl.text = genre.name
        self.isChecked = isSelected
    }
    

}
