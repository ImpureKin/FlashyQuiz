//
//  ModifyCell.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 28/5/2023.
//

import UIKit

class ModifyCell: UITableViewCell {

    @IBOutlet weak var questionTextField: UITextField! //label that will show the quesiton
    @IBOutlet weak var correctAnswerTextField: UITextField! //Shows correct answer stored for that question
    @IBOutlet weak var deleteButton: UIButton! //button used to delete the question in the array
    @IBOutlet weak var incorrectAnswersTextField: UITextField! //Shows incorrect answers stored for that question

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
