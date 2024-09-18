//
//  Tasks.swift
//  Todos
//
//  Created by Ruslan Shigapov on 18.09.2024.
//

struct Tasks: Decodable {
    var todos: [Task]
}

struct Task: Decodable {
    var id: Int
    var todo: String
    var completed: Bool
}
