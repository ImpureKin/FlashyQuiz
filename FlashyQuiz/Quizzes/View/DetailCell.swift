//
//  DetailCell.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 25/5/2023.
//

import UIKit

class DetailCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel! //label that will show the quesiton
    @IBOutlet weak var correctAnswerLabel: UILabel! //label that will show stored correct answer

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
