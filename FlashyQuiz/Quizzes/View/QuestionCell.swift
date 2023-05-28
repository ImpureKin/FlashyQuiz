//
//  QuestionCell.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 24/5/2023.
//

import UIKit

class QuestionCell: UITableViewCell {

    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var correctAnswer: UILabel!
    @IBOutlet weak var correctAnswerLabel: UILabel!
    @IBOutlet weak var incorrectAnswer: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var incorrectAnswerTextView: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
