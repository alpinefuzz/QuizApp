//
//  ViewController.swift
//  QuizCWC
//
//  Created by Vitaliy Kurbatov on 02/02/2018.
//  Copyright © 2018 Vitaliy Kurbatov. All rights reserved.
//



import UIKit

class ViewController: UIViewController, QuizProtocol, UITableViewDataSource, UITableViewDelegate, ResultViewControllerProtocol {
    
    @IBOutlet weak var stackViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var rootSackView: UIStackView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var model = QuizModel()
    var questions = [Question]()
    var questionIndex = 0
    var numCorrect = 0
    var resultVC:ResultViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultVC = storyboard?.instantiateViewController(withIdentifier: "ResultVC") as? ResultViewController
        resultVC?.delegate = self
        resultVC?.modalPresentationStyle = .currentContext
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        model.delegate = self
        model.getQuestions()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    func displayQuestion() {
        
        guard questionIndex < questions.count else {
            print("Error. index out of bounds")
            return
        }
        questionLabel.text = questions[questionIndex].question!
        tableView.reloadData()
        
        slideInQuestion()
    }
    
    
    func slideInQuestion() {
        rootSackView.alpha = 0
        stackViewLeadingConstraint.constant = 300
        stackViewTrailingConstraint.constant = -300
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            
            self.rootSackView.alpha = 1
            self.stackViewLeadingConstraint.constant = 0
            self.stackViewTrailingConstraint.constant = 0
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    func slideOutQuestion() {
        rootSackView.alpha = 1
        stackViewLeadingConstraint.constant = 0
        stackViewTrailingConstraint.constant = 0
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseIn, animations: {
            
            self.rootSackView.alpha = 0
            self.stackViewLeadingConstraint.constant = -300
            self.stackViewTrailingConstraint.constant = 300
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    //    Protocol methods
    func questionsRetrieved(questions: [Question]) {
        
        self.questions = questions
        let qIndex = StateManager.retrieveValue(key: StateManager.questionIndexKey) as? Int
       
        if qIndex != nil && qIndex! < questions.count {
            questionIndex = qIndex!
            numCorrect = StateManager.retrieveValue(key: StateManager.numCorrectKey) as! Int
        }
        displayQuestion()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard questions.count > 0 && questions[questionIndex].answers != nil else {
            return 0
        }
        return questions[questionIndex].answers!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath)
        let label = cell.viewWithTag(1) as! UILabel
        label.text = questions[questionIndex].answers![indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard questionIndex < questions.count else {
            return
        }
        
        var title:String = ""
        let message:String = questions[questionIndex].feedback!
        let action:String = "Next"
        
        if questions[questionIndex].correctAnswerIndex! ==
            indexPath.row {
            
            numCorrect += 1
            title = "Correct!"
        } else {
            title = "Wrong!"
        }
        
      slideOutQuestion()
        
        if resultVC != nil {
         
            resultVC?.modalPresentationStyle = .overCurrentContext
            
            present(resultVC!, animated: true, completion: {                
               self.resultVC!.setPopup(withTitle: title, withMessage: message, withAction: action)
            })
            
        }
        
        questionIndex += 1
        StateManager.saveState(numCorrect: numCorrect, questionIndex: questionIndex)
    }
    
    func resultViewDismissed() {
        
        if questionIndex == questions.count {
            
            if resultVC != nil {
                
                present(resultVC!, animated: true, completion: {
                    self.resultVC?.setPopup(withTitle: "Summary", withMessage: "You Got " + String(self.numCorrect) + " out of " + String(self.questions.count) +
                        " correct.", withAction: "Restart")
                })
            }
            
            questionIndex += 1
            StateManager.clearState()
        }
        else if questionIndex > questions.count {
            
            numCorrect = 0
            questionIndex = 0
            displayQuestion()
        }
            else {
            displayQuestion()
        }
    }
}

