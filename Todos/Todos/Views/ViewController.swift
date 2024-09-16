//
//  ViewController.swift
//  Todos
//
//  Created by Ruslan Shigapov on 16.09.2024.
//

import UIKit

final class ViewController: UIViewController {
    
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

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: Setup
    private func setupUI() {
        view.backgroundColor = .background
        view.addSubview(titleStackView)
        view.addSubview(addNewTaskButton)
        setupContent()
        setConstraints()
    }
    
    private func setupContent() {
        titleStackView.configure(
            withTitle: "Today's Task",
            description: "Wednesday, 11 May")
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
}

// MARK: - Layout
extension ViewController {
    
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
                equalTo: titleStackView.centerYAnchor)
        ])
    }
}
