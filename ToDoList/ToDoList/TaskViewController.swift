//
//  TaskViewController.swift
//  ToDoList
//
//  Created by Jacob Baca on 9/20/20.
//  Copyright © 2020 Baca Tech. All rights reserved.
//

import UIKit
import os.log

class TaskViewController: UIViewController, UITextFieldDelegate {
    // MARK: Properties

    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var DescriptionField: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var completeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        titleField.delegate = self
        if let task = task{
            navigationItem.title = task.title
            titleField.text = task.title
            DescriptionField.text = task.description
            completeButton.isEnabled = !(task.completed)
        }
        updateCompleteButtonState()
        updateSaveButtonState()
    }
    

    // MARK: - Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddTaskMode = presentingViewController is UINavigationController
        if isPresentingInAddTaskMode{
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The TaskViewController is not inside a navigation controller.")
        }
        
    }
    
    var task:Task?;
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let title = titleField.text ?? ""
        let description = DescriptionField.text ?? ""
        task  = Task(i: 0, t: title, c: false, dd: Date(), cd: "", ict: false, pi: 0);
        task?.title = title;
        task?.completed = !(completeButton.isEnabled)
        
    }
    @IBAction func completeButtonTouch(_ sender: Any) {
        completeButton.isEnabled = false
        updateCompleteButtonState()
    }
    
    // MARK: UITestFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    func textFieldDidEndEditing(_ textField: UITextField){
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    // MARK: Private Methods
    private func updateSaveButtonState(){
        let text = titleField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    private func updateCompleteButtonState(){
        let state = completeButton.isEnabled
        if state{
            completeButton.alpha = 1
        }
        else{
            completeButton.alpha = 0.5
        }
    }

}
