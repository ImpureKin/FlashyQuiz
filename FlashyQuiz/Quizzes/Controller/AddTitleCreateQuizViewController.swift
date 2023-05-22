//
//  AddTitleCreateQuizViewController.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 21/5/2023.
//

import UIKit

class AddTittleCreateQuizViewController: UIViewController {
    
    @IBOutlet weak var quizTitle: UITextField!
    var dataManager = DataStorageManager()
    let quiz = Quiz(title: "hope this works", questions: [], userID: "13")

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func submitTitle(_ sender: Any) {
        dataManager.saveToFile([quiz])
        let loadedQuizzes = dataManager.loadFromFile()
        for quiz in loadedQuizzes {
            print("Loaded quiz: \(quiz.title)")
        }

    }
    
}
