//
//  TodosViewModel.swift
//  Todos
//
//  Created by Ruslan Shigapov on 17.09.2024.
//

import Foundation

protocol TodosViewModelProtocol {
    func getCurrentFormattedDate() -> String
    func fetchTasks(
        completion: @escaping () -> Void,
        errorHandler: @escaping () -> Void
    )
    func getNumberOfItems() -> Int
    func getNumberOfClosedTasks() -> Int
    func getNumberOfOpenTasks() -> Int
    func getTaskCellViewModel(at index: Int) -> TaskCellViewModelProtocol
}

final class TodosViewModel: TodosViewModelProtocol {
    
    private var tasks: [Task] = []
    
    func getCurrentFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd MMMM"
        return dateFormatter.string(from: Date())
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
        tasks.count
    }
    
    func getNumberOfClosedTasks() -> Int {
        tasks.filter { $0.completed }.count
    }
    
    func getNumberOfOpenTasks() -> Int {
        tasks.count - getNumberOfClosedTasks()
    }
    
    func getTaskCellViewModel(at index: Int) -> TaskCellViewModelProtocol {
        TaskCellViewModel(task: tasks[index])
    }
}
