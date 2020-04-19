//
//  JSSwipeableCollectionViewCell.swift
//  JSSwipeableCell
//
//  Created by JSilver on 2020/04/15.
//  Copyright © 2020 Jeong Jin Eun. All rights reserved.
//

import UIKit

open class JSSwipeableCollectionViewCell: UICollectionViewCell {
    // MARK: - constants
    private static let SWIPE_THRESHOLD_WEIGHT: CGFloat = 0.1
    private static let SWIPE_VELOCITY_THRESHOLD: CGFloat = 500
    
    public enum Direction {
        case left
        case right
    }
    
    // MARK: - view property
    public let leftActionView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.clipsToBounds = false
        return view
    }()
    public let rightActionView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.clipsToBounds = false
        return view
    }()
    
    private weak var collectionView: UICollectionView?
    
    // MARK: - property
    private var panGestureRecognizer: UIPanGestureRecognizer?
    
    private var resetAnimator: UIViewPropertyAnimator? {
        didSet {
            oldValue?.stopAnimation(false)
            oldValue?.finishAnimation(at: .current)
        }
    }
    private var endAnimator: UIViewPropertyAnimator? {
        didSet {
            oldValue?.stopAnimation(false)
            oldValue?.finishAnimation(at: .current)
        }
    }
    
    private var origin: CGPoint = .zero
    private(set) var direction: Direction? {
        didSet {
            leftActionView.isHidden = direction != .right
            rightActionView.isHidden = direction != .left
        }
    }
    
    /// Swipe animation speed (seconds). default is `0.3` seconds
    open var speed: Double = 0.3
    open var isSwipeThreshold: Bool = true
    
    // MARK: - constructor
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - lifecycle
    open override func prepareForReuse() {
        super.prepareForReuse()
        reset(animated: false)
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        // Find collection view among parent view hierarchy
        var view: UIView = self
        while let superview = view.superview {
            view = superview
            
            if let collectionView = view as? UICollectionView {
                setUp(collectionView: collectionView)
                return
            }
        }
    }
    
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let superview = superview else { return false }
        
        let point = convert(point, to: superview)
        
        for cell in collectionView?.swipeCells ?? [] {
            if !cell.frame.contains(point) {
                // Reset other swiped cells
                cell.reset(animated: true)
            }
        }
        
        return frame.contains(point)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard contentView.frame.origin != .zero else {
            super.touchesEnded(touches, with: event)
            return
        }
        
        // Reset if content view dosen't positioned zero
        reset(animated: true)
    }
    
    // MARK: - private method
    private func setUpLayout() {
        [leftActionView, rightActionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            insertSubview($0, belowSubview: contentView)
        }
        NSLayoutConstraint.activate([
            // Left action view
            leftActionView.topAnchor.constraint(equalTo: topAnchor),
            leftActionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            leftActionView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            leftActionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            // Right action view
            rightActionView.topAnchor.constraint(equalTo: topAnchor),
            rightActionView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            rightActionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            rightActionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Create pan gesture recognizer to swipe
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        panGestureRecognizer.delegate = self
        // Add pan gesture to content view
        contentView.addGestureRecognizer(panGestureRecognizer)
        
        self.panGestureRecognizer = panGestureRecognizer
    }
    
    private func setUp(collectionView: UICollectionView) {
        self.collectionView = collectionView
        
        // Add action handler to collection view's pan gesture
        collectionView.panGestureRecognizer.removeTarget(self, action: nil)
        collectionView.panGestureRecognizer.addTarget(self, action: #selector(handleCollectionPan(gesture:)))
    }
    
    private func reset(animated: Bool) {
        let resetOrigin = {
            self.contentView.frame.origin = .zero
        }
        
        if animated {
            guard resetAnimator == nil else { return }
            
            resetAnimator = UIViewPropertyAnimator(duration: speed, curve: .linear) {
                resetOrigin()
            }
            resetAnimator?.addCompletion({
                if $0 == .end {
                    self.direction = nil
                }
            })
            resetAnimator?.startAnimation()
            
        } else {
            resetOrigin()
            direction = nil
        }
    }
    
    // MARK: - selector
    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            resetAnimator = nil
            endAnimator = nil
            
            // Save origin point of content view
            origin = contentView.frame.origin
            // Call will swipe event
            willSwipe(able: self)
            
        case .changed:
            // Get pan translation
            let translation = gesture.translation(in: contentView)
            if direction == nil {
                // Set swipe direction once
                direction = translation.x > 0 ? .right : .left
            }
            
            // Adjust content view frame
            var point = origin.x + translation.x
            switch direction {
            case .left:
                let width = rightActionView.bounds.width
                if isSwipeThreshold && point < -width {
                    point = -(width + max(abs(point) - width, 0) * Self.SWIPE_THRESHOLD_WEIGHT)
                } else if point > 0 {
                    point *= Self.SWIPE_THRESHOLD_WEIGHT
                }
                
            case .right:
                let width = leftActionView.bounds.width
                if isSwipeThreshold && point > width {
                    point = width + max(abs(point) - width, 0) * Self.SWIPE_THRESHOLD_WEIGHT
                } else if point < 0 {
                    point *= Self.SWIPE_THRESHOLD_WEIGHT
                }
                
            default:
                return
            }
            
            // Move content view
            self.contentView.frame.origin.x = point
            // Call did swipe event
            didSwipe(able: self, translation: translation, direction: direction!)
            
        case .ended:
            // Get pan translation & velocity
            let translation = gesture.translation(in: contentView)
            let velocity = gesture.velocity(in: contentView)
            
            // Adjust content view frame
            var point: CGFloat = 0
            var actionView: UIView
            switch self.direction {
            case .left:
                actionView = self.rightActionView
                let width = actionView.bounds.width
                if velocity.x < -Self.SWIPE_VELOCITY_THRESHOLD || translation.x < -width / 2 {
                    point = -width
                }
                
            case .right:
                actionView =  self.leftActionView
                let width = actionView.bounds.width
                if velocity.x > Self.SWIPE_VELOCITY_THRESHOLD || translation.x > width / 2 {
                    point = width
                }
                
            default:
                return
            }
            // Call end swipe event
            endSwipe(able: self, translation: translation, direction: direction!)
            
            // Animate content view set origin
            endAnimator = UIViewPropertyAnimator(duration: speed, curve: .linear, animations: {
                self.contentView.frame.origin.x = point
                actionView.layoutIfNeeded()
            })
            endAnimator?.addCompletion({
                if $0 == .end && point == 0 {
                    self.direction = nil
                }
            })
            endAnimator?.startAnimation()
            
        default:
            break
        }
    }
    
    @objc private func handleCollectionPan(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            // Reset cell position when collection view pan gesture began
            reset(animated: true)
        }
    }
    
    // MARK: - events
    open func willSwipe(able cell: JSSwipeableCollectionViewCell) { }
    open func didSwipe(able cell: JSSwipeableCollectionViewCell, translation: CGPoint, direction: Direction) { }
    open func endSwipe(able cell: JSSwipeableCollectionViewCell, translation: CGPoint, direction: Direction) { }
}

extension JSSwipeableCollectionViewCell: UIGestureRecognizerDelegate {
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let view = gestureRecognizer.view, gestureRecognizer == panGestureRecognizer {
            guard let translation = panGestureRecognizer?.translation(in: view) else { return true }
            return abs(translation.y) <= abs(translation.x)
        }
        
        return true
    }
}
