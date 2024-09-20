//
//  EditorViewController.swift
//  Todos
//
//  Created by Ruslan Shigapov on 20.09.2024.
//

import UIKit

final class EditorViewController: UIViewController {
    
    // MARK: Private Properties
    private let viewModel: EditorViewModelProtocol
    
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
        addDismissTapRecognizer()
    }
    
    // MARK: Private Methods
    private func setupUI() {
        setupNavigationBar()
        view.backgroundColor = .background
        view.addSubview(textFieldBackView)
        view.addSubview(durationBackView)
        view.prepareForAutoLayout()
        setConstraints()
    }
    
    private func setupNavigationBar() {
        title = viewModel.navigationTitle
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black
        ]
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: nil)
    }
    
    private func addDismissTapRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
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
                constant: -24)
        ])
    }
}
