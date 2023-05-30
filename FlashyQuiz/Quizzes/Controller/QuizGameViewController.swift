//
//  QuizGameViewController.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 20/5/2023.
//

import UIKit

class QuizGameViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel! // label to store the quizzes title
    @IBOutlet weak var questionLabel: UILabel! // Label to store the quizzes question
    @IBOutlet weak var timerButton: UIButton! // buton that will be used as the countdown
    @IBOutlet var answerButtons: [UIButton]! // collection of answer buttons

    var quiz: Quiz? // variable used to store the quiz being passed through the segue
    var currentQuestionIndex = 0 // count of questions currently needing to be answered
    var answeredQuestions: [Int] = [] // stores the array of the questions answered
    var correctAnswers = 0 // int that stores the number of correct answers the user has done
    var timer: Timer? // intialises timer for the quiz
    var remainingTime = 11 // time used for the timer. Was made 11 seconds to allow users more time to answer
    var isQuestionAnswered = false // bool used to track if a question has been answered or not
    var isAlertShown = false // bool to tack whether the alert is shown or not

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true // hides back button
        
        startGame() // starts start game function when the view controller first loads
        startTimer() //starts timer fucniton when the view controller first loads
    }

    // overide function will make the view controller disappear of the screen and invadiate the timer
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }

    // function to set up the quiz game
    func startGame() {
        guard let quiz = quiz else { return } // checks if quiz is avaliable

        titleLabel.text = quiz.title // adds the title to the quiz

        // Finds the indices of unanswered questions
        let unansweredQuestions = quiz.questions.indices.filter { !answeredQuestions.contains($0) } //

        // checks if there is any unanswered questions
        if unansweredQuestions.isEmpty {
            showResults() //shows results if there are no unanswered questions

        } else {
            // chooses a random unanswered question
            let randomQuestionIndex = unansweredQuestions.randomElement()!
            currentQuestionIndex = randomQuestionIndex

            // chooses a random question
            let question = quiz.questions[randomQuestionIndex]
            questionLabel.text = question.question

            // combinds the incorrect and correct answers and shuffles them
            let allAnswers = question.incorrectAnswers + [question.correctAnswer]
            let randomizedAnswers = allAnswers.shuffled()

            // assugn random answers to random answer buttons
            for (index, button) in answerButtons.enumerated() {
                button.setTitle(randomizedAnswers[index], for: .normal)
            }
        }
    }

    // Sets up the timer for the quiz
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    // How timer is incremented and what happens when the title is invalidate
    @objc func updateTimer() {
        remainingTime -= 1 // decreasing by one
        timerButton.setTitle("\(remainingTime)", for: .normal) // set title as the remaining time

        // when the timer is 0 it will invalidate the timer
        if remainingTime == 0 {
            timer?.invalidate()

            // Checks if the question has not been answered and an alert is not already shown
            if !isQuestionAnswered && !isAlertShown {
                isQuestionAnswered = true // mark the current quetsion as answered
                showQuizAlert(message: "Time's up!") //shows alert
                showNextQuestion() //goes to the
            }
        }
    }

    // Function relating to any of the collection of Answer Buttons
    @IBAction func answerButtonTapped(_ sender: UIButton) {
        guard let quiz = quiz else { return } //checks if quiz is avalaible
        let question = quiz.questions[currentQuestionIndex] //retrives the current questions for the quiz

        // Disable all answer buttons
        for button in answerButtons {
            button.isEnabled = false
        }

        // the button tapped as the same title as the stored correct answer
        if sender.currentTitle == question.correctAnswer {
            correctAnswers += 1 // add one to the score
            sender.backgroundColor = UIColor.green // button will turn green to signify it is right
            showQuizAlert(message: "Correct Answer") // shows alert with the message
        } else {
            sender.backgroundColor = UIColor.red // if not the correct answer the button will be red

            // Shows the user the correct answer as well as the wrong anser
            for button in answerButtons {
                if button.currentTitle == question.correctAnswer {
                    button.backgroundColor = UIColor.green // the button that contained the correct answer will be green
                    break
                }
            }

            // An alert will be shown showing the correct answer
            showQuizAlert(message: "Incorrect Answer. The correct answer is \(question.correctAnswer)")
        }

        timer?.invalidate() // the timer is invalidated
        isQuestionAnswered = true // question will be marked as true
        
        // stalls the reset of the buttons by how many seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.resetAnswerButtons()

        }
    }

    // when the user is looking at the pop up message
    func resetAnswerButtons() {
        for button in answerButtons {
            button.backgroundColor = UIColor.white // the answer buttons background colour is set to right
            button.isEnabled = true // button is enabled
        }
    }

    // Function to show next question in currentQuestionIndex
    func showNextQuestion() {
        // adds the current question to the answered question array
        answeredQuestions.append(currentQuestionIndex)

        // fiters the questions incidues to check for any unanswered questions
        let unansweredQuestions = quiz?.questions.indices.filter { !answeredQuestions.contains($0) }

        // if there is any unaswered questions left, select a question at random
        if let randomQuestionIndex = unansweredQuestions?.randomElement() {
            currentQuestionIndex = randomQuestionIndex
            remainingTime = 11 // resets timer
            isQuestionAnswered = false // resets if question answered
            startGame() // starts game again
            startTimer() // sarts timer again
        } else {
            showResults() // if there was no questions left it performs a segue
        }
    }

    // Function that holds the segue to the quizresultviewcontroller
    func showResults() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // intialising storyboard
        guard let quizResultsVC = storyboard.instantiateViewController(withIdentifier: "QuizResultsViewController") as? QuizResultsViewController else {
            return
        }

        // Passes the variable correct answers and number of questions through to the results page
        quizResultsVC.correctAnswers = correctAnswers
        quizResultsVC.totalQuestions = quiz?.questions.count ?? 0

        navigationController?.pushViewController(quizResultsVC, animated: true)
    }

    // Function to show alert
    func showQuizAlert(message: String) {
        isAlertShown = true //show alert is set to true

        // Sets the title for each time the alert is called and action to only be OK
        let alert = UIAlertController(title: "Quiz", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.isAlertShown = false // alert is set to false
            self?.showNextQuestion() // shows the next question after the user is
        }))
        present(alert, animated: true, completion: nil) // Presents the alert
    }
}
