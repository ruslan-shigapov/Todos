//
//  EditorViewModel.swift
//  Todos
//
//  Created by Ruslan Shigapov on 20.09.2024.
//

import Foundation

protocol EditorViewModelProtocol {
    var durationWasInvalid: (() -> Void)? { get set }
    var isNewTask: Bool { get }
    var navigationTitle: String { get }
    var title: String { get }
    var description: String { get }
    var startTime: Date? { get }
    var endTime: Date? { get }
    func saveTask(
        title: String?,
        specification: String?,
        startTime: Date?,
        endTime: Date?,
        completion: @escaping () -> Void
    )
    func deleteTask(completion: @escaping () -> Void)
}

final class EditorViewModel: EditorViewModelProtocol {
    
    private let task: Task?
    private let numberOfAllTasks: Int
    
    var durationWasInvalid: (() -> Void)?
    
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
    
    var startTime: Date? {
        task?.startTime
    }
    
    var endTime: Date? {
        task?.endTime
    }
    
    init(task: Task?, numberOfAllTasks: Int) {
        self.task = task
        self.numberOfAllTasks = numberOfAllTasks
    }
    
    func saveTask(
        title: String?,
        specification: String?,
        startTime: Date?,
        endTime: Date?,
        completion: @escaping () -> Void
    ) {
        if let endTime {
            guard let startTime, startTime < endTime else {
                durationWasInvalid?()
                return
            }
            let endTimeComponents = Calendar.current.dateComponents(
                [.hour, .minute],
                from: endTime)
            let startTimeComponents = Calendar.current.dateComponents(
                [.hour, .minute],
                from: startTime)
            if endTimeComponents == startTimeComponents {
                durationWasInvalid?()
                return
            }
        }
        if isNewTask {
            StorageManager.shared.createTask(
                id: numberOfAllTasks + 1,
                title: title,
                specification: specification,
                startTime: startTime,
                endTime: endTime
            ) {
                completion()
            }
        } else {
            guard let task else { return }
            StorageManager.shared.update(
                task,
                title: title,
                specification: specification,
                isClosed: task.isClosed,
                startTime: startTime,
                endTime: endTime
            ) {
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
