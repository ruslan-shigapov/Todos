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
    
    func saveTasks(_ tasks: [TaskResponse]) {
        tasks.forEach {
            let task = Task(context: viewContext)
            task.id = Int16($0.id)
            task.title = $0.todo
            task.specification = Constants.fromNetwork
            task.isClosed = $0.completed
        }
        saveContext()
    }
    
    func createTask(
        id: Int,
        title: String?,
        specification: String?,
        startTime: Date?,
        endTime: Date?,
        completion: @escaping () -> Void
    ) {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            let task = Task(context: viewContext)
            task.id = Int16(id)
            task.title = title
            task.specification = specification
            task.isClosed = false
            task.startTime = startTime
            task.endTime = endTime
            saveContext()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            completion()
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
    
    func updateMark(of task: Task, completion: @escaping () -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            task.isClosed.toggle()
            saveContext()
        }
        DispatchQueue.main.async {
            completion()
        }
    }
    
    func update(
        _ task: Task,
        title: String?,
        specification: String?,
        isClosed: Bool,
        startTime: Date?,
        endTime: Date?,
        completion: @escaping () -> Void
    ) {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            task.title = title
            task.specification = specification
            task.isClosed = isClosed
            task.startTime = startTime
            task.endTime = endTime
            saveContext()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            completion()
        }
    }
    
    func delete(_ task: Task, completion: @escaping () -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            viewContext.delete(task)
            saveContext()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            completion()
        }
    }
}
