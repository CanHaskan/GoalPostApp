//
//  GoalsVC.swift
//  GoalPostApp
//
//  Created by Can Haskan on 11.11.2025.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class GoalsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var goals: [Goal] = []
    var lastDeletedGoal: Goal?
    var lastDeletedGoalIndex: IndexPath?
    var deleteWorkItem: DispatchWorkItem?
    
    private var undoView: UIView?


    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCoreDataObjects()
        tableView.reloadData()
    }
    
    func fetchCoreDataObjects() {
        self.fetch { complete in
            if complete {
                if goals.count >= 1 {
                    tableView.isHidden = false
                } else {
                    tableView.isHidden = true
                }
            }
        }
    }
    @IBAction func addGoalBtnWasPressed(_ sender: Any) {
        guard let createGoalVC = storyboard?.instantiateViewController(withIdentifier: "CreateGoalVC") else {return}
        presentDetail(createGoalVC)
    }
}

extension GoalsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell") as? GoalCell else {return UITableViewCell()}
        let goal = goals[indexPath.row]
        
        cell.configureCell(goal: goal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { rowAction, indexPath in
            self.lastDeletedGoal = self.goals[indexPath.row]
            self.lastDeletedGoalIndex = indexPath
            
            self.goals.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            self.showUndoSnackbar()
            self.scheduleDeleteOfLastDeletedGoal(after: 3.5)

        }
        
        let addAction = UITableViewRowAction(style: .normal, title: "ADD") { rowAction, indexPath in
            self.setProgress(atIndexPath: indexPath)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        deleteAction.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        addAction.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        return [deleteAction, addAction]
    }
    

    func scheduleDeleteOfLastDeletedGoal(after seconds: TimeInterval) {
        deleteWorkItem?.cancel()

        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.permanentlyDeleteLastDeletedGoal()
        }
        deleteWorkItem = workItem

        DispatchQueue.global().asyncAfter(deadline: .now() + seconds, execute: workItem)
    }

    @objc func undoDeleteTapped() {
        deleteWorkItem?.cancel()
        deleteWorkItem = nil

        guard let restoredGoal = lastDeletedGoal, let restoredIndexPath = lastDeletedGoalIndex else {
            hideUndoSnackbar()
            return
        }

        goals.insert(restoredGoal, at: restoredIndexPath.row)

        DispatchQueue.main.async {
            self.tableView.insertRows(at: [restoredIndexPath], with: .automatic)
            self.hideUndoSnackbar()
        }

        lastDeletedGoal = nil
        lastDeletedGoalIndex = nil
    }

    private func permanentlyDeleteLastDeletedGoal() {
        guard let goalToDelete = lastDeletedGoal else {
            DispatchQueue.main.async {
                self.hideUndoSnackbar()
            }
            return
        }

        guard let managedContext = appDelegate?.persistentContainer.viewContext else {
            DispatchQueue.main.async {
                self.hideUndoSnackbar()
            }
            return
        }

        managedContext.delete(goalToDelete)

        do {
            try managedContext.save()
        } catch {
            debugPrint("Could not permanently delete: \(error.localizedDescription)")
        }

        lastDeletedGoal = nil
        lastDeletedGoalIndex = nil
        deleteWorkItem = nil

        DispatchQueue.main.async {
            self.hideUndoSnackbar()
        }
    }
    
    func showUndoSnackbar() {
        hideUndoSnackbar()

        guard let parent = self.view else { return }

        let height: CGFloat = 56
        let horizontalPadding: CGFloat = 12
        let bottomPadding: CGFloat = 20 + parent.safeAreaInsets.bottom

        let snackbar = UIView(frame: CGRect(x: horizontalPadding,
                                            y: parent.bounds.height + height,
                                            width: parent.bounds.width - horizontalPadding * 2,
                                            height: height))
        snackbar.backgroundColor = UIColor(red: 1.0, green: 0.35, blue: 0.35, alpha: 1.0)
        snackbar.layer.cornerRadius = 12
        snackbar.clipsToBounds = true

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let goalName = lastDeletedGoal?.goalDescription ?? "Goal"
        label.text = "\(goalName) deleted."
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        snackbar.addSubview(label)

        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("UNDO", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(undoDeleteTapped), for: .touchUpInside)
        snackbar.addSubview(button)

        parent.addSubview(snackbar)
        self.undoView = snackbar

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: snackbar.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: snackbar.centerYAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: button.leadingAnchor, constant: -8),

            button.trailingAnchor.constraint(equalTo: snackbar.trailingAnchor, constant: -12),
            button.centerYAnchor.constraint(equalTo: snackbar.centerYAnchor)
        ])

        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                snackbar.frame.origin.y = parent.bounds.height - height - bottomPadding
            }
        }
    }

    func hideUndoSnackbar() {
        guard let snackbar = self.undoView, let parent = self.view else { return }
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.18, animations: {
                snackbar.frame.origin.y = parent.bounds.height + snackbar.frame.height
            }, completion: { _ in
                snackbar.removeFromSuperview()
            })
        }
        self.undoView = nil
    }


}

extension GoalsVC {
    
    func setProgress(atIndexPath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        let chosenGoal = goals[indexPath.row]
        
        if chosenGoal.goalProgress < chosenGoal.goalCompletionValue {
            chosenGoal.goalProgress = chosenGoal.goalProgress + 1
        } else {
            return
        }
        
        do {
            try managedContext.save()
        } catch {
            debugPrint("Could not set progress: \(error.localizedDescription)")
        }

    }
    
    func removeGoal(atIndexPath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        managedContext.delete(goals[indexPath.row])
        
        do{
            try managedContext.save()
        } catch {
            debugPrint("Could not remove: \(error.localizedDescription)")
        }
    }
    
    
    func fetch(completion: (_ complete: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        
        do {
            goals = try managedContext.fetch(fetchRequest)
            completion(true)
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(false)
        }
    }
}



