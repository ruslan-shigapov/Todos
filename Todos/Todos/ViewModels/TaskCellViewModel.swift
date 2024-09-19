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
        task.title ?? Constants.newTask
    }
    
    var description: String {
        task.specification ?? Constants.createdByMe
    }
    
    var isClosed: Bool {
        task.closed
    }
    
    var duration: String {
        task.duration ?? "" // TODO: "01:00 PM - 03:00 PM" such format
    }
    
    init(task: Task) {
        self.task = task
    }
}
