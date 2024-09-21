//
//  TasksResponse.swift
//  Todos
//
//  Created by Ruslan Shigapov on 18.09.2024.
//

struct TasksResponse: Decodable {
    var todos: [TaskResponse]
}

struct TaskResponse: Decodable {
    var id: Int
    var todo: String
    var completed: Bool
}
