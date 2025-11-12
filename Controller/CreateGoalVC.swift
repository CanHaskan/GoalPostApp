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
    @IBOutlet weak var nextBtn: UIButton!
    
    var goalType: GoalType = .shortTerm
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextBtn.bindToKeyboard()
        shorTermBtn.setSelectedColor()
        longTermBtn.setDeselectedColor()
    }

    @IBAction func nextBtnWasPressed(_ sender: Any) {
    }
    
    @IBAction func shortTermBtnWasPressed(_ sender: Any) {
        goalType = .shortTerm
        shorTermBtn.setSelectedColor()
        longTermBtn.setDeselectedColor()
    }
    
    @IBAction func longTermBtnWasPressed(_ sender: Any) {
        goalType = .longTerm
        longTermBtn.setSelectedColor()
        shorTermBtn.setDeselectedColor()
    }
    
    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismissDetail()
    }
    
    
    
}
