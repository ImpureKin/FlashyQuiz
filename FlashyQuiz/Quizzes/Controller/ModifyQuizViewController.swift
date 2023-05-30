//
//  ModifyQuizViewController.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 25/5/2023.
//

import UIKit

class ModifyQuizViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var titleTextField: UITextField! // Textfield used to update quiz title
    @IBOutlet weak var privacySwitch: UISwitch! // Switch to update the privacy
    @IBOutlet weak var modifyTableView: UITableView! // Set up of modify TableView Controller

    var quiz: Quiz? // variable used to store the quiz being passed through the segue
    var userId: Int = 0 // stores the userId passed through the segue
    var quizManager = QuizManager() // variable that calls the quiz manager class

    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.text = quiz?.title // displays the title from the quiz in the textfeild
        privacySwitch.isOn = quiz?.privacy == "Public"

        let nib = UINib(nibName: "ModifyCell", bundle: nil) // sets an NIB for the ModifyCell
        modifyTableView.register(nib, forCellReuseIdentifier: "ModifyCell") // registers the nib to the ModifyCell

        // Stating we are using our own custom data
        modifyTableView.delegate = self
        modifyTableView.dataSource = self
    }

    // function used to count the number of rows for the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quiz!.questions.count // return the number of questions fro the table view
    }

    // sets up the cells to follow the custom cell called ModifyCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ModifyCell", for: indexPath) as! ModifyCell

        // sets up the questions textfield
        if let question = quiz?.questions[indexPath.row] {
            cell.questionTextField.text = question.question
            cell.correctAnswerTextField.text = question.correctAnswer
            cell.incorrectAnswersTextField.text = question.incorrectAnswers.joined(separator: ", ")
        }

        // adds delete button to the cell and add a target for the deleted question object function
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteQuestion(_:)), for: .touchUpInside)

        // targets for the textfields to keep track  of updates to the texfields
        cell.questionTextField.addTarget(self, action: #selector(questionTextFieldChanged(_:)), for: .editingChanged)
        cell.correctAnswerTextField.addTarget(self, action: #selector(correctAnswerTextFieldChanged(_:)), for: .editingChanged)
        cell.incorrectAnswersTextField.addTarget(self, action: #selector(incorrectAnswersTextFieldChanged(_:)), for: .editingChanged)

        return cell // returns cell
    }

    // Function to allow questions to be deleted from the array
    @objc func deleteQuestion(_ sender: UIButton) {
        // gets the cell and index path of the question that the user is selecting to be deleted
        guard let cell = sender.superview?.superview as? UITableViewCell,
            let indexPath = modifyTableView.indexPath(for: cell),
            let questionCount = quiz?.questions.count else {
            return
        }

        // if last question being is trying to be deleted by the user
        if questionCount <= 1 {
            // will display an alert saying the user that the user can not delete the last quiz
            let alert = UIAlertController(title: "Cannot Delete Question",
                                          message: "You cannot delete the last question.",
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }

        // This will ask the user if they want to delete the question or not
        let alert = UIAlertController(title: "Delete Question",
                                      message: "Are you sure you want to delete this question?",
                                      preferredStyle: .alert)

        // adds a cancel button to allow the user to go back

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        // adds a delete action that when pressed
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in

            // removes the question from the corresponding index
            self?.quiz?.questions.remove(at: indexPath.row)

            // reloads the table view to reflect the changes made
            self?.modifyTableView.reloadData()
        }

        // adds the aler action
        alert.addAction(deleteAction)

        // present the alert
        present(alert, animated: true, completion: nil)
    }

    // checks if the question text field is changed
    @objc func questionTextFieldChanged(_ textField: UITextField) {
        guard let index = textField.superview?.tag else { return }
        quiz?.questions[index].question = textField.text ?? ""
    }

    // checks if the correct answer text field is changed
    @objc func correctAnswerTextFieldChanged(_ textField: UITextField) {
        guard let index = textField.superview?.tag else { return }
        quiz?.questions[index].correctAnswer = textField.text ?? ""
    }

    // checks if the incorrect answer text field is changed
    @objc func incorrectAnswersTextFieldChanged(_ textField: UITextField) {
        guard let index = textField.superview?.tag else { return }
        let answers = textField.text?.components(separatedBy: ", ") ?? []
        quiz?.questions[index].incorrectAnswers = answers
    }

    //Current quiz is deleted when button is tapped
    @IBAction func deleteQuizButtonTapped(_ sender: UIButton) {
        // Create an alert when button is pressed
        let alert = UIAlertController(title: "Delete Quiz",
                                      message: "Are you sure you want to delete this quiz?",
                                      preferredStyle: .alert)

        // adds the cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        // Adds delete action
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let quiz = self?.quiz else { return } // gets the current quiz

            let isDeleted = self?.quizManager.deleteQuiz(quiz: quiz) ?? false // deletes the user using the quiz manager delete quiz function

            if isDeleted { // if quis was deleted, it will display a message
                self?.displayAlertWithCompletion(message: "Quiz deleted successfully") { [weak self] in
                    self?.navigateBackToPage() // calls this function to navigate to main menu for quiz
                }
            } else { //display alert if quiz was unable to be deleted
                self?.displayAlert(message: "Failed to delete quiz")
            }
        }
        alert.addAction(deleteAction) // adds alert action

        present(alert, animated: true, completion: nil) // presents the alert
    }

    // function that updates the quiz when the button is tapped
    @IBAction func updateQuizButtonTapped(_ sender: UIButton) {
        guard let quizId = quiz?.quizId, // gets quizId
        let updatedTitle = titleTextField.text, // gets quiz updated title
        !updatedTitle.isEmpty else { //if the update quiz is empty an alert would be displayed
            displayAlert(message: "Invalid quiz data")
            return
        }

        // gets the updated privacy value
        let updatedPrivacy = privacySwitch.isOn ? "Public" : "Private"

        var updatedQuestions: [Question] = [] //initalise quiz array

        // grabs data from the table which has the updated question fields from modify table cells
        for row in 0..<modifyTableView.numberOfRows(inSection: 0) {
            guard let cell = modifyTableView.cellForRow(at: IndexPath(row: row, section: 0)) as? ModifyCell,
                let questionText = cell.questionTextField.text,
                !questionText.isEmpty, // gets the update question text
            let correctAnswerText = cell.correctAnswerTextField.text,
                !correctAnswerText.isEmpty, // gets updated correct answer
            let incorrectAnswersText = cell.incorrectAnswersTextField.text, // gets incorrect answer array
            !incorrectAnswersText.isEmpty else { // if any are empty it will display alert
                displayAlert(message: "Invalid quiz data")
                return
            }

            // collecting the updated data of question using a certain init in question struct object
            let updatedQuestion = Question(question: questionText, correctAnswer: correctAnswerText, incorrectAnswers: incorrectAnswersText.components(separatedBy: ","))
            updatedQuestions.append(updatedQuestion)
        }

        // collecting the updated data of quiz using a certain init in quiz struct object
        let updatedQuiz = Quiz(quizId: quizId, title: updatedTitle, privacy: updatedPrivacy, questions: updatedQuestions)

        // updates quiz with the update quiz function from quiz manager using the updatequiz
        if quizManager.updateQuiz(updatedQuiz: updatedQuiz, userId: userId) {
            // if sucessful alert will be displayed saying this message
            displayAlertWithCompletion(message: "Quiz updated successfully") { [weak self] in
                self?.navigateBackToPage() // calls this function to navigate to main menu for quiz
            }
        } else {
            displayAlert(message: "Failed to update quiz") // will display this alert if unsucessful
        }
    }

    // navigates back to the Quiz Main Menu using the Base Tab Bar
    func navigateBackToPage() {
        if let navigationController = navigationController {
            for viewController in navigationController.viewControllers {
                if let quizMainMenuVC = viewController as? BaseTabBarController {
                    navigationController.popToViewController(quizMainMenuVC, animated: true)
                    return
                }
            }
        }
        navigationController?.popViewController(animated: true)
    }

    // displays alert with a given message
    func displayAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // displays an alert with a message and an exexution to be completed wbe ok is being tapped
    func displayAlertWithCompletion(message: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion()
        }))
        present(alert, animated: true, completion: nil)
    }
}
