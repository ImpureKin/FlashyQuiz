//
//  CreateFlashCardViewController.swift
//  FlashyQuiz
//
//  Created by Ashton Chan on 25/5/2023.
//

import UIKit

class CreateFlashCardViewController: UIViewController {

    @IBOutlet weak var flashCardTitleLabel: UILabel!
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var answerTextField: UITextField!
    
    var userId: Int = 0
    var selectedTitle: String = ""
    var selectedPrivacy: String = ""
    var flashcards: [Flashcard] = []
    let flashcardManager = FlashcardManager()
    
    //var dataManager = DataStorageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flashCardTitleLabel.text = selectedTitle
    }
    
    func clearInputFields() {
        questionTextField.text = ""
        answerTextField.text = ""
    }
    
    @IBAction func addFlashcardButtonPressed(_ sender: Any) {
        guard let questionText = questionTextField.text, !questionText.isEmpty,
              let answerText = answerTextField.text, !answerText.isEmpty else {
            // Display error alert
            UIAlertController.showAlert(title: "Error", message: "Please fill in all the fields.", in: self)
            return
        }
        
        let newFlashcard = Flashcard(question: questionText, answer: answerText)
        flashcards.append(newFlashcard)
        
        clearInputFields()
    }
    
    @IBAction func saveFlashCardButtonPressed(_ sender: Any) {
        guard !flashcards.isEmpty else {
            // Display error alert
            UIAlertController.showAlert(title: "Error", message: "Please add at least one flashcard.", in: self)
            return
        }
        
        let flashcardGroup = FlashcardGroup(title: selectedTitle, privacy: selectedPrivacy, flashcards: flashcards)
        saveFlashCardGroupToDatabase(flashcardGroup)
    }
    
    func saveFlashCardGroupToDatabase(_ flashcardGroup: FlashcardGroup) {
        // Save the flashcardGroup to the database
        // You can use the provided flashcardGroup object and the database connection
        
        // Example code to print the flashcardGroup details
        print("Saving flashcardGroup with title: \(flashcardGroup.title)")
        print("FlashcardGroup privacy: \(flashcardGroup.privacy)")
        print("Flashcards:")
        for flashcard in flashcardGroup.flashcards {
            print("Question: \(flashcard.question)")
            print("Answer: \(flashcard.answer)")
        }
        
        // Save the flashcardGroup to the data manager
        let flashcardGroup = FlashcardGroup(title: flashcardGroup.title, privacy: flashcardGroup.privacy, flashcards: [])
        flashcardManager.addFlashcardGroup(flashcardGroup: flashcardGroup, userId: userId)
        
        let alert = UIAlertController(title: "Flashcard Deck Saved", message: "The flashcard deck has been saved successfully.", preferredStyle: .alert)
        
        // Add an action to dismiss the view controller
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            // Navigate back to a certain page
            self?.navigateBackToPage()
        }
        alert.addAction(okAction)
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }
    
    func navigateBackToPage() {
        if let navigationController = navigationController {
            for viewController in navigationController.viewControllers {
                if let flashCardMainVC = viewController as? FlashCardMainMenuViewController {
                    navigationController.popToViewController(flashCardMainVC, animated: true)
                    return
                }
            }
        }
    }
}

extension UIAlertController {
    static func showAlert(title: String, message: String, in viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}

