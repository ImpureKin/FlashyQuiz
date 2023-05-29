//
//  ModifyFlashCardViewController.swift
//  FlashyQuiz
//
//  Created by Ashton Chan on 29/5/2023.
//

import UIKit

class ModifyFlashCardViewController: UIViewController {
    
    var loggedUser: User?
    var flashcard: Flashcard?
    var modifiedFlashCard: Flashcard?
    var selectedQuestionIndex: Int?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var privacySwitch: UISwitch!
    @IBOutlet weak var modifyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        guard let flashcard = flashcard else { return }
        
        // Create a deep copy of the quiz object
        modifiedFlashCard = Flashcard(userId: flashcard.userId, title: flashcard.title, privacy: flashcard.privacy, questions: flashcard.questions)
        
        titleTextField.text = modifiedFlashCard?.title
        privacySwitch.isOn = modifiedQuiz?.privacy == "Public"
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
            guard var modifiedFlashCard = modifiedFlashCard else { return }
            
            if let newTitle = titleTextField.text {
                modifiedFlashCard.title = newTitle
                modifiedFlashCard.privacy = privacySwitch.isOn ? "Public" : "Private"
                
                // Call the modifyQuiz function in the data storage manager to update the quiz
                DataStorageManager().modifyFlasCard(modifiedFlashCard)
                
                // Pop the view controller to go back to the previous screen
                navigationController?.popViewController(animated: true)
            }
        }
    }

extension ModifyFlashCardViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modifiedFlashCard?.questions.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ModificationCell", for: indexPath)
        
        guard let question = modifiedFlashCard?.questions[indexPath.row] else {
            return cell
        }
        
        cell.textLabel?.text = question.question
        
        if let selectedQuestionIndex = selectedQuestionIndex, indexPath.row == selectedQuestionIndex {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedQuestionIndex = indexPath.row
        tableView.reloadData()
        
        // Load the question details when a question is selected
        setupUI()
    }
}
