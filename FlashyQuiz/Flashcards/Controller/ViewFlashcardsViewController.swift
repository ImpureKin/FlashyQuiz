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
    @IBOutlet weak var aLabel: UILabel!
    @IBOutlet weak var qLabel: UILabel!
    
    var questions: [String] = []
    var answers: [String] = []
    var clickCounter = 0
    
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
        // Hide all labels
        qLabel.isHidden = true
        questionLabel.isHidden = true
        aLabel.isHidden = true
        answerLabel.isHidden = true
        clickCounter += 1
        UIView.transition(with: cardView, duration: 0.5, options: .transitionFlipFromRight, animations: {
            
        }, completion: { _ in
            // Show labels after the transition ends
            self.qLabel.isHidden = self.clickCounter % 2 != 0
            self.questionLabel.isHidden = self.clickCounter % 2 != 0
            self.aLabel.isHidden = self.clickCounter % 2 == 0
            self.answerLabel.isHidden = self.clickCounter % 2 == 0
        })
    }


    
    @objc func nextQuestion() {
        clickCounter = 0
        currentIndex += 1
        if currentIndex >= questions.count {
            currentIndex = questions.count - 1
            return
        }
        animateCard(direction: .transitionCurlUp)
        updateCard()
    }
    
    @objc func previousQuestion() {
        clickCounter = 0
        currentIndex -= 1
        if currentIndex < 0 {
            currentIndex = 0
            return
        }
        animateCard(direction: .transitionCurlDown)
        updateCard()
    }
    
    func animateCard(direction: UIView.AnimationOptions) {
        // Hide all labels
        qLabel.alpha = 0.0
        questionLabel.alpha = 0.0
        aLabel.alpha = 0.0
        answerLabel.alpha = 0.0
        
        UIView.transition(with: cardView, duration: 0.5, options: [direction, .curveEaseInOut], animations: {
            // Empty animation block
        }, completion: { _ in
            // Show labels after the transition ends
            self.qLabel.alpha = 1.0
            self.questionLabel.alpha = 1.0
            self.aLabel.alpha = 1.0
            self.answerLabel.alpha = 1.0
        })
    }
    
    func updateCard() {

        qLabel.text = "Question: \(currentIndex+1)"
        aLabel.text = "Answer:  \(currentIndex+1)"
        questionLabel.text = questions[currentIndex]
        answerLabel.text = answers[currentIndex]
        
        questionLabel.isHidden = false
        qLabel.isHidden = false
        answerLabel.isHidden = true
        aLabel.isHidden = true
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
