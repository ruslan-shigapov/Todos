//
//  ScreenFactory.swift
//  Todos
//
//  Created by Ruslan Shigapov on 17.09.2024.
//

struct ScreenFactory {
    
    static func getTodosViewController() -> TodosViewController {
        let viewModel = TodosViewModel()
        return TodosViewController(viewModel: viewModel)
    }
    
    static func getEditorViewController(
        viewModel: EditorViewModelProtocol
    ) -> EditorViewController {
        EditorViewController(viewModel: viewModel)
    }
}
