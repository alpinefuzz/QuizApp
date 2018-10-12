//
//  ResultViewController.swift
//  QuizCWC
//
//  Created by Vitaliy Kurbatov on 09/02/2018.
//  Copyright © 2018 Vitaliy Kurbatov. All rights reserved.
//

import UIKit

protocol ResultViewControllerProtocol {
    func resultViewDismissed()
}

class ResultViewController: UIViewController {
    
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    
    var delegate:ResultViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        dialogView.layer.cornerRadius = 10
        dimView.alpha = 0
        resultLabel.alpha = 0
        feedbackLabel.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {

        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
            self.dimView.alpha = 1
        }, completion: nil)
    }
    
    func setPopup(withTitle:String, withMessage:String, withAction:String) {
        
        resultLabel.text = withTitle
        feedbackLabel.text = withMessage
        dismissButton.setTitle(withAction, for: .normal)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            
            self.resultLabel.alpha = 1
            self.feedbackLabel.alpha = 1
            
        }, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func dismissTapped(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.dimView.alpha = 0
        }) { (completed) in
            
            self.dismiss(animated: true, completion: {
                
                self.resultLabel.text = ""
                self.feedbackLabel.text = ""
                
            })
            self.delegate?.resultViewDismissed()
        }
    }
}
