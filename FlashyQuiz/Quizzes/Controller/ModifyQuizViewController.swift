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
    var questions: [Question] = []
    var quiz: Quiz?
    var quizManager = QuizManager()

  
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
            modifiedQuiz = quiz
            
            if let selectedQuestionIndex = selectedQuestionIndex {
                // Retrieve the selected question from the modifiedQuiz's questions array
                let selectedQuestion = modifiedQuiz?.questions[selectedQuestionIndex]
                
                // Update the UI with the selected question's details
                guard let cell = modifyTableView.cellForRow(at: IndexPath(row: selectedQuestionIndex, section: 0)) as? ModifyCell else {
                    return
                }
                
                cell.questionTextField.text = selectedQuestion?.question
                cell.correctAnswerTextField.text = selectedQuestion?.correctAnswer
                cell.incorrectAnswersTextField.text = selectedQuestion?.incorrectAnswers.joined(separator: ", ")
            }
    }

    
    @IBAction func deleteQuizButton(_ sender: UIButton) {
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
                self?.deleteQuiz(quiz: quiz)
            }
        }
        alert.addAction(deleteAction)
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let updatedQuiz = createUpdatedQuiz() else { return }
        
        saveQuiz(updatedQuiz)
    }

    func createUpdatedQuiz() -> Quiz? {
        guard var modifiedQuiz = modifiedQuiz,
              var title = titleTextField.text else { return nil }
        
        modifiedQuiz.updateTitle(title)
        modifiedQuiz.updatePrivacy(privacySwitch.isOn ? "Public" : "Private")
        
        return modifiedQuiz
    }
    
    func deleteQuiz(quiz: Quiz) {
        // Delete the quiz using your database function
        let success = quizManager.deleteQuiz(quiz: quiz)
        
        if success {
            navigateBackToPage()
        } else {
            // Handle deletion failure
            print("Failed to delete quiz.")
        }
    }
    
    func saveQuiz(_ quiz: Quiz) {
        // Update the quiz using your database function
        let isSuccess = quizManager.updateQuiz(updatedQuiz: quiz)
        
        if isSuccess {
            navigateBackToPage()
        } else {
            // Handle update failure
            print("Failed to update quiz")
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
}

extension ModifyQuizViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modifiedQuiz?.questions.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ModifyCell", for: indexPath) as! ModifyCell
        
        let question = modifiedQuiz?.questions[indexPath.row]
        cell.questionTextField.text = question?.question
        cell.correctAnswerTextField.text = question?.correctAnswer
        cell.incorrectAnswersTextField.text = question?.incorrectAnswers.joined(separator: ", ")
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteQuestion(_:)), for: .touchUpInside)
        
        cell.questionTextField.addTarget(self, action: #selector(questionTextFieldChanged(_:)), for: .editingChanged)
        cell.correctAnswerTextField.addTarget(self, action: #selector(correctAnswerTextFieldChanged(_:)), for: .editingChanged)
        cell.incorrectAnswersTextField.addTarget(self, action: #selector(incorrectAnswersTextFieldChanged(_:)), for: .editingChanged)
        
        return cell
    }
    
    @objc func questionTextFieldChanged(_ textField: UITextField) {
        updateQuestion(at: textField.tag, questionField: textField)
    }
    
    @objc func correctAnswerTextFieldChanged(_ textField: UITextField) {
        updateQuestion(at: textField.tag, correctAnswerField: textField)
    }
    
    @objc func incorrectAnswersTextFieldChanged(_ textField: UITextField) {
        updateQuestion(at: textField.tag, incorrectAnswersField: textField)
    }
    
    private func updateQuestion(at index: Int, questionField: UITextField? = nil, correctAnswerField: UITextField? = nil, incorrectAnswersField: UITextField? = nil) {
        guard var modifiedQuiz = modifiedQuiz else { return }
        
        if let questionField = questionField {
            modifiedQuiz.questions[index].question = questionField.text ?? ""
        }
        
        if let correctAnswerField = correctAnswerField {
            modifiedQuiz.questions[index].correctAnswer = correctAnswerField.text ?? ""
        }
        
        if let incorrectAnswersField = incorrectAnswersField {
            modifiedQuiz.questions[index].incorrectAnswers = incorrectAnswersField.text?.components(separatedBy: ",") ?? []
        }
        
        self.modifiedQuiz = modifiedQuiz
    }
    
    @objc func deleteQuestion(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? UITableViewCell,
              let indexPath = modifyTableView.indexPath(for: cell) else {
            return
        }
        
        let question = modifiedQuiz?.questions[indexPath.row]
        
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
