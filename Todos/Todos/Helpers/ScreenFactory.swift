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
        viewModel: EditorViewModelProtocol,
        delegate: EditorViewControllerDelegate?
    ) -> UIViewController {
        let editorVC = EditorViewController(viewModel: viewModel)
        editorVC.delegate = delegate
        return UINavigationController(rootViewController: editorVC)
    }
}
