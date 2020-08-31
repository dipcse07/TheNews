//
//  DetailsViewCell.swift
//  TheNews
//
//  Created by MD SAZID HASAN DIP on 29/8/20.
//  Copyright © 2020 MD SAZID HASAN DIP. All rights reserved.
//

import UIKit

class DetailsViewCell: UITableViewCell {

    @IBOutlet weak var dateStatus: UILabel!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var source: UILabel!
    
    @IBOutlet weak var descrp: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    
    @IBOutlet weak var fullContent: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
