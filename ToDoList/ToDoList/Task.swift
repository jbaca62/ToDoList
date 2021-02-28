//
//  task_list.swift
//  ToDoList
//
//  Created by Jacob Baca on 9/12/20.
//  Copyright © 2020 Baca Tech. All rights reserved.
//

import Foundation
import os.log

class Task: Codable{
    
    
    // MARK: Properties
    var id:Int;
    var title:String;
    var description:String?;
    var completed:Bool;
    var due_date: String?;
    var creation_date:String?;
    var is_child_task:Bool;
    var parent_task:Int
    
    static let baseURL = "http://0.0.0.0:5000"
    
    
    // MARK: Initialization
    init(i:Int, t:String, c:Bool, dd:String, cd: String, ict:Bool, pi:Int){
        id = i;
        title = t;
        completed = c;
        due_date = dd;
        creation_date = cd;
        is_child_task = ict;
        parent_task = pi;
    }
    

}

struct TaskData: Decodable{
    let data: [Task]
}

