//
//  Task.swift
//

import UIKit

// The Task model
struct Task: Codable {

    // The task's title
    var title: String

    // An optional note
    var note: String?

    // The due date by which the task should be completed
    var dueDate: Date

    // Initialize a new task
    // `note` and `dueDate` properties have default values provided if none are passed into the init by the caller.
    init(title: String, note: String? = nil, dueDate: Date = Date()) {
        self.title = title
        self.note = note
        self.dueDate = dueDate
    }

    // A boolean to determine if the task has been completed. Defaults to `false`
    var isComplete: Bool = false {

        // Any time a task is completed, update the completedDate accordingly.
        didSet {
            if isComplete {
                // The task has just been marked complete, set the completed date to "right now".
                completedDate = Date()
            } else {
                completedDate = nil
            }
        }
    }

    // The date the task was completed
    // private(set) means this property can only be set from within this struct, but read from anywhere (i.e. public)
    private(set) var completedDate: Date?

    // The date the task was created
    // This property is set as the current date whenever the task is initially created.
    let createdDate: Date = Date()

    // An id (Universal Unique Identifier) used to identify a task.
    let id: String = UUID().uuidString
}

// MARK: - Task + UserDefaults
extension Task {


    // Given an array of tasks, encodes them to data and saves to UserDefaults.
    static func save(_ tasks: [Task]) {

        // TODO: Save the array of tasks
        
        // 1.
        let defaults = UserDefaults.standard
        // 2.
        let encodedData = try! JSONEncoder().encode(tasks)
        // 3.
        defaults.set(encodedData, forKey: "tasks")
        
        
        
    }
    
    

    // Retrieve an array of saved tasks from UserDefaults.
    static func getTasks() -> [Task] {
        
        // TODO: Get the array of saved tasks from UserDefaults

        // 1.
        let defaults = UserDefaults.standard
        // 2.
        if let data = defaults.data(forKey: "tasks") {
            // 3.
            let decodedTasks = try! JSONDecoder().decode([Task].self, from: data)
            // 4.
            return decodedTasks
        } else {
            // 5.
            return []
        }
    }

    // Add a new task or update an existing task with the current task.
    func save() {

        // TODO: Save the current task
        
        // 1. Get the array of saved tasks
        var tasks = Task.getTasks()
        
        // 2. Check if the current task already exists in the array
        if let existingIndex = tasks.firstIndex(where: { $0.id == self.id }) {
            // 2.1 If it exists, remove the existing task
            tasks.remove(at: existingIndex)
            // 2.2 Insert the updated task in place of the removed one
            tasks.insert(self, at: existingIndex)
        } else {
            // 3. If no matching task exists, add the new task to the end
            tasks.append(self)
        }
        
        // 4. Save the updated tasks array to UserDefaults
        Task.save(tasks)
        
    }
}
