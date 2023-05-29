//
//  ModifyQuizViewController.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 25/5/2023.
//

import UIKit

class ModifyQuizViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var quiz: Quiz?
    var quizManager = QuizManager()
    
    // Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var privacySwitch: UISwitch!
    @IBOutlet weak var modifyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the initial values for the view components
        titleTextField.text = quiz?.title
        privacySwitch.isOn = quiz?.privacy == "Public"
        
        // Register the custom cell
        let nib = UINib(nibName: "ModifyCell", bundle: nil)
        modifyTableView.register(nib, forCellReuseIdentifier: "ModifyCell")
        
        // Set the delegate and dataSource
        modifyTableView.delegate = self
        modifyTableView.dataSource = self
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quiz?.questions.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ModifyCell", for: indexPath) as! ModifyCell
        
        if let question = quiz?.questions[indexPath.row] {
            cell.questionTextField.text = question.question
            cell.correctAnswerTextField.text = question.correctAnswer
            cell.incorrectAnswersTextField.text = question.incorrectAnswers.joined(separator: ", ")
        }
        
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteQuestion(_:)), for: .touchUpInside)
        
        cell.questionTextField.addTarget(self, action: #selector(questionTextFieldChanged(_:)), for: .editingChanged)
        cell.correctAnswerTextField.addTarget(self, action: #selector(correctAnswerTextFieldChanged(_:)), for: .editingChanged)
        cell.incorrectAnswersTextField.addTarget(self, action: #selector(incorrectAnswersTextFieldChanged(_:)), for: .editingChanged)
        
        return cell
    }
    
   
    
    @objc func deleteQuestion(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? UITableViewCell,
              let indexPath = modifyTableView.indexPath(for: cell),
              let questionCount = quiz?.questions.count else {
            return
        }
        
        if questionCount <= 1 {
            // Display an alert informing that the last question cannot be deleted
            let alert = UIAlertController(title: "Cannot Delete Question",
                                          message: "You cannot delete the last question.",
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
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
            self?.quiz?.questions.remove(at: indexPath.row)
            
            // Reload the table view to reflect the changes
            self?.modifyTableView.reloadData()
        }
        alert.addAction(deleteAction)
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }


    
    @objc func questionTextFieldChanged(_ textField: UITextField) {
        guard let index = textField.superview?.tag else { return }
        quiz?.questions[index].question = textField.text ?? ""
    }
    
    @objc func correctAnswerTextFieldChanged(_ textField: UITextField) {
        guard let index = textField.superview?.tag else { return }
        quiz?.questions[index].correctAnswer = textField.text ?? ""
    }
    
    @objc func incorrectAnswersTextFieldChanged(_ textField: UITextField) {
        guard let index = textField.superview?.tag else { return }
        let answers = textField.text?.components(separatedBy: ", ") ?? []
        quiz?.questions[index].incorrectAnswers = answers
    }
    

    
    @IBAction func updateQuizButtonTapped(_ sender: UIButton) {
        guard let quizId = quiz?.quizId,
              let userId = quiz?.userId,
              let updatedTitle = titleTextField.text,
              !updatedTitle.isEmpty else {
            displayAlert(message: "Invalid quiz data")
            return
        }
        
        let updatedPrivacy = privacySwitch.isOn ? "Public" : "Private"
        
        var updatedQuestions: [Question] = []
        
        for row in 0..<modifyTableView.numberOfRows(inSection: 0) {
            guard let cell = modifyTableView.cellForRow(at: IndexPath(row: row, section: 0)) as? ModifyCell,
                  let questionText = cell.questionTextField.text,
                  !questionText.isEmpty,
                  let correctAnswerText = cell.correctAnswerTextField.text,
                  !correctAnswerText.isEmpty,
                  let incorrectAnswersText = cell.incorrectAnswersTextField.text,
                  !incorrectAnswersText.isEmpty else {
                displayAlert(message: "Invalid quiz data")
                return
            }
            
            let updatedQuestion = Question(question: questionText, correctAnswer: correctAnswerText, incorrectAnswers: incorrectAnswersText.components(separatedBy: ","))
            updatedQuestions.append(updatedQuestion)
        }
        
        let updatedQuiz = Quiz(quizId: quizId, userId: userId, title: updatedTitle, privacy: updatedPrivacy, questions: updatedQuestions)
        
        if quizManager.updateQuiz(updatedQuiz: updatedQuiz) {
            displayAlertWithCompletion(message: "Quiz updated successfully") { [weak self] in
                self?.navigateBackToPage()
            }
        } else {
            displayAlert(message: "Failed to update quiz")
        }
    }

    func navigateBackToPage() {
        if let navigationController = navigationController {
            for viewController in navigationController.viewControllers {
                if let quizMainMenuVC = viewController as? BaseTabBarController {
                    navigationController.popToViewController(quizMainMenuVC, animated: true)
                    return
                }
            }
        }
        
        // Default fallback action
        navigationController?.popViewController(animated: true)
    }

    
    
    func displayAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func displayAlertWithCompletion(message: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion()
        }))
        present(alert, animated: true, completion: nil)
    }
}
