//
//  TaskCellViewModel.swift
//  Todos
//
//  Created by Ruslan Shigapov on 18.09.2024.
//

import Foundation

protocol TaskCellViewModelProtocol {
    var title: String { get }
    var description: String { get }
    var isClosed: Bool { get }
    var duration: String { get }
    func markTask(completion: @escaping () -> Void)
}

final class TaskCellViewModel: TaskCellViewModelProtocol {
    
    private let task: Task
    
    var title: String {
        guard let title = task.title, !title.isEmpty else {
            return Constants.newTask
        }
        return title
    }
    
    var description: String {
        guard let specification = task.specification,
              !specification.isEmpty else {
            return Constants.byMyself
        }
        return specification
    }
    
    var isClosed: Bool {
        task.isClosed
    }
    
    var duration: String {
        task.duration ?? "" 
    }
    
    init(task: Task) {
        self.task = task
    }
    
    func markTask(completion: @escaping () -> Void) {
        StorageManager.shared.updateMark(of: task) {
            completion()
        }
    }
}
