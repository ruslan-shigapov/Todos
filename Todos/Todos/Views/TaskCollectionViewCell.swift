//
//  TaskCollectionViewCell.swift
//  Todos
//
//  Created by Ruslan Shigapov on 17.09.2024.
//

import UIKit

final class TaskCollectionViewCell: UICollectionViewCell {
    
    static var identifier = String(describing: TaskCollectionViewCell.self)
    
    // MARK: Views
    private lazy var titleStackView = TitleStackView(placement: .cell)
        
    private lazy var markTaskButton: UIButton = {
        let button = UIButton(type: .system)
        let circleImageName = UIImage(
            systemName: Constants.circleImageName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 32))
        button.setImage(
            circleImageName,
            for: .normal)
        let checkmarkImageName = UIImage(
            systemName: Constants.checkmarkImageName)
        button.setImage(
            checkmarkImageName?.withRenderingMode(.alwaysOriginal),
            for: .selected)
        button.addTarget(
            self,
            action: #selector(markTaskButtonTapped),
            for: .touchUpInside)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.layer.masksToBounds = true
        return button
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        return view
    }()
    
    private let todayLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.today
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    private lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray.withAlphaComponent(0.5)
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [todayLabel, durationLabel])
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: Public Properties 
    var viewModel: TaskCellViewModelProtocol? {
        didSet {
            guard let viewModel else { return }
            titleStackView.configure(
                withTitle: viewModel.title,
                description: viewModel.description,
                shouldTitleBeCrossedOut: viewModel.isClosed)
            durationLabel.text = viewModel.duration
            markTaskButton.isSelected = viewModel.isClosed
            setupButtonColor()
        }
    }
    
    weak var delegate: TaskCollectionViewCellDelegate?
    
    // MARK: Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        markTaskButton.layer.cornerRadius = markTaskButton.frame.height / 2
    }
    
    // MARK: Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private Methods
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 16
        setupShadow()
        addSubviews()
        setupButtonColor()
        setConstraints()
    }
    
    private func setupShadow() {
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 3
    }
    
    private func addSubviews() {
        addSubview(titleStackView)
        addSubview(markTaskButton)
        addSubview(dividerView)
        addSubview(infoStackView)
    }
    
    private func setupButtonColor() {
        markTaskButton.tintColor = markTaskButton.isSelected
        ? .link
        : .lightGray.withAlphaComponent(0.5)
    }
    
    @objc private func markTaskButtonTapped() {
        titleStackView.toggleTitleStrikethrough()
        markTaskButton.isSelected.toggle()
        setupButtonColor()
        viewModel?.markTask { [weak self] in
            guard let self else { return }
            delegate?.taskWasMarked?()
        }
    }
}

// MARK: - Layout
private extension TaskCollectionViewCell {
    
    func setConstraints() {
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 20),
            titleStackView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 24),
            titleStackView.trailingAnchor.constraint(
                equalTo: markTaskButton.leadingAnchor,
                constant: -24),
            
            markTaskButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            markTaskButton.heightAnchor.constraint(equalToConstant: 32),
            markTaskButton.widthAnchor.constraint(
                equalTo: markTaskButton.heightAnchor),
            markTaskButton.centerYAnchor.constraint(equalTo: titleStackView.centerYAnchor),
            
            dividerView.topAnchor.constraint(
                equalTo: titleStackView.bottomAnchor,
                constant: 10),
            dividerView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 24),
            dividerView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -24),
            dividerView.heightAnchor.constraint(equalToConstant: 2),
            
            infoStackView.topAnchor.constraint(
                equalTo: dividerView.bottomAnchor,
                constant: 20),
            infoStackView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 24)
        ])
    }
}
