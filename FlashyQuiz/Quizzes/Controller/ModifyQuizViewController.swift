//
//  ModifyQuizViewController.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 25/5/2023.
//

import UIKit

class ModifyQuizViewController: UIViewController {
    
    var loggedUser: User?
    var modifiedQuiz: Quiz?
    var quiz: Quiz?
  
    var selectedQuestionIndex: Int?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var privacySwitch: UISwitch!
    @IBOutlet weak var modifyTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.text = quiz?.title
        privacySwitch.isOn = quiz?.privacy == "Public"
        modifySetup()
        
        let nib = UINib(nibName: "ModifyCell", bundle: nil)
        modifyTableView.register(nib, forCellReuseIdentifier: "ModifyCell")
        
        modifyTableView.delegate = self
        modifyTableView.dataSource = self
    }
    
    func modifySetup() {
            guard let quiz = quiz else { return }
            
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(quiz)
                let decoder = JSONDecoder()
                modifiedQuiz = try decoder.decode(Quiz.self, from: data)
                
                // Assign the copied questions to modifiedQuiz
                modifiedQuiz?.questions = quiz.questions
            } catch {
                print("Error during deep copy: \(error)")
            }
        }
    
    @IBAction func deleteQuizButtom(_ sender: UIButton) {
        // Create an alert to confirm deletion
        let alert = UIAlertController(title: "Delete Quiz",
                                      message: "Are you sure you want to delete this quiz?",
                                      preferredStyle: .alert)
        
        // Add a cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        // Add a delete action
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            // Delete the quiz
            if let quiz = self?.quiz {
                DataStorageManager().deleteQuiz(quiz)
                
                // Navigate back to a certain page
                self?.navigateBackToPage()
            }
        }
        alert.addAction(deleteAction)
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard var modifiedQuiz = modifiedQuiz else { return }
        
        if let newTitle = titleTextField.text {
            modifiedQuiz.title = newTitle
            modifiedQuiz.privacy = privacySwitch.isOn ? "Public" : "Private"
            
            // Call the modifyQuiz function in the data storage manager to update the quiz
            DataStorageManager().modifyQuiz(modifiedQuiz)
            
            // Pop the view controller to go back to the previous screen
            self.navigateBackToPage()
        }
    }
    
    func navigateBackToPage() {
        if let navigationController = navigationController {
            for viewController in navigationController.viewControllers {
                if let quizMainMenuVC = viewController as? BaseTabBarController{
                    navigationController.popToViewController(quizMainMenuVC, animated: true)
                    return
                }
            }
        }
        
        // Default fallback action
        navigationController?.popViewController(animated: true)
    }
    
    }

extension ModifyQuizViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modifiedQuiz?.questions.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ModifyCell", for: indexPath) as! ModifyCell
           
        let question = quiz!.questions[indexPath.row]
           cell.questionTextField.text = question.question
           cell.correctAnswerTextField.text = question.correctAnswer
           cell.incorrectAnswersTextField.text = question.incorrectAnswers.joined(separator: ", ")
        cell.deleteButton.tag = indexPath.row
        
           
        return cell
    }
    
    @objc func deleteQuestion(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? UITableViewCell,
              let indexPath = modifyTableView.indexPath(for: cell) else {
            return
        }
        
        _ = modifiedQuiz?.questions[indexPath.row]
        
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
            self?.modifiedQuiz?.questions.remove(at: indexPath.row)
            
            // Reload the table view to reflect the changes
            self?.modifyTableView.reloadData()
        }
        alert.addAction(deleteAction)
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedQuestionIndex = indexPath.row
        tableView.reloadData()
        
        // Load the question details when a question is selected
        modifySetup()
    }
}
