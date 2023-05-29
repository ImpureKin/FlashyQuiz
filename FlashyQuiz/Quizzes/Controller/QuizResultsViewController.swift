//
//  QuizResultsViewController.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 20/5/2023.
//

import UIKit

class QuizResultsViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel! // Label to store the results of the quiz

    var correctAnswers = 0 // var to store the number correct answers the user has supplied
    var totalQuestions = 0 // var to store the total number of questions answered

    override func viewDidLoad() {
        super.viewDidLoad()

        // hides the navigation back as it is not needed on this screen
        navigationItem.hidesBackButton = true

        // resultLabel displayed the stored var's data of how the user went
        resultLabel!.text = "\(correctAnswers)/\(totalQuestions)"
    }

    // when the user presses the main menu button to navigates back to the main menu
    @IBAction func mainMenuButton(_ sender: UIButton) {
        navigateBackToPage()
    }

    // Takes the user back to the begining for the user to choose for the main menu new options
    func navigateBackToPage() {
        if let navigationController = navigationController {
            for viewController in navigationController.viewControllers {
                if let quizMainMenuVC = viewController as? BaseTabBarController { //needs to go back to this view controller as it stores the user's data
                    navigationController.popToViewController(quizMainMenuVC, animated: true)
                    return
                }
            }
        }

        // Fallback action
        navigationController?.popViewController(animated: true)
    }

}

