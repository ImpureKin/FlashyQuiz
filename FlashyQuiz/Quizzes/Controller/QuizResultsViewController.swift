//
//  QuizResultsViewController.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 20/5/2023.
//

import UIKit

class QuizResultsViewController: UIViewController {
    
    @IBOutlet weak var resultLabel: UILabel!
    
    var correctAnswers = 0
    var totalQuestions = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        resultLabel!.text = "\(correctAnswers)/\(totalQuestions)"
    }
    

}

