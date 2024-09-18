//
//  TodosViewModel.swift
//  Todos
//
//  Created by Ruslan Shigapov on 17.09.2024.
//

import Foundation

protocol TodosViewModelProtocol {
    func getCurrentFormattedDate() -> String
    func applyFilter(bySelection selection: FilterTasksButtonSelection)
    func fetchTasks(
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    )
    func getNumberOfItems() -> Int
    func getNumberOfAllTasks() -> Int
    func getNumberOfClosedTasks() -> Int
    func getNumberOfOpenTasks() -> Int
    func getTaskCellViewModel(at index: Int) -> TaskCellViewModelProtocol
}

final class TodosViewModel: TodosViewModelProtocol {
    
    private var tasks: [Task] = []
    private var filteredTasks: [Task] = []
    
    func getCurrentFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd MMMM"
        return dateFormatter.string(from: Date())
    }
    
    func applyFilter(bySelection selection: FilterTasksButtonSelection) {
        switch selection {
        case .all: filteredTasks = tasks
        case .open: filteredTasks = tasks.filter { !$0.completed }
        case .closed: filteredTasks = tasks.filter { $0.completed }
        }
    }
    
    func fetchTasks(
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    ) {
        NetworkManager.shared.fetchTasks { [weak self] result in
            guard let self else { return }
            switch result {
                case .success(let tasks):
                DispatchQueue.main.async {
                    self.tasks = tasks
                    self.applyFilter(bySelection: .all)
                    completion()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error)
                    errorHandler()
                }
            }
        }
    }
    
    func getNumberOfItems() -> Int {
        filteredTasks.count
    }
    
    func getNumberOfAllTasks() -> Int {
        tasks.count
    }
    
    func getNumberOfClosedTasks() -> Int {
        tasks.filter { $0.completed }.count
    }
    
    func getNumberOfOpenTasks() -> Int {
        tasks.count - getNumberOfClosedTasks()
    }
    
    func getTaskCellViewModel(at index: Int) -> TaskCellViewModelProtocol {
        TaskCellViewModel(task: filteredTasks[index])
    }
}
