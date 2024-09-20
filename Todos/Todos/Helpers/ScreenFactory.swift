//
//  ScreenFactory.swift
//  Todos
//
//  Created by Ruslan Shigapov on 17.09.2024.
//

import UIKit

struct ScreenFactory {
    
    static func getTodosViewController() -> UIViewController {
        let viewModel = TodosViewModel()
        return TodosViewController(viewModel: viewModel)
    }
    
    static func getEditorViewController(
        viewModel: EditorViewModelProtocol
    ) -> UIViewController {
        UINavigationController(
            rootViewController: EditorViewController(viewModel: viewModel))
    }
}
