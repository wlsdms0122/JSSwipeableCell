//
//  ViewController.swift
//  Demo
//
//  Created by JSilver on 2020/04/17.
//  Copyright © 2020 JSilver. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - view property
    private let root: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        view.backgroundColor = .clear
        
        // Cell register
        view.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: CustomCollectionViewCell.self))
        
        // Set delegate & data source
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    // MARK: - property
    private let items: [Int] = (0 ..< 10).map { $0 }
    
    // MARK: - lifecycle
    override func loadView() {
        view = root
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
    }
    
    // MARK: - private
    private func setUpLayout() {
        title = "title".localized
        
        // Set autolayout constraints
        [collectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            root.addSubview($0)
        }
        
        // Collection view
        [
            collectionView.topAnchor.constraint(equalTo: root.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: root.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: root.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: root.safeAreaLayoutGuide.bottomAnchor)
        ].forEach { $0.isActive = true }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 80)
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { items.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CustomCollectionViewCell.self), for: indexPath) as? CustomCollectionViewCell else { fatalError() }
        cell.titleLabel.text = String(items[indexPath.item])
        return cell
    }
}

// MARK: - helper
extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
