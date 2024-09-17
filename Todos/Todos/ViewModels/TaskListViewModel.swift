//
//  TaskListViewModel.swift
//  Todos
//
//  Created by Ruslan Shigapov on 17.09.2024.
//

import Foundation

protocol TaskListViewModelProtocol {
    func getCurrentFormattedDate() -> String
}

final class TaskListViewModel: TaskListViewModelProtocol {
    
    func getCurrentFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd MMMM"
        return dateFormatter.string(from: Date())
    }
}
