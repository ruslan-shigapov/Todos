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
    
    private lazy var taskListCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.register(
            TaskCollectionViewCell.self,
            forCellWithReuseIdentifier: TaskCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
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
        handleEvents()
        setupContent()
    }
    
    // MARK: Private Methods
    private func setupUI() {
        view.backgroundColor = .background
        addSubviews()
        view.prepareForAutoLayout()
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
    
    private func handleEvents() {
        viewModel.taskWasMarked = { [weak self] in
            guard let self else { return }
            setupFilterTasksButtons()
            filterTasksButtons.forEach {
                if $0.isSelected, $0.selection != .all {
                    self.viewModel.applyFilter(bySelection: $0.selection)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        self.taskListCollectionView.reloadData()
                    }
                }
            }
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
            setupFilterTasksButtons()
            loadingIndicator.stopAnimating()
        } errorHandler: { [weak self] in
            guard let self else { return }
            loadingIndicator.stopAnimating()
        }
    }
    
    private func setupFilterTasksButtons() {
        filterTasksButtons.forEach {
            let tasksCount = switch $0.selection {
            case .all: self.viewModel.getNumberOfAllTasks()
            case .open: self.viewModel.getNumberOfOpenTasks()
            case .closed: self.viewModel.getNumberOfClosedTasks()
            }
            $0.configure(withFilteredTasksCount: tasksCount)
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
        var attributedTitle = AttributedString(Constants.newTask)
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
        let editorVC = ScreenFactory.getEditorViewController(
            viewModel: viewModel.getEditorViewModel())
        present(editorVC, animated: true)
    }
    
    @objc private func filterTasksButtonTapped(_ sender: UIButton) {
        filterTasksButtons.forEach { $0.isSelected = false }
        sender.isSelected = true
        if let filterTasksButton = sender as? FilterTasksButton {
            viewModel.applyFilter(bySelection: filterTasksButton.selection)
        }
        taskListCollectionView.setContentOffset(.zero, animated: true)
        taskListCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TodosViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: collectionView.bounds.width - 48, height: 140)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 20, left: 0, bottom: 12, right: 0)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        20
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let editorVC = ScreenFactory.getEditorViewController(
            viewModel: viewModel.getEditorViewModel(at: indexPath.item))
        present(editorVC, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension TodosViewController: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel.getNumberOfItems()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(
                describing: TaskCollectionViewCell.identifier),
            for: indexPath)
        let taskCell = cell as? TaskCollectionViewCell
        taskCell?.viewModel = viewModel.getTaskCellViewModel(at: indexPath.item)
        taskCell?.delegate = viewModel as TaskCollectionViewCellDelegate
        return taskCell ?? UICollectionViewCell()
    }
}

// MARK: - Layout
extension TodosViewController {
    
    private func setConstraints() {
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
