//
//  DetailsCell.swift
//  FlashyQuiz
//
//  Created by Ashton Chan on 30/5/2023.
//

import UIKit

class DetailsCell: UITableViewCell {

    @IBOutlet weak var questions: UILabel!
    @IBOutlet weak var answers: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
