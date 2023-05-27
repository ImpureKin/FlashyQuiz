//
//  QuizGameViewController.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 20/5/2023.
//

import UIKit

class QuizGameViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet var answerButtons: [UIButton]!
    
    var loggedUser: User?
    var quiz: Quiz?
    var currentQuestionIndex = 0
    var answeredQuestions: [Int] = []
    var correctAnswers = 0
    var timer: Timer?
    var remainingTime = 11
    var isQuestionAnswered = false
    var isAlertShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    
    func setupUI() {
        guard let quiz = quiz else { return }
        
        titleLabel.text = quiz.title
        
        let unansweredQuestions = quiz.questions.indices.filter { !answeredQuestions.contains($0) }
        
        if unansweredQuestions.isEmpty {
            showResults()
        } else {
            let randomQuestionIndex = unansweredQuestions.randomElement()!
            currentQuestionIndex = randomQuestionIndex
            
            let question = quiz.questions[randomQuestionIndex]
            questionLabel.text = question.question
            
            let allAnswers = question.incorrectAnswers + [question.correctAnswer]
            let randomizedAnswers = allAnswers.shuffled()
            
            for (index, button) in answerButtons.enumerated() {
                button.setTitle(randomizedAnswers[index], for: .normal)
            }
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        remainingTime -= 1
        timerButton.setTitle("\(remainingTime)", for: .normal)
        
        if remainingTime == 0 {
            timer?.invalidate()
            
            if !isQuestionAnswered && !isAlertShown {
                isQuestionAnswered = true
                showAlert(message: "Time's up!")
                showNextQuestion()
            }
        }
    }
    
    @IBAction func answerButtonTapped(_ sender: UIButton) {
        guard let quiz = quiz else { return }
        let question = quiz.questions[currentQuestionIndex]
        
        // Disable all answer buttons
        for button in answerButtons {
            button.isEnabled = false
        }
        
        if sender.currentTitle == question.correctAnswer {
            correctAnswers += 1
            sender.backgroundColor = UIColor.green
            showAlert(message: "Correct Answer")
        } else {
            sender.backgroundColor = UIColor.red
            
            // Show the correct answer
            for button in answerButtons {
                if button.currentTitle == question.correctAnswer {
                    button.backgroundColor = UIColor.green
                    break
                }
            }
            
            showAlert(message: "Incorrect Answer. The correct answer is \(question.correctAnswer)")
        }
        
        timer?.invalidate()
        isQuestionAnswered = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.resetAnswerButtons()
            self.showNextQuestion()
        }
    }
    
    func resetAnswerButtons() {
        for button in answerButtons {
            button.backgroundColor = UIColor.white
            button.isEnabled = true
        }
    }
    
    func showNextQuestion() {
            answeredQuestions.append(currentQuestionIndex)
            
            let unansweredQuestions = quiz?.questions.indices.filter { !answeredQuestions.contains($0) }
            
            if let randomQuestionIndex = unansweredQuestions?.randomElement() {
                currentQuestionIndex = randomQuestionIndex
                remainingTime = 11
                isQuestionAnswered = false
                setupUI()
                startTimer()
            } else {
                showResults()
            }
        }
    
    func showResults() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let quizResultsVC = storyboard.instantiateViewController(withIdentifier: "QuizResultsViewController") as? QuizResultsViewController else {
            return
        }
        
        quizResultsVC.correctAnswers = correctAnswers
        quizResultsVC.totalQuestions = quiz?.questions.count ?? 0
        
        navigationController?.pushViewController(quizResultsVC, animated: true)
    }
    
    func showAlert(message: String) {
        isAlertShown = true //
        
        let alert = UIAlertController(title: "Quiz", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.isAlertShown = false
        }))
        present(alert, animated: true, completion: nil)
    }
}
