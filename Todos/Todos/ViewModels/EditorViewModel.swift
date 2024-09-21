//
//  EditorViewModel.swift
//  Todos
//
//  Created by Ruslan Shigapov on 20.09.2024.
//

protocol EditorViewModelProtocol {
    var isNewTask: Bool { get }
    var navigationTitle: String { get }
    var title: String { get }
    var description: String { get }
    func saveTask(
        title: String?,
        specification: String?,
        startTime: String?,
        endTime: String?,
        completion: @escaping () -> Void
    )
    func deleteTask(completion: @escaping () -> Void)
}

final class EditorViewModel: EditorViewModelProtocol {
    
    private let task: Task?
    private let numberOfAllTasks: Int
    
    var isNewTask: Bool {
        task == nil
    }
    
    var navigationTitle: String {
        isNewTask ? Constants.newTask : Constants.editTask
    }
    
    var title: String {
        task?.title ?? ""
    }
    
    var description: String {
        task?.specification ?? ""
    }
    
    //
    
    init(task: Task?, numberOfAllTasks: Int) {
        self.task = task
        self.numberOfAllTasks = numberOfAllTasks
    }
    
    private func formatDuration() -> String? {
        nil // TODO: "01:00 PM - 03:00 PM" such format
    }
    
    func saveTask(
        title: String?,
        specification: String?,
        startTime: String?,
        endTime: String?,
        completion: @escaping () -> Void
    ) {
        if isNewTask {
            StorageManager.shared.createTask(
                id: numberOfAllTasks + 1,
                title: title,
                specification: specification,
                duration: formatDuration()) {
                    completion()
                }
        } else {
            guard let task else { return }
            StorageManager.shared.update(
                task,
                title: title,
                specification: specification,
                isClosed: task.isClosed,
                duration: formatDuration()) {
                    completion()
                }
        }
    }
    
    func deleteTask(completion: @escaping () -> Void) {
        guard let task else { return }
        StorageManager.shared.delete(task) {
            completion()
        }
    }
}
