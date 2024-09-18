//
//  FilterTasksButton.swift
//  Todos
//
//  Created by Ruslan Shigapov on 16.09.2024.
//

import UIKit

enum FilterTasksButtonSelection: String {
    case all, open, closed
}

final class FilterTasksButton: UIButton {

    // MARK: Views
    private lazy var selectionNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.text = selection.rawValue.capitalized
        return label
    }()
    
    private let filteredTasksCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .background
        label.text = Constants.zero
        return label
    }()
    
    private lazy var roundedView: UIView = {
        let view = UIView()
        view.addSubview(filteredTasksCountLabel)
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
    let selection: FilterTasksButtonSelection
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                selectionNameLabel.textColor = .link
                roundedView.backgroundColor = .link
            } else {
                selectionNameLabel.textColor = .lightGray
                roundedView.backgroundColor = .lightGray.withAlphaComponent(0.5)
            }
        }
    }
        
    // MARK: Initialize
    init(selection: FilterTasksButtonSelection) {
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
    
    // MARK: Public Methods
    func configure(withFilteredTasksCount tasksCount: Int) {
        filteredTasksCountLabel.text = "\(tasksCount)"
    }
}

// MARK: - Layout
private extension FilterTasksButton {
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStackView.trailingAnchor.constraint(
                equalTo: trailingAnchor),
            containerStackView.topAnchor.constraint(equalTo: topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            roundedView.heightAnchor.constraint(equalToConstant: 20),
            roundedView.widthAnchor.constraint(equalToConstant: 25),
            
            filteredTasksCountLabel.centerXAnchor.constraint(
                equalTo: roundedView.centerXAnchor),
            filteredTasksCountLabel.centerYAnchor.constraint(
                equalTo: roundedView.centerYAnchor)
        ])
    }
}
