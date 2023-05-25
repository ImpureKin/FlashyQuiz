//
//  QuizDetailsViewController.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 25/5/2023.
//

import Foundation
import UIKit

class QuizDetailsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var quizTitle: UILabel!
    @IBOutlet weak var detailTable: UITableView!
    
    var quiz: Quiz?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quizTitle.text = quiz?.title
        
        let nib = UINib(nibName: "DetailCell", bundle: nil)
        detailTable.register(nib, forCellReuseIdentifier: "DetailCell")
        
        detailTable.delegate = self
        detailTable.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        quiz!.questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailCell
        
        let question = quiz!.questions[indexPath.row]
        cell.questionLabel.text = question.text
        cell.correctAnswerLabel.text = question.correctAnswer
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "goToModifyQuiz":
                if let modifyQuizVC = segue.destination as? ModifyQuizViewController {
                    modifyQuizVC.quiz = quiz
                }
            case "goToPlayQuiz":
                if let playQuizVC = segue.destination as? QuizGameViewController {
                    playQuizVC.quiz = quiz
                }
            default:
                break
            }
        }
    }
    
}
