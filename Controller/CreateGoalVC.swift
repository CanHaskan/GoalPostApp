//
//  CreateGoalVC.swift
//  GoalPostApp
//
//  Created by Can Haskan on 12.11.2025.
//

import UIKit

class CreateGoalVC: UIViewController {
    
    
    @IBOutlet weak var goalTextView: UITextView!
    @IBOutlet weak var shorTermBtn: UIButton!
    @IBOutlet weak var longTermBtn: UIButton!
    @IBOutlet weak var nextBt: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func nextBtnWasPressed(_ sender: Any) {
    }
    
    @IBAction func shortTermBtnWasPressed(_ sender: Any) {
    }
    
    @IBAction func longTermBtnWasPressed(_ sender: Any) {
    }
    
    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
