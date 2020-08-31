//
//  ArticleCell.swift
//  TheNews
//
//  Created by MD SAZID HASAN DIP on 29/8/20.
//  Copyright © 2020 MD SAZID HASAN DIP. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {

    //cell1
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var descrp: UITextView!
    @IBOutlet weak var publishedAt: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var content: UITextView!
    
    
    //cell2
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var sourceName: UILabel!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var publishedDate: UIButton!
    
    
    override var isHighlighted: Bool {
      didSet {
        
      }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}


//func shrink(down: Bool) {
//  UIView.animate(withDuration: 0.6) {
//    if down {
//      cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//    else {
//      cell.transform = .identity
//    }
//  }
//}
//}
