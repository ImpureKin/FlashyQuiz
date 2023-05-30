//
//  ReviewQuizViewController.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 22/5/2023.
//

import UIKit

class ReviewQuizViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var quizTitleLabel: UILabel! // Label to store the users quiz
    @IBOutlet weak var tableView: UITableView! // TableView to display the questions

    var userId: Int = 0 // Used to Store userID
    var quizTitle: String = "" // Used to store the title
    var privacy: String = "" // Stores the privacy string
    var questions: [Question] = [] // Question array based on the Question structure
    var quizManager = QuizManager() // variable that calls the quiz manager class

    override func viewDidLoad() {
        super.viewDidLoad()
        quizTitleLabel.text = quizTitle // Changes the label to display the quiz tittle

        let nib = UINib(nibName: "QuestionCell", bundle: nil) // sets an NIB for the QuizCell
        tableView.register(nib, forCellReuseIdentifier: "QuestionCell") // registers the nib to the QuestionCell

        // Stating we are using our own custom data
        tableView.delegate = self
        tableView.dataSource = self
    }

    // function used to count the number of rows for the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count // returns the number of questions for the table view
    }

    // sets up the cells to follow the custom cell called QuestionCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionCell

        // call the questions and sets to the labels from the data
        let question = questions[indexPath.row]
        cell.question.text = question.question
        cell.correctAnswerLabel.text = question.correctAnswer

        // Set the incorrect answers to be displayed on a new line
        let incorrectAnswers = question.incorrectAnswers.joined(separator: "\n")
        cell.incorrectAnswerTextView.text = incorrectAnswers

        // adds delete button to the cell and add a target for the deleted question object function
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteQuestion(_:)), for: .touchUpInside)

        return cell // returns cell
    }

    // Function to allow questions to be deleted from the array
    @objc func deleteQuestion(_ sender: UIButton) {
        // gets the cell and index path of the question that the user is selecting to be deleted
        guard let cell = sender.superview?.superview as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell) else {
            return
        }

        // assigns number of questions to question count
        let questionCount = questions.count
        if questionCount <= 1 { // if this count is less than one
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
            self?.questions.remove(at: indexPath.row)

            // Reloads the table view to reflect the changes made
            self?.tableView.reloadData()
        }
        alert.addAction(deleteAction) // adds the alert action

        // present the alerts
        present(alert, animated: true, completion: nil)
    }

    // IBA function that when pressed will save the quiz to the database
    @IBAction func submitButton(_ sender: UIButton) {
        saveQuizToDatabase() // calls on the function
    }

    // Function to save to database
    func saveQuizToDatabase() {
        // sets up a quiz use the correct init supplied in Quiz
        let quiz = Quiz(title: quizTitle, privacy: privacy, questions: questions)

        // uses func add quiz to add to database
        if quizManager.addQuiz(quiz: quiz, userId: userId) {
            print("SUCCESSFULLY ADDED QUIZ.") // if added will display in the console

            // creates the alert with the title and message
            let alert = UIAlertController(title: "Quiz Saved", message: "The quiz has been saved successfully.", preferredStyle: .alert)

            // adds an action to go back to the quiz main menu
            let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                self?.navigateBackToPage() // calls this function to navigate to main menu for quiz
            }
            alert.addAction(okAction) // adds alert action

            present(alert, animated: true, completion: nil) // presents the alert

        } else { // if add was not successful

            print("ERROR: QUIZ NOT ADDED.") // if not added will display in the console
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
}
