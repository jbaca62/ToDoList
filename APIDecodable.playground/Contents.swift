import UIKit

class Task: Codable{
    
    
    
    // MARK: Properties
    var id:Int;
    var title:String;
    //var description:String;
    var completed:Bool;
    var due_date: Date?;
    var creation_date:String;
    var is_child_task:Bool;
    var parent_id:Int
    
    static let baseURL = "http://10.95.22.4:5000"
    
    
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("tasks")
    
    // Mark: Types
    struct PropertyKey{
        static let title = "title"
        static let desc = "desc"
    }
    
    // MARK: Initialization
    init(i:Int, t:String, c:Bool, dd:Date, cd: String, ict:Bool, pi:Int){
        id = i;
        title = t;
        //description = d;
        completed = c;
        due_date = dd;
        creation_date = cd;
        is_child_task = ict;
        parent_id = pi;
    }
    
    // MARK: NSCoding
    func encode(with coder: NSCoder) {
        coder.encode(title, forKey: PropertyKey.title)
        //coder.encode(description, forKey: PropertyKey.desc)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String else{
            return nil
        }
        //let desc = aDecoder.decodeObject(forKey: PropertyKey.desc) as? String
        self.init(i:0, t:title, c: false, dd: Date(), cd: "", ict:false, pi:0)
        
        
    }
    

}

struct TaskData: Codable{
    let data: [Task]
}

let urlAsString = Task.baseURL + "/list"

let url = URL(string: urlAsString)!

let urlSession = URLSession.shared

var tasks: [Task] = []

func getTasks(){
    
    let jsonQuery = urlSession.dataTask(with: url, completionHandler: { data, response, error -> Void in
        if (error != nil) {
            print(error!.localizedDescription)
        }

        
        let decoder = JSONDecoder()
        let jsonResult = try! decoder.decode(TaskData.self, from: data!)
        
        
        let taskItems = jsonResult.data
        
        tasks = taskItems
        print("In getTasks")
        printTasks(tasks: tasks)

    })
    jsonQuery.resume()

}

private func addTaskDB(t:Task, completionHandler: @escaping ([Task])-> Void){
    let encoder = JSONEncoder()
    let json = (try? encoder.encode(t))!
    
    let urlAsString = Task.baseURL + "/add"
    let url = URL(string: urlAsString)!
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = json
    
    let urlSession = URLSession.shared
    
    var returned_task:Task? = nil
    
    let postTask = urlSession.dataTask(with: request){ (data, response, error) in
        if let error = error{
            print(error)
        }
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200{
            let decoder = JSONDecoder()
            returned_task = try! decoder.decode(Task.self, from: data!)
            tasks += [returned_task!]
        }
        completionHandler(tasks)
    }
    postTask.resume()
}

func printTasks(tasks: [Task]){
    if tasks.isEmpty{
        print("Task Array Empty")
    }
    else{
        for t in tasks{
            print(String(t.id) + "\t" + String(t.title))
        }
    }
}

func printTask(task: Task){
    print(String(task.id) + "\t" + String(task.title))
}

getTasks()
let new_task = Task(i: -1, t: "Test 3", c: false, dd: Date(), cd: "", ict: false, pi: 0)
addTaskDB(t: new_task, completionHandler: printTasks)
