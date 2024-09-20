//
//  StorageManager.swift
//  Todos
//
//  Created by Ruslan Shigapov on 16.09.2024.
//

import CoreData

enum StorageError: Error {
    case unknown(_ error: Error)
}

final class StorageManager {
    
    static let shared = StorageManager()
    
    // MARK: Core Data stack
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Todos")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Core Data loading error: \(error)")
            }
        }
        return container
    }()
    
    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private init() {}
    
    private func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                viewContext.rollback()
            }
        }
    }
}

// MARK: - Task CRUD
extension StorageManager {
    
    func save(_ tasks: [TaskResponse]) {
        tasks.forEach {
            let task = Task(context: viewContext)
            task.title = $0.todo
            task.specification = Constants.fromNetwork
            task.closed = $0.completed
            task.duration = ""
        }
        saveContext()
    }
    
    func createTask(
        title: String,
        specification: String,
        duration: String,
        completion: @escaping (Task) -> Void
    ) {
        let task = Task(context: viewContext)
        task.title = title
        task.specification = specification
        task.closed = false
        task.duration = duration
        saveContext()
        // TODO: check threads
        DispatchQueue.main.async {
            completion(task)
        }
    }
    
    func fetchTasks(
        completion: @escaping (Result<[Task], StorageError>) -> Void
    ) {
        let fetchRequest = Task.fetchRequest()
        do {
            let tasks = try viewContext.fetch(fetchRequest)
            completion(.success(tasks))
        } catch {
            completion(.failure(.unknown(error)))
        }
    }
    
    func update(_ task: Task, completion: @escaping () -> Void) {
        task.closed.toggle()
        saveContext()
        completion()
    }
    
    func delete(_ task: Task, completion: @escaping () -> Void) {
        
    }
}
