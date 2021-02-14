//
//  task_list.swift
//  ToDoList
//
//  Created by Jacob Baca on 9/12/20.
//  Copyright © 2020 Baca Tech. All rights reserved.
//

import Foundation
import os.log

class Task: NSObject, NSCoding, Codable{
   // Will be usign Codable in future
    
    
    // MARK: Properties
    var id:Int;
    var title:String;
    //var description:String;
    var completed:Bool;
    var due_date: Date;
    var creation_date:Date;
    var is_child_task:Bool;
    var parent_id:Int
    
    static let baseURL = "http://0.0.0.0:5000"
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("tasks")
    
    // Mark: Types
    struct PropertyKey{
        static let title = "title"
        static let desc = "desc"
    }
    
    // MARK: Initialization
    init(i:Int, t:String, c:Bool, dd:Date, cd: Date, ict:Bool, pi:Int){
        id = i;
        title = t;
        //description = d;
        completed = c;
        due_date = dd;
        creation_date = cd;
        is_child_task = ict;
        parent_id = pi;
    }
    
    //    init(){
    //        id = -1;
    //        title = "";
    //        description = "";
    //        completed = false;
    //        creationg_date = Date();
    //        is_child_task = false;
    //        parent_id = -1;
    //    }
    
    // MARK: NSCoding
    func encode(with coder: NSCoder) {
        coder.encode(title, forKey: PropertyKey.title)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String else{
            os_log("Unable to decode the name for a Task object.", log: OSLog.default, type: .debug)
            return nil
        }
        self.init(i:0, t:title, c: false, dd: Date(), cd: Date(), ict:false, pi:0)
    }
    

}

struct TaskData: Decodable{
    let data: [Task]
}

