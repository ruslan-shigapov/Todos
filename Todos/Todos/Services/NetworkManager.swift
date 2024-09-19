//
//  NetworkManager.swift
//  Todos
//
//  Created by Ruslan Shigapov on 18.09.2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case unknown(_ error: Error)
    case invalidResponse
    case noData
    case parsingFailure
}

final class NetworkManager {
    
    static let shared = NetworkManager()
            
    private init() {}
    
    func fetchTasks(
        completion: @escaping (Result<[TaskResponse], NetworkError>) -> Void
    ) {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            completion(.failure(.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                completion(.failure(.unknown(error)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            guard let data else {
                completion(.failure(.noData))
                return
            }
            do {
                let tasks = try JSONDecoder().decode(
                    TasksResponse.self,
                    from: data)
                completion(.success(tasks.todos))
            } catch {
                completion(.failure(.parsingFailure))
            }
        }.resume()
    }
}
