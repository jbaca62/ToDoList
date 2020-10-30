import UIKit


class Task: Decodable{
    
    
    
    // MARK: Properties
    var id:Int;
    var title:String;
    var description:String;
    var completed:Bool;
    var creation_date:Date;
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
    init(i:Int, t:String, d:String, c:Bool, cd: Date, ict:Bool, pi:Int){
        id = i;
        title = t;
        description = d;
        completed = c;
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
        coder.encode(description, forKey: PropertyKey.desc)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String else{
            return nil
        }
        let desc = aDecoder.decodeObject(forKey: PropertyKey.desc) as? String
        self.init(i:0, t:title, d: desc ?? "", c: false, cd: Date(), ict:false, pi:0)
        
        
    }
    

}

struct TaskData: Decodable{
    let data: [Task]
}


struct Article: Decodable {
    let author: String?
    let description: String?
    let publishedAt: String?
    let title: String?
    let url : URL?
    let urlToImage : URL?
    
}

struct news: Decodable {
 let articles: [Article]
}
    
DispatchQueue.main.async(execute: {
    getNews()
})



func getNews() {
    
   // you need ot register @ https://newsapi.org/ and get the API KEY, then put your API KEY in the url below
    
    let urlAsString = "http://172.20.10.4:5000/list"
    
    let url = URL(string: urlAsString)!
    
    let urlSession = URLSession.shared
    
    
    let jsonQuery = urlSession.dataTask(with: url, completionHandler: { data, response, error -> Void in
        if (error != nil) {
            print(error!.localizedDescription)
        }
        var err: NSError?
        print(type(of: data))
        print(data)
        
        let decoder = JSONDecoder()
        let jsonResult = try! decoder.decode(TaskData.self, from: data!)
        
        //var jsonResult = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
        
        if (err != nil) {
            print("JSON Error \(err!.localizedDescription)")
        }
        
        print(jsonResult)
        
        
        var taskItems = jsonResult.data
        
        print(taskItems);
        print(taskItems.count);
        
        for i in 0...(taskItems.count)-1
        {
        let y = taskItems[i]
            print(y.title)
        }
        
        
    })
    
    jsonQuery.resume()
    
}

