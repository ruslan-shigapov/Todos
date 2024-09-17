//
//  TaskCollectionViewCell.swift
//  Todos
//
//  Created by Ruslan Shigapov on 17.09.2024.
//

import UIKit

final class TaskCollectionViewCell: UICollectionViewCell {
    
    static var identifier = String(describing: TaskCollectionViewCell.self)
    
    private let titleStackView = TitleStackView(placement: .cell)
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        return view
    }()
    
    // TODO: add "checkmark.circle" button
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Today"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    private let durationLabel: UILabel = {
        let label = UILabel()
        label.text = "01:00 PM - 03:00 PM"
        label.textColor = .gray.withAlphaComponent(0.5)
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [dateLabel, durationLabel])
        stackView.spacing = 8
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 16
        setupShadow()
        addSubviews()
        temp()
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
        addSubview(dividerView)
        addSubview(infoStackView)
    }
    
    func temp() {
        titleStackView.configure(
            withTitle: "Review with Client",
            description: "Product Team")
    }
}

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
