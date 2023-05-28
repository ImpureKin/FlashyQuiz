//
//  ModifyQuizViewController.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 25/5/2023.
//

import UIKit

class ModifyQuizViewController: UIViewController {
    
    var loggedUser: User?
    var quiz: Quiz?
    var modifiedQuiz: Quiz?
    var selectedQuestionIndex: Int?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var privacySwitch: UISwitch!
    @IBOutlet weak var modifyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        guard let quiz = quiz else { return }
        
        // Create a deep copy of the quiz object
        modifiedQuiz = Quiz(userId: quiz.userId, title: quiz.title, privacy: quiz.privacy, questions: quiz.questions)
        
        titleTextField.text = modifiedQuiz?.title
        privacySwitch.isOn = modifiedQuiz?.privacy == "Public"
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
            guard var modifiedQuiz = modifiedQuiz else { return }
            
            if let newTitle = titleTextField.text {
                modifiedQuiz.title = newTitle
                modifiedQuiz.privacy = privacySwitch.isOn ? "Public" : "Private"
                
                // Call the modifyQuiz function in the data storage manager to update the quiz
                DataStorageManager().modifyQuiz(modifiedQuiz)
                
                // Pop the view controller to go back to the previous screen
                navigationController?.popViewController(animated: true)
            }
        }
    }

extension ModifyQuizViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modifiedQuiz?.questions.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ModificationCell", for: indexPath)
        
        guard let question = modifiedQuiz?.questions[indexPath.row] else {
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
