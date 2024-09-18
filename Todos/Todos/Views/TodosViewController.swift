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
    private lazy var titleStackView = TitleStackView(placement: .main)
    
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
    
    private let filterTasksButtons = [
        FilterTasksButton(selection: .all),
        FilterTasksButton(selection: .open),
        FilterTasksButton(selection: .closed)
    ]
    
    private lazy var selectionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: filterTasksButtons)
        let dividerView = UIView()
        dividerView.widthAnchor.constraint(equalToConstant: 3).isActive = true
        dividerView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dividerView.backgroundColor = .lightGray.withAlphaComponent(0.5)
        dividerView.layer.cornerRadius = 1
        stackView.insertArrangedSubview(dividerView, at: 1)
        stackView.spacing = 24
        return stackView
    }()
    
    private lazy var taskListCollectionView = TaskListCollectionView(
        viewModel: viewModel)
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .lightGray
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
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
        setupContent()
    }
    
    // MARK: Private Methods
    private func setupUI() {
        view.backgroundColor = .background
        addSubviews()
        setConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(titleStackView)
        view.addSubview(addNewTaskButton)
        view.addSubview(selectionStackView)
        view.addSubview(taskListCollectionView)
        view.addSubview(loadingIndicator)
    }
    
    private func addTargets() {
        filterTasksButtons.forEach {
            $0.addTarget(
                self,
                action: #selector(filterTasksButtonTapped),
                for: .touchUpInside)
        }
    }
    
    private func setupContent() {
        titleStackView.configure(
            withTitle: Constants.mainTitle,
            description: viewModel.getCurrentFormattedDate())
        loadingIndicator.startAnimating()
        viewModel.fetchTasks { [weak self] in
            guard let self else { return }
            taskListCollectionView.reloadData()
            filterTasksButtons.forEach {
                let tasksCount = switch $0.selection {
                case .all: self.viewModel.getNumberOfAllTasks()
                case .open: self.viewModel.getNumberOfOpenTasks()
                case .closed: self.viewModel.getNumberOfClosedTasks()
                }
                $0.configure(withFilteredTasksCount: tasksCount)
            }
            loadingIndicator.stopAnimating()
        } errorHandler: { [weak self] in
            guard let self else { return }
            loadingIndicator.stopAnimating()
        }
    }

    private func getCustomizedButtonConfiguration() -> UIButton.Configuration {
        var buttonConfiguration = UIButton.Configuration.tinted()
        let symbolConfiguration = UIImage.SymbolConfiguration(
            pointSize: 12,
            weight: .medium)
        buttonConfiguration.image = UIImage(
            systemName: Constants.plusImageName,
            withConfiguration: symbolConfiguration)
        var attributedTitle = AttributedString(Constants.addNewTaskButtonTitle)
        attributedTitle.font = .systemFont(ofSize: 16, weight: .semibold)
        buttonConfiguration.attributedTitle = attributedTitle
        buttonConfiguration.contentInsets = .init(
            top: 10,
            leading: 12,
            bottom: 10,
            trailing: 12)
        buttonConfiguration.imagePadding = 6
        return buttonConfiguration
    }
    
    @objc private func addNewTaskButtonTapped() {
        
    }
    
    @objc private func filterTasksButtonTapped(_ sender: UIButton) {
        filterTasksButtons.forEach { $0.isSelected = false }
        sender.isSelected = true
        if let filterTasksButton = sender as? FilterTasksButton {
            viewModel.applyFilter(bySelection: filterTasksButton.selection)
        }
        taskListCollectionView.reloadData()
        taskListCollectionView.setContentOffset(.zero, animated: true)
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
                equalTo: view.trailingAnchor),
            
            loadingIndicator.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(
                equalTo: view.centerYAnchor)
        ])
    }
}
