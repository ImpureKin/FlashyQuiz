//
//  FlashCardDetailsViewController.swift
//  FlashyQuiz
//
//  Created by Ashton Chan on 29/5/2023.
//

import UIKit

class FlashCardDetailsViewController: UIViewController {
    
    var flashCardGroup: FlashcardGroup?
    
    @IBOutlet weak var flashCardTitleLabel: UILabel!
    @IBOutlet weak var flashCardTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flashCardTableView.delegate = self
        flashCardTableView.dataSource = self
        setupUI()
    }
    
    func setupUI() {
        if let flashCardGroup = flashCardGroup {
            flashCardTitleLabel.text = flashCardGroup.title
        }
    }
}

extension FlashCardDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flashCardGroup?.flashcards.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlashCardCell", for: indexPath)
        
        if let flashCard = flashCardGroup?.flashcards[indexPath.row] {
            cell.textLabel?.text = flashCard.question
        }
        
        return cell
    }
}
