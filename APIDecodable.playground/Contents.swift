import UIKit

class Task: Decodable{
    
    
    
    // MARK: Properties
    var id:Int;
    var title:String;
    //var description:String;
    var completed:Bool;
    var due_date: Date?;
    var creation_date:String;
    var is_child_task:Bool;
    var parent_id:Int
    
    
    
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

struct TaskData: Decodable{
    let data: [Task]
}

let urlAsString = "http://172.20.10.4:5000/list"

let url = URL(string: urlAsString)!

let urlSession = URLSession.shared

func getTasks(){
    let jsonQuery = urlSession.dataTask(with: url, completionHandler: { data, response, error -> Void in
        if (error != nil) {
            print(error!.localizedDescription)
        }
        var err: NSError?
        print(type(of: data!))
        print(data!)
        
        let decoder = JSONDecoder()
        let jsonResult = try! decoder.decode(TaskData.self, from: data!)
        
        //var jsonResult = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
        
        
        print(type(of: jsonResult))
        
        var taskItems = jsonResult.data
        
        print(type(of: taskItems[0]));
        print(taskItems.count);
        
        for i in 0...(taskItems.count)-1
        {
        let y = taskItems[i]
            print(y.completed)
        }
        
        
    })
    jsonQuery.resume()
}

DispatchQueue.main.async(execute: {
    getTasks()
})
