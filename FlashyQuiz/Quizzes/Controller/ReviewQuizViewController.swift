//
//  ReviewQuizViewController.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 22/5/2023.
//

import UIKit

class ReviewQuizViewController: UIViewController, UITableViewDataSource,  UITableViewDelegate {
    
    @IBOutlet weak var quizTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var quizTitle: String = ""
    var questions: [Question] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        quizTitleLabel.text = quizTitle
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "QuestionCell")
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}
