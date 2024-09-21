//
//  EditorViewController.swift
//  Todos
//
//  Created by Ruslan Shigapov on 20.09.2024.
//

import UIKit

final class EditorViewController: UIViewController {
    
    // MARK: Private Properties
    private var viewModel: EditorViewModelProtocol
    
    // MARK: Views
    private lazy var titleTextField = CustomTextField(type: .title, tag: 1)
    private let descriptionTextField = CustomTextField(
        type: .description,
        tag: 2)
    
    private lazy var textFieldStackView: UIStackView = {
        let dividerView = DividerView()
        let stackView = UIStackView(
            arrangedSubviews: [
                titleTextField,
                dividerView,
                descriptionTextField
            ])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var textFieldBackView = RoundedBackView(
        subview: textFieldStackView)
    
    private let startTimeStackView = TimeStackView(type: .start)
    private let endTimeStackView = TimeStackView(type: .end)
    
    private lazy var durationStackView: UIStackView = {
        let dividerView = DividerView()
        let stackView = UIStackView(
            arrangedSubviews: [
                startTimeStackView,
                dividerView,
                endTimeStackView
            ])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var durationBackView = RoundedBackView(
        subview: durationStackView)
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.deleteTask, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.tintColor = .red
        button.addTarget(
            self,
            action: #selector(deleteButtonTapped),
            for: .touchUpInside)
        return button
    }()
    
    // MARK: Public Properties
    weak var delegate: EditorViewControllerDelegate?

    
    // MARK: Initialize
    init(viewModel: EditorViewModelProtocol) {
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
        setupContent()
        addDismissTapRecognizer()
        handleEvents()
    }
    
    // MARK: Private Methods
    private func setupUI() {
        setupNavigationBar()
        view.backgroundColor = .background
        view.addSubview(textFieldBackView)
        view.addSubview(durationBackView)
        view.addSubview(deleteButton)
        view.prepareForAutoLayout()
        setConstraints()
    }
    
    private func setupContent() {
        if viewModel.isNewTask {
            deleteButton.isHidden = true
        } else {
            titleTextField.text = viewModel.title
            descriptionTextField.text = viewModel.description
            startTimeStackView.setTime(viewModel.startTime)
            endTimeStackView.setTime(viewModel.endTime)
        }
    }
    
    private func setupNavigationBar() {
        title = viewModel.navigationTitle
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black
        ]
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneButtonTapped))
    }
    
    private func addDismissTapRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    private func handleEvents() {
        viewModel.durationWasInvalid = { [weak self] in
            guard let self else { return }
            let alertController = UIAlertController(
                title: Constants.alertTitle,
                message: "",
                preferredStyle: .alert
            )
            let alertAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(alertAction)
            present(alertController, animated: true)
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func doneButtonTapped() {
        viewModel.saveTask(
            title: titleTextField.text,
            specification: descriptionTextField.text,
            startTime: startTimeStackView.getTime(),
            endTime: endTimeStackView.getTime()
        ) { [weak self] in
            guard let self else { return }
            delegate?.tasksWereUpdated?()
            dismiss(animated: true)
        }
    }
    
    @objc private func deleteButtonTapped() {
        viewModel.deleteTask { [weak self] in
            guard let self else { return }
            delegate?.tasksWereUpdated?()
            dismiss(animated: true)
        }
    }
}

// MARK: - Layout
private extension EditorViewController {
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            textFieldBackView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 24),
            textFieldBackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 24),
            textFieldBackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -24),
            
            durationBackView.topAnchor.constraint(
                equalTo: textFieldBackView.bottomAnchor,
                constant: 24),
            durationBackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 24),
            durationBackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -24),
            
            deleteButton.topAnchor.constraint(
                equalTo: durationBackView.bottomAnchor,
                constant: 32),
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
