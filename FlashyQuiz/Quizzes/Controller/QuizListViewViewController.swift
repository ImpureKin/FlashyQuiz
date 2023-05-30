//
//  QuizListViewViewController.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 20/5/2023.
//

import UIKit

class QuizListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var userTable: UITableView! // tableView for the user's quizzes
    @IBOutlet weak var userLabel: UILabel! // Label used to display the user's username

    var quizzes: [Quiz] = [] // array to store the quizzes retrived
    var quizManager = QuizManager() // database queries for quiz
    var shouldPerformSegue = true // var bool that helps manage when to perform a the segue
    var userId: Int = 0 // var to store the users id
    var username: String = "" // var to store the current users username

    override func viewDidLoad() {
        super.viewDidLoad()
        userLabel.text = "\(username)'s Quizzes" // sets label to display username

        let nib = UINib(nibName: "QuizCell", bundle: nil) // sets an NIB for the QuizCell
        userTable.register(nib, forCellReuseIdentifier: "QuizCell") // registers the NIB for QuizCell

        // stating we are using our own custom data
        userTable.dataSource = self
        userTable.delegate = self

        fetchQuizzes() //function that fetches the quizzes from the database
    }
    // FUNCTION: fetch quizzes from the database
    func fetchQuizzes() {
        // calls function from quiz manager using the userID as an input
        if let quizzes = quizManager.getUserQuizzes(userIdInput: 1) {

            // Fetches quizzes for the data source for your table view
            self.quizzes = quizzes

            // Reloads the table view data
            userTable.reloadData()

        } else {
            // If there are not quizzes found an alert will pop up saying there is none for this user
            let alert = UIAlertController(title: "Quizzes Not Found", message: "Quizzes with this user cannot be found. Please create a quiz.", preferredStyle: .alert)

            // Add an action to dismiss the alert and navigate back
            let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in

                // Navigates back to the previous view controller
                self?.navigationController?.popViewController(animated: true) // will navigate back to the navigation controller
            }
            alert.addAction(okAction)

            // presents the alert
            present(alert, animated: true, completion: nil)
        }
    }
    // number of rows will be generated for how many quizzes there are
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }

    // sets up the cells to follow the custom cell called QuizCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizCell", for: indexPath) as! QuizCell

        // for each row it will have a quiz title and questionLabel
        let quiz = quizzes[indexPath.row]
        cell.quizTitle.text = quiz.title
        cell.questionLabel.text = "\(quiz.questions.count) questions"

        // returns the cell
        return cell
    }

    // Function that allows when teh quiz is selected that you are able to select the row which will allow you to segue to the next screen
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let quiz = quizzes[indexPath.row] // grabs the quiz from the row you touched

        // perform segue if the conditions are met
        if navigationController?.topViewController == self {
            performSegue(withIdentifier: "goToQuizDetails", sender: quiz)
        }
    }

    // Segue which drages the selected quiz into the next view controller into quiz details
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToQuizDetails",
            let VC = segue.destination as? QuizDetailsViewController, //n ext view controller
            let quiz = sender as? Quiz {
            VC.quiz = quiz // quiz being bassed through
            VC.userId = userId
        }
    }
}

