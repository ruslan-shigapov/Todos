//
//  TodosViewModel.swift
//  Todos
//
//  Created by Ruslan Shigapov on 17.09.2024.
//

import Foundation

protocol TaskCollectionViewCellDelegate: AnyObject {
    var taskWasMarked: (() -> Void)? { get set }
}

protocol EditorViewControllerDelegate: AnyObject {
    var tasksWereUpdated: (() -> Void)? { get set }
}

protocol TodosViewModelProtocol: TaskCollectionViewCellDelegate,
                                 EditorViewControllerDelegate {
    func getCurrentFormattedDate() -> String
    func fetchTasks(
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    )
    func applyFilter(bySelection selection: FilterTasksButtonSelection)
    func getNumberOfItems() -> Int
    func getNumberOfAllTasks() -> Int
    func getNumberOfClosedTasks() -> Int
    func getNumberOfOpenTasks() -> Int
    func getTaskCellViewModel(at index: Int) -> TaskCellViewModelProtocol
    func getEditorViewModel() -> EditorViewModelProtocol
    func getEditorViewModel(at index: Int) -> EditorViewModelProtocol
}

final class TodosViewModel: TodosViewModelProtocol {
    
    private var wasDataReceived: Bool {
        UserDefaults.standard.bool(forKey: "wasDataReceived")
    }
    
    private var tasks: [Task] = []
    private var filteredTasks: [Task] = []

    var taskWasMarked: (() -> Void)?
    var tasksWereUpdated: (() -> Void)?
    
    private func fetchTasksFromNetwork(
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    ) {
        NetworkManager.shared.fetchTasks { [weak self] result in
            guard let self else { return }
            switch result {
                case .success(let tasksResponse):
                UserDefaults.standard.set(true, forKey: "wasDataReceived")
                StorageManager.shared.saveTasks(tasksResponse)
                fetchTasksFromStorage(
                    completion: completion,
                    errorHandler: errorHandler)
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    errorHandler()
                }
            }
        }
    }
    
    private func fetchTasksFromStorage(
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    ) {
        StorageManager.shared.fetchTasks { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let tasks):
                self.tasks = tasks
                self.applyFilter(bySelection: .all)
                DispatchQueue.main.async {
                    completion()
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    errorHandler()
                }
            }
        }
    }
    
    func getCurrentFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd MMMM"
        return dateFormatter.string(from: Date())
    }
    
    func fetchTasks(
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    ) {
        if wasDataReceived {
            DispatchQueue.global().async { [weak self] in
                guard let self else { return }
                fetchTasksFromStorage(
                    completion: completion,
                    errorHandler: errorHandler)
            }
        } else {
            fetchTasksFromNetwork(
                completion: completion,
                errorHandler: errorHandler)
        }
    }
    
    func applyFilter(bySelection selection: FilterTasksButtonSelection) {
        switch selection {
        case .all: filteredTasks = tasks
        case .open: filteredTasks = tasks.filter { !$0.isClosed }
        case .closed: filteredTasks = tasks.filter { $0.isClosed }
        }
        filteredTasks.sort { $0.id > $1.id }
    }
    
    func getNumberOfItems() -> Int {
        filteredTasks.count
    }
    
    func getNumberOfAllTasks() -> Int {
        tasks.count
    }
    
    func getNumberOfClosedTasks() -> Int {
        tasks.filter { $0.isClosed }.count
    }
    
    func getNumberOfOpenTasks() -> Int {
        tasks.count - getNumberOfClosedTasks()
    }
    
    func getTaskCellViewModel(at index: Int) -> TaskCellViewModelProtocol {
        TaskCellViewModel(task: filteredTasks[index])
    }
    
    func getEditorViewModel() -> EditorViewModelProtocol {
        EditorViewModel(task: nil, numberOfAllTasks: tasks.count)
    }
    
    func getEditorViewModel(at index: Int) -> EditorViewModelProtocol {
        EditorViewModel(
            task: filteredTasks[index],
            numberOfAllTasks: tasks.count)
    }
}
