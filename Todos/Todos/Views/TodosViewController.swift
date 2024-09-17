//
//  TodosViewController.swift
//  Todos
//
//  Created by Ruslan Shigapov on 16.09.2024.
//

import UIKit

final class TodosViewController: UIViewController {
    
    // MARK: Private Properties
    private let viewModel: TodosViewModelProtocol
    
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
    
    private let sortTasksButtons = [
        SortTasksButton(selection: .all),
        SortTasksButton(selection: .open),
        SortTasksButton(selection: .closed)
    ]
    
    private lazy var selectionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: sortTasksButtons)
        let dividerView = UIView()
        dividerView.widthAnchor.constraint(equalToConstant: 3).isActive = true
        dividerView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dividerView.backgroundColor = .lightGray
        dividerView.layer.cornerRadius = 1
        stackView.insertArrangedSubview(dividerView, at: 1)
        stackView.spacing = 24
        return stackView
    }()
    
    private lazy var taskListCollectionView = TaskListCollectionView(
        viewModel: viewModel) 
    
    // MARK: Initialize
    init(viewModel: TodosViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addTargets()
    }
    
    // MARK: Private Methods
    private func setupUI() {
        view.backgroundColor = .background
        addSubviews()
        setupContent()
        setConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(titleStackView)
        view.addSubview(addNewTaskButton)
        view.addSubview(selectionStackView)
        view.addSubview(taskListCollectionView)
    }
    
    private func setupContent() {
        titleStackView.configure(
            withTitle: Constants.mainTitle,
            description: viewModel.getCurrentFormattedDate())
    }
    
    private func addTargets() {
        sortTasksButtons.forEach {
            $0.addTarget(
                self,
                action: #selector(sortTasksButtonTapped),
                for: .touchUpInside)
        }
    }

    private func getCustomizedButtonConfiguration() -> UIButton.Configuration {
        var buttonConfiguration = UIButton.Configuration.tinted()
        let symbolConfiguration = UIImage.SymbolConfiguration(
            pointSize: 14,
            weight: .bold)
        buttonConfiguration.image = UIImage(
            systemName: Constants.plusImageName,
            withConfiguration: symbolConfiguration)
        var attributedTitle = AttributedString(Constants.addNewTaskButtonTitle)
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
    
    @objc private func addNewTaskButtonTapped() {}
    
    @objc private func sortTasksButtonTapped(_ sender: UIButton) {
        sortTasksButtons.forEach { $0.isSelected = false }
        sender.isSelected = true
        if let sortTasksButton = sender as? SortTasksButton {
            switch sortTasksButton.selection {
            case .open: print("show only open tasks")
            case .closed: print("show only closed tasks")
            default: print("show all tasks")
            }
        }
    }
}

// MARK: - Layout
private extension TodosViewController {
    
    func setConstraints() {
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
            
            taskListCollectionView.topAnchor.constraint(
                equalTo: selectionStackView.bottomAnchor,
                constant: 12),
            taskListCollectionView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            taskListCollectionView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor),
            taskListCollectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor)
        ])
    }
}
