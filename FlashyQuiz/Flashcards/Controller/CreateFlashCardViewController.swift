//
//  CreateFlashCardViewController.swift
//  FlashyQuiz
//
//  Created by Ashton Chan on 25/5/2023.
//

import Foundation
import UIKit

class CreateFlashcardViewController: UIViewController {
    
    var viewModel: FlashcardViewModel!
    
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var answerTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func createFlashcardButtonPressed(_ sender: UIButton) {
        guard let question = questionTextField.text, let answer = answerTextField.text else {
            return
        }
        
        viewModel.addFlashcard(question: question, answer: answer)
        
        questionTextField.text = ""
        answerTextField.text = ""
    }
    
    @IBAction func completeAndSaveButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Save Deck", message: "Enter a name for the deck", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Deck Name"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let deckName = alertController.textFields?.first?.text else {
                return
            }
            
            self?.viewModel.createFlashcardDeck(withName: deckName)
            self?.dismiss(animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
