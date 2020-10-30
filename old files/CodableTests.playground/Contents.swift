import UIKit

class Task: Decodable{
    let id: Int
    let title: String
    
}

struct TaskData: Decodable{
    let data: [Task]
}

let JSON = """
{"data":
    [
        {"id": 1,
        "title": "Task 1"},
        {"id": 2,
        "title": "Task 2"}
    ]
}
"""

let jsonData = JSON.data(using: .utf8)!


let decoder = JSONDecoder()
let jsonResult = try! decoder.decode(TaskData.self, from: jsonData)

print(type(of: jsonResult))
print(jsonResult)

var task1 = jsonResult.data[0]
var task2 = jsonResult.data[1]

print(task1)
print(task1.title)



