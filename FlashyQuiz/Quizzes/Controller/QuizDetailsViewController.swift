//
//  QuizDetailsViewController.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 25/5/2023.
//


import UIKit

class QuizDetailsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var quizTitle: UILabel! // Label for quiz title 
    @IBOutlet weak var detailTable: UITableView! // connects the detail table view
    
    var quiz: Quiz? // variable used to store the quiz being passed through the segue
    var userId: Int = 0  // stores the userId passed through the segue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quizTitle.text = quiz?.title // displays the title from the quiz in the label
        
        let nib = UINib(nibName: "DetailCell", bundle: nil) // sets an NIB for the QuizCell
        detailTable.register(nib, forCellReuseIdentifier: "DetailCell") // registers the nib to the DetailCell
        
        // Stating we are using our own custom data
        detailTable.delegate = self
        detailTable.dataSource = self
    }
    
    // function used to count the number of rows for the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        quiz!.questions.count // return the number of questions fro the table view 
    }
    
    // sets up the cells to follow the custom cell called DetailCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailCell
        
        // call the questions and sets to the labels from the data
        let question = quiz!.questions[indexPath.row]
        cell.questionLabel.text = question.question
        cell.correctAnswerLabel.text = question.correctAnswer
        
        return cell // return cell
    }
    
    //function to prepare for a segue using a switch 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "goToModifyQuiz": // if the segue identify equals this string a segue will occur
                if let modifyQuizVC = segue.destination as? ModifyQuizViewController {
                    modifyQuizVC.quiz = quiz // passes value through
                    modifyQuizVC.userId = userId // passes value through
                }
            case "goToPlayQuiz": // if the segue identify equals this string a segue will occur
                if let playQuizVC = segue.destination as? QuizGameViewController {
                    playQuizVC.quiz = quiz // passes value through
                }
            default:
                break
            }
        }
    }
    
}
