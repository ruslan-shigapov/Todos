//
//  SortTasksButton.swift
//  Todos
//
//  Created by Ruslan Shigapov on 16.09.2024.
//

import UIKit

enum SortTasksButtonSelection: String {
    case all, open, closed
}

final class SortTasksButton: UIButton {

    // MARK: Views
    private lazy var selectionNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.text = selection.rawValue.capitalized
        return label
    }()
    
    private let sortedTasksCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .background
        label.text = "35" // TODO: calculate sorted tasks count 
        return label
    }()
    
    private lazy var roundedView: UIView = {
        let view = UIView()
        view.addSubview(sortedTasksCountLabel)
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [selectionNameLabel, roundedView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isUserInteractionEnabled = false
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: Public Properties
    let selection: SortTasksButtonSelection
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                selectionNameLabel.textColor = .link
                roundedView.backgroundColor = .link
            } else {
                selectionNameLabel.textColor = .gray
                roundedView.backgroundColor = .lightGray
            }
        }
    }
        
    // MARK: Initialize
    init(selection: SortTasksButtonSelection) {
        self.selection = selection
        super.init(frame: .zero)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private Methods
    private func setupUI() {
        isSelected = selection == .all
        addSubview(containerStackView)
        setConstraints()
    }
}

// MARK: - Layout
private extension SortTasksButton {
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStackView.trailingAnchor.constraint(
                equalTo: trailingAnchor),
            containerStackView.topAnchor.constraint(equalTo: topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            roundedView.heightAnchor.constraint(equalToConstant: 20),
            
            sortedTasksCountLabel.leadingAnchor.constraint(
                equalTo: roundedView.leadingAnchor,
                constant: 5),
            sortedTasksCountLabel.trailingAnchor.constraint(
                equalTo: roundedView.trailingAnchor,
                constant: -5),
            sortedTasksCountLabel.centerYAnchor.constraint(
                equalTo: roundedView.centerYAnchor)
        ])
    }
}
