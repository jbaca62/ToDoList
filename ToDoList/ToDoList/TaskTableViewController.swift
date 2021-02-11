//
//  TaskTableViewController.swift
//  ToDoList
//
//  Created by Jacob Baca on 9/16/20.
//  Copyright © 2020 Baca Tech. All rights reserved.
//

import UIKit
import os.log

class TaskTableViewController: UITableViewController {

    //Mark: Properties
    var tasks = [Task]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        loadTasksDB()

        //      if let savedTasks = loadTasksDB(){
//            tasks += savedTasks
//        }
//        else{
//            loadSampleTasks();
//        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TaskTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TaskTableViewCell

        let task = tasks[indexPath.row]
        
        cell.titleField.text = task.title

        return cell
    }


    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? ""){
        case "AddTask":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            guard let taskDetailViewController = segue.destination as? TaskViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            taskDetailViewController.addState = true;
        case "ShowDetail":
            guard let taskDetailViewController = segue.destination as? TaskViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
             
            guard let selectedTaskCell = sender as? TaskTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
             
            guard let indexPath = tableView.indexPath(for: selectedTaskCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
             
            taskDetailViewController.addState = false
            let selectedTask = tasks[indexPath.row]
            taskDetailViewController.task = selectedTask
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")

        }
    }
    
    @IBAction func unwindToTaskList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? TaskViewController {
            let task = sourceViewController.task
            if !(sourceViewController.addState!){
                // Update existing task
                let selectedIndexPath = tableView.indexPathForSelectedRow!
                updateTaskDB(t:task)
                tasks[selectedIndexPath.row] = task
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else{
                // Add a new task
                addTaskDB(t:task)
                let newIndexPath = IndexPath(row: tasks.count, section: 0);
                tasks.append(task)
                tableView.insertRows(at:[newIndexPath], with: .automatic);
            }
        }
    }
    
    //Mark: Actions
    
    
    //MARK: Private Methods
    
    
//    private func saveTasks(){
//        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(tasks, toFile: Task.ArchiveURL.path)
//        //insert command to save tasks to database here
//        if isSuccessfulSave {
//            os_log("Tasks successfully saved.", log: OSLog.default, type: .debug)
//        } else {
//            os_log("Failed to save tasks...", log: OSLog.default, type: .error)
//        }
//    }
//
//    private func loadTasks() -> [Task]?{
//        //insert command to load tasks from database here
//        return NSKeyedUnarchiver.unarchiveObject(withFile: Task.ArchiveURL.path) as? [Task]
//    }
    
    private func loadTasksDB(){
        let urlAsString = Task.baseURL + "/list"
        let url = URL(string: urlAsString)!

        let urlSession = URLSession.shared
        
        
        let jsonQuery = urlSession.dataTask(with: url, completionHandler: { (data, response, error) in
            if (error != nil) {
                print(error!.localizedDescription)
                return
            }
            
            let decoder = JSONDecoder()
            let jsonResult = try! decoder.decode(TaskData.self, from: data!)
            
            let taskItems = jsonResult.data
            DispatchQueue.main.async {
                self.tasks += taskItems
                self.tableView.reloadData()
            }
        })
        jsonQuery.resume()
    }
    
    private func addTaskDB(t:Task){
        let urlAsString = Task.baseURL + "/add"
        let url = URL(string: urlAsString)!
        
        let encoder = JSONEncoder()
        let json = (try? encoder.encode(t))!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json
        
        let urlSession = URLSession.shared
        
        var returned_task:Task?
        
        let postTask = urlSession.dataTask(with: request){ (data, response, error) in
            if (error != nil) {
                print(error!.localizedDescription)
                return
            }
            let decoder = JSONDecoder()
            returned_task = try! decoder.decode(Task.self, from: data!)
                
        }
        postTask.resume()
    }
    
    private func updateTaskDB(t:Task){
        let encoder = JSONEncoder()
        let json = (try? encoder.encode(t))!
        
        let urlAsString = Task.baseURL + "/add"
        let url = URL(string: urlAsString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json
        
        let urlSession = URLSession.shared
        
        let postTask = urlSession.dataTask(with: request){ (data, response, error) in
            if let error = error{
                print(error)
            }
            if let data = data, let dataString = String(data: data, encoding: .utf8){
                print("Response data string: \n \(dataString)")
            }
            
        }
        postTask.resume()
    }

}
