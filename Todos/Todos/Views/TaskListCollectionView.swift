//
//  TaskListCollectionView.swift
//  Todos
//
//  Created by Ruslan Shigapov on 17.09.2024.
//

import UIKit

final class TaskListCollectionView: UICollectionView {
    
    private let viewModel: TodosViewModelProtocol

    init(viewModel: TodosViewModelProtocol) {
        self.viewModel = viewModel
        super.init(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout())
        delegate = self
        dataSource = self
        register(
            TaskCollectionViewCell.self,
            forCellWithReuseIdentifier: TaskCollectionViewCell.identifier)
        
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TaskListCollectionView: UICollectionViewDelegateFlowLayout {
    
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
}

// MARK: - UICollectionViewDataSource
extension TaskListCollectionView: UICollectionViewDataSource {
    
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
        return taskCell ?? UICollectionViewCell()
    }
}
