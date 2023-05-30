//
//  EditDeckViewController.swift
//  FlashyQuiz
//
//  Created by Ashton Chan on 25/5/2023.
//

import UIKit

class EditFlashCardViewController: UIViewController {
    
    var loggedUser: User?
    var flashcardGroup: FlashcardGroup?
    var modifiedFlashcardGroup: FlashcardGroup?
    var selectedQuestionIndex: Int?
    var isComingFromExplorePage: Bool = false
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var privacySwitch: UISwitch!
    @IBOutlet weak var modifyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        guard let flashcardGroup = flashcardGroup else { return }
        
        // Create a deep copy of the flashcardGroup object
        modifiedFlashcardGroup = FlashcardGroup(title: flashcardGroup.title, privacy: flashcardGroup.privacy, flashcards: flashcardGroup.flashcards)
        
        titleTextField.text = modifiedFlashcardGroup?.title
        privacySwitch.isOn = modifiedFlashcardGroup?.privacy == "public"
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard var modifiedFlashcardGroup = modifiedFlashcardGroup else { return }
        
        if let newTitle = titleTextField.text {
            modifiedFlashcardGroup.title = newTitle
            modifiedFlashcardGroup.privacy = privacySwitch.isOn ? "public" : "private"
            
            // Call the modifyFlashcardGroup function in the data storage manager to update the flashcard group
            // DataStorageManager().modifyFlashcardGroup(modifiedFlashcardGroup)
            
            // Pop the view controller to go back to the previous screen
            navigationController?.popViewController(animated: true)
        }
    }
}


extension EditFlashCardViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modifiedFlashcardGroup?.flashcards.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ModificationCell", for: indexPath)
        
        guard let flashcard = modifiedFlashcardGroup?.flashcards[indexPath.row] else {
            return cell
        }
        
        cell.textLabel?.text = flashcard.question
        
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
        
        // Load the flashcard details when a flashcard is selected
        setupUI()
    }
}
