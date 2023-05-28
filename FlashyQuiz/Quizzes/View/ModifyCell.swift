//
//  ModifyCell.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 28/5/2023.
//

import UIKit

class ModifyCell: UITableViewCell {

    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var correctAnswerTextField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var incorrectAnswersTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
