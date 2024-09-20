//
//  EditorViewModel.swift
//  Todos
//
//  Created by Ruslan Shigapov on 20.09.2024.
//

protocol EditorViewModelProtocol {
    
}

final class EditorViewModel: EditorViewModelProtocol {
    
    private var task: Task?
    
    init(task: Task?) {
        self.task = task
    }
}
