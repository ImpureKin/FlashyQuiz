//
//  QuizListViewViewController.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 20/5/2023.
//

import UIKit

class QuizListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var userTable: UITableView!
    
    var quizzes: [Quiz] = []
    var dataManager = DataStorageManager()
    var shouldPerformSegue = true
    let userId = 1
        
        override func viewDidLoad() {
            super.viewDidLoad()
            let nib = UINib(nibName: "QuizCell", bundle: nil)
            
            userTable.register(nib, forCellReuseIdentifier: "QuizCell")
            
            userTable.dataSource = self
            userTable.delegate = self
            
            fetchQuizzes()
        }
        
        func fetchQuizzes() {
            quizzes = dataManager.loadQuizzes(forUserId: userId)
            userTable.reloadData()
        }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return quizzes.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuizCell", for: indexPath) as! QuizCell
            
            let quiz = quizzes[indexPath.row]
            cell.quizTitle.text = quiz.title
            cell.questionLabel.text = "\(quiz.questions.count) questions"
            
            
            
            return cell
        }
                
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let quiz = quizzes[indexPath.row]
        
        if navigationController?.topViewController == self {
            performSegue(withIdentifier: "goToQuizDetails", sender: quiz)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToQuizDetails",
           let VC = segue.destination as? QuizDetailsViewController,
           let quiz = sender as? Quiz {
            VC.quiz = quiz
        }
    }
}

