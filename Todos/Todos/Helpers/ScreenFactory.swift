//
//  ScreenFactory.swift
//  Todos
//
//  Created by Ruslan Shigapov on 17.09.2024.
//

struct ScreenFactory {
    
    static func getTaskListViewController() -> TaskListViewController {
        let viewModel = TaskListViewModel()
        return TaskListViewController(viewModel: viewModel)
    }
}
