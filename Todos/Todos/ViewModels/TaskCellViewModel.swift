//
//  TaskCellViewModel.swift
//  Todos
//
//  Created by Ruslan Shigapov on 18.09.2024.
//

protocol TaskCellViewModelProtocol: AnyObject {
    var title: String { get }
    var description: String { get }
    var isClosed: Bool { get }
    var duration: String { get }
}

final class TaskCellViewModel: TaskCellViewModelProtocol {
    
    private let task: Task
    
    var title: String {
        task.todo
    }
    
    var description: String {
        "From Network"
    }
    
    var isClosed: Bool {
        task.completed
    }
    
    var duration: String {
        "01:00 PM - 03:00 PM"
    }
    
    init(task: Task) {
        self.task = task
    }
}
