//
//  ExplorePageFlashCardViewController.swift
//  FlashyQuiz
//
//  Created by Nicholas  Schlederer on 30/5/2023.
//

import Foundation
import UIKit

class ExplorePageFlashCardViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let QM = QuizManager() // imports quiz manager
    
    var PublicQuizzes: [Quiz] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PublicQuizzes = QM.getPublicQuizzes() ?? []
    }
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PublicQuizzes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PubQuizCell", for: indexPath) as! QuizCell
        
        
        let quiz = PublicQuizzes[indexPath.row]
        cell.quizTitle.text = quiz.title
        cell.questionLabel.text = "\(quiz.questions.count) questions"
        
        return cell
    }
    
    
}
