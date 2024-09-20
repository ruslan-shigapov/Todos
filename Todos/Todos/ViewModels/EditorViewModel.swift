//
//  EditorViewModel.swift
//  Todos
//
//  Created by Ruslan Shigapov on 20.09.2024.
//

protocol EditorViewModelProtocol {
    var navigationTitle: String { get }
}

final class EditorViewModel: EditorViewModelProtocol {
    
    private var task: Task?
    
    var navigationTitle: String {
        task == nil ? Constants.newTask : Constants.editTask
    }
    
    init(task: Task?) {
        self.task = task
    }
}
