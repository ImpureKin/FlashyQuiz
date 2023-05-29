//
//  ViewFlashcardsViewController.swift
//  FlashyQuiz
//
//  Created by Ashton Chan on 25/5/2023.
//

import UIKit

class ViewFlashcardsViewController: UIViewController {
    var flashCardGroup: FlashcardGroup?
    var currentIndex = 0
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var flashCardTitleLabel: UILabel!
    
    var questions: [String] = []
    var answers: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateCard()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(flipCard))
        cardView.addGestureRecognizer(tapGestureRecognizer)
        
        let swipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(nextQuestion))
        swipeLeftGestureRecognizer.direction = .left
        cardView.addGestureRecognizer(swipeLeftGestureRecognizer)
        
        let swipeRightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(previousQuestion))
        swipeRightGestureRecognizer.direction = .right
        cardView.addGestureRecognizer(swipeRightGestureRecognizer)
    }
    
    @IBAction func mainMenu(_ sender: Any) {
        navigateBackToPage()
    }
    
    @objc func flipCard() {
        UIView.transition(with: cardView, duration: 0.5, options: .transitionFlipFromRight, animations: {
            self.answerLabel.isHidden = !self.answerLabel.isHidden
            self.questionLabel.isHidden = !self.questionLabel.isHidden
        })
    }
    
    @objc func nextQuestion() {
        currentIndex += 1
        if currentIndex >= questions.count {
            currentIndex = questions.count - 1
            return
        }
        animateCard(direction: .transitionCurlUp)
        updateCard()
    }
    
    @objc func previousQuestion() {
        currentIndex -= 1
        if currentIndex < 0 {
            currentIndex = 0
            return
        }
        animateCard(direction: .transitionCurlDown)
        updateCard()
    }
    
    func animateCard(direction: UIView.AnimationOptions) {
        UIView.transition(with: cardView, duration: 0.5, options: [direction, .curveEaseInOut], animations: nil, completion: nil)
    }
    
    func updateCard() {
        questionLabel.text = questions[currentIndex]
        answerLabel.text = answers[currentIndex]
        questionLabel.isHidden = false
        answerLabel.isHidden = true
    }
    
    func setupUI() {
        if let flashCardGroup = flashCardGroup {
            flashCardTitleLabel.text = flashCardGroup.title
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
    }
}
