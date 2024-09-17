//
//  TaskListViewController.swift
//  Todos
//
//  Created by Ruslan Shigapov on 16.09.2024.
//

import UIKit

final class TaskListViewController: UIViewController {
    
    // MARK: Views
    private let titleStackView = TitleStackView()
    
    private lazy var addNewTaskButton: UIButton = {
        let button = UIButton(configuration: getCustomizedButtonConfiguration())
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.addTarget(
            self,
            action: #selector(addNewTaskButtonTapped),
            for: .touchUpInside)
        return button
    }()
    
    private let showAllTasksButton = SortTasksButton(selection: .all)
    private let showOpenTasksButton = SortTasksButton(selection: .open)
    private let showClosedTasksButton = SortTasksButton(selection: .closed)
    
    private lazy var selectionStackView: UIStackView = {
        let dividerView = UIView()
        dividerView.widthAnchor.constraint(equalToConstant: 3).isActive = true
        dividerView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dividerView.backgroundColor = .lightGray
        dividerView.layer.cornerRadius = 1
        let stackView = UIStackView(
            arrangedSubviews: [
                showAllTasksButton,
                dividerView,
                showOpenTasksButton,
                showClosedTasksButton
            ])
        stackView.spacing = 24
        return stackView
    }()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addTargets()
    }
    
    // MARK: Setup
    private func setupUI() {
        view.backgroundColor = .background
        view.addSubview(titleStackView)
        view.addSubview(addNewTaskButton)
        view.addSubview(selectionStackView)
        setupContent()
        setConstraints()
    }
    
    private func setupContent() {
        titleStackView.configure(
            withTitle: "Today's Tasks",
            description: "Wednesday, 11 May")
    }
    
    private func addTargets() {
        [
            showAllTasksButton,
            showOpenTasksButton,
            showClosedTasksButton
        ].forEach {
            $0.addTarget(
                self,
                action: #selector(showSelectedTasks),
                for: .touchUpInside)
        }
    }

    private func getCustomizedButtonConfiguration() -> UIButton.Configuration {
        var buttonConfiguration = UIButton.Configuration.tinted()
        let symbolConfiguration = UIImage.SymbolConfiguration(
            pointSize: 14,
            weight: .bold)
        buttonConfiguration.image = UIImage(
            systemName: "plus",
            withConfiguration: symbolConfiguration)
        var attributedTitle = AttributedString("New Task")
        attributedTitle.font = .systemFont(ofSize: 16, weight: .semibold)
        buttonConfiguration.attributedTitle = attributedTitle
        buttonConfiguration.contentInsets = .init(
            top: 12,
            leading: 16,
            bottom: 12,
            trailing: 16)
        buttonConfiguration.imagePadding = 8
        return buttonConfiguration
    }
    
    // MARK: Actions
    @objc private func addNewTaskButtonTapped() {
        
    }
    
    @objc private func showSelectedTasks(_ sender: UIButton) {
        
    }
}

// MARK: - Layout
extension TaskListViewController {
    
    private func setConstraints() {
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 24),
            
            addNewTaskButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -24),
            addNewTaskButton.centerYAnchor.constraint(
                equalTo: titleStackView.centerYAnchor),
            
            selectionStackView.topAnchor.constraint(
                equalTo: titleStackView.bottomAnchor,
                constant: 32),
            selectionStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 24),
        ])
    }
}
