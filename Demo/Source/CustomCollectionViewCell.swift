//
//  CustomCollectionViewCell.swift
//  Demo
//
//  Created by JSilver on 2020/04/17.
//  Copyright © 2020 JSilver. All rights reserved.
//

import UIKit
import JSSwipeableCell

class CustomCollectionViewCell: JSSwipeableCollectionViewCell {
    // MARK: - view property
    let titleLabel = UILabel()
    
    let deleteButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .red
        view.setTitle("delete_title".localized, for: .normal)
        return view
    }()
    
    let archiveButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .blue
        view.setTitle("archive_title".localized, for: .normal)
        return view
    }()
    
    // MARK: - constructor
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private
    private func setUpLayout() {
        contentView.backgroundColor = .gray
        
        // Set autolayout constraint.
        [titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        // Set right action view.
        [deleteButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            rightActionView.addSubview($0)
        }
        
        // Set right action view width constraint.
        rightActionView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        // Set delete button leading constraint equal to content view's trailing.
        // And set priority to '.defaultHigh'
        let deleteButtonLeadingConstraint = deleteButton.leadingAnchor.constraint(equalTo: contentView.trailingAnchor)
        deleteButtonLeadingConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: rightActionView.topAnchor),
            deleteButtonLeadingConstraint,
            deleteButton.trailingAnchor.constraint(equalTo: rightActionView.trailingAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: rightActionView.bottomAnchor),
            // Set width constraint greater than or equal to right action view's width.
            deleteButton.widthAnchor.constraint(greaterThanOrEqualTo: rightActionView.widthAnchor)
        ])
        
        // Set left action view.
        [archiveButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            leftActionView.addSubview($0)
        }
        NSLayoutConstraint.activate([
            archiveButton.topAnchor.constraint(equalTo: leftActionView.topAnchor),
            archiveButton.leadingAnchor.constraint(equalTo: leftActionView.leadingAnchor),
            archiveButton.trailingAnchor.constraint(equalTo: leftActionView.trailingAnchor),
            archiveButton.bottomAnchor.constraint(equalTo: leftActionView.bottomAnchor),
            archiveButton.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
}
