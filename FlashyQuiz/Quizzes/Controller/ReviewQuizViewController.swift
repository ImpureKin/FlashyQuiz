//
//  ReviewQuizViewController.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 22/5/2023.
//

import UIKit

class ReviewQuizViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var quizTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    var quizTitle: String = ""
    var questions: [Question] = []
    var dataManager = DataStorageManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        quizTitleLabel.text = quizTitle
        let nib = UINib(nibName: "QuestionCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "QuestionCell")

        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionCell

        let question = questions[indexPath.row]
        cell.question.text = question.text
        cell.correctAnswerLabel.text = question.correctAnswer

        // Set the incorrect answers with new lines
        let incorrectAnswers = question.incorrectAnswers.joined(separator: "\n")
        cell.incorrectAnswerTextView.text = incorrectAnswers

        cell.deleteButton.tintColor = UIColor.red
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteQuestion(_:)), for: .touchUpInside)

        return cell
    }

    @objc func deleteQuestion(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? UITableViewCell,
              let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        _ = questions[indexPath.row]
        
        // Create an alert to confirm deletion
        let alert = UIAlertController(title: "Delete Question",
                                      message: "Are you sure you want to delete this question?",
                                      preferredStyle: .alert)
        
        // Add a cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        // Add a delete action
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            // Remove the question at the corresponding index
            self?.questions.remove(at: indexPath.row)
            
            // Reload the table view to reflect the changes
            self?.tableView.reloadData()
        }
        alert.addAction(deleteAction)
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }

    
    @IBAction func submitButton(_ sender: UIButton) {
           saveQuizToDatabase()
       }
       
       
       func saveQuizToDatabase() {
           let quiz = Quiz(userId: 1, title: quizTitle, privacy: "true", questions: questions)
           dataManager.saveToFile([quiz])
           
           let alert = UIAlertController(title: "Quiz Saved", message: "The quiz has been saved successfully.", preferredStyle: .alert)
                  
                  // Add an action to dismiss the view controller
                  let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                      // Navigate back to a certain page
                      self?.navigateBackToPage()
                  }
                  alert.addAction(okAction)
                  
                  // Present the alert
                  present(alert, animated: true, completion: nil)
       }
    
    func navigateBackToPage() {
            if let navigationController = navigationController {
                for viewController in navigationController.viewControllers {
                    if viewController is QuizMainMenuViewController {
                        navigationController.popToViewController(viewController, animated: true)
                        return
                    }
                }
            }
            
            // Default fallback action
            navigationController?.popViewController(animated: true)
        }



}
