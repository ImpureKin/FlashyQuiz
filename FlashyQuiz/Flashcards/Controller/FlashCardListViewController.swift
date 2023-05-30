//
//  FlashCardListViewController.swift
//  FlashyQuiz
//
//  Created by Ashton Chan on 29/5/2023.
//

import UIKit

class FlashCardListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var flashCardTable: UITableView!
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var button: UIButton!
    var flashCardGroups: [FlashcardGroup] = []
        let flashcardManager = FlashcardManager()
        var shouldPerformSegue = true
        var userId: Int = 0
        var username: String = ""
            
        override func viewDidLoad() {
            super.viewDidLoad()
            button.isEnabled = false
            let nib = UINib(nibName: "FlashCardCell", bundle: nil)
            
            userLabel.text = "\(username)'s Flash Cards"
            
            flashCardTable.register(nib, forCellReuseIdentifier: "FlashCardCell")
            print("\(userId)")
            flashCardTable.dataSource = self
            flashCardTable.delegate = self
            
            fetchFlashCardGroups()
        }
            
        func fetchFlashCardGroups() {
            flashCardGroups = flashcardManager.getUserFlashcardGroups(userIdInput: userId)!
            flashCardTable.reloadData()
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return flashCardGroups.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FlashCardCell", for: indexPath) as! FlashCardCell
            
            let flashCardGroup = flashCardGroups[indexPath.row]
            cell.flashCardTitle.text = flashCardGroup.title
            cell.termLabel.text = "\(flashCardGroup.flashcards.count) Cards"
            
            return cell
        }
                
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
            let flashCardGroup = flashCardGroups[indexPath.row]
            
            if navigationController?.topViewController == self {
                performSegue(withIdentifier: "goToFlashCardDetails", sender: flashCardGroup)
            }
        }

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "goToFlashCardDetails",
               let destinationVC = segue.destination as? FlashCardDetailsViewController,
               let flashCardGroup = sender as? FlashcardGroup {
                destinationVC.flashcardGroup = flashCardGroup
            }
        }
    }

