//
//  ExplorePageQuizView.swift
//  FlashyQuiz
//
//  Created by Nicholas  Schlederer on 30/5/2023.
//

import Foundation
import UIKit


class ExplorePageQuizViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var PBQtable: UITableView!
    
        
        
        
        let QM = QuizManager() // imports quiz manager
        
        var PublicQuizzes: [Quiz] = []
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            PublicQuizzes = QM.getPublicQuizzes() ?? []
            let nib = UINib(nibName: "QuizCell", bundle: nil)
            
            PBQtable.register(nib, forCellReuseIdentifier: "QuizCell")
            
            PBQtable.dataSource = self
            PBQtable.delegate = self
        }
        
        
        
        
        
        
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return PublicQuizzes.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "QuizCell", for: indexPath) as! QuizCell
            
            
            let quiz = PublicQuizzes[indexPath.row]
            cell.quizTitle.text = quiz.title
            cell.questionLabel.text = "\(quiz.questions.count) questions"
            
            return cell
        }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
            let quiz = PublicQuizzes[indexPath.row]
            
            if navigationController?.topViewController == self {
                performSegue(withIdentifier: "ExploreToQDetails", sender: quiz)
            }
        }
            
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "ExploreToQDetails",
                let VC = segue.destination as? QuizDetailsViewController, //next view controller
                let quiz = sender as? Quiz {
                VC.quiz = quiz
            }
        }
        
            
            
    }
    
    
        
        
        

    
    
    

    

