//
//  TaskCollectionViewCell.swift
//  Todos
//
//  Created by Ruslan Shigapov on 17.09.2024.
//

import UIKit

final class TaskCollectionViewCell: UICollectionViewCell {
    
    static var identifier = String(describing: TaskCollectionViewCell.self)
    
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
    }
    
    private func setupShadow() {
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 3
    }
}
