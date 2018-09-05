//
//  UIView+Layoutable.swift
//  Layoutable
//
//  Copyright © 2018 kwiecien.co. All rights reserved.
//

import UIKit

public extension UIView {

    /// Anchor of the view.
    enum Anchor {
        case top
        case right
        case bottom
        case left
    }

    /// Returns view with the same type that can be used with AutoLayout.
    ///
    /// - Returns: Prepared view for AutoLayout.
    func layoutable() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }

    private func assertLayoutability(_ view: UIView) {
        assert(!view.translatesAutoresizingMaskIntoConstraints, "You are trying to use AutoLayout with `translatesAutoresizingMaskIntoConstraints` set to true for one of your views. Doing so would lead to constraint conflicts. Use `layoutable()` method to convert the view to the layoutable form.")
    }

    /// Constrain edges of the view to its superview edges.
    ///
    /// - Parameters:
    ///   - excludedAnchors: Anchors that shouldn't be constrainted.
    ///   - insets: Insets to use, .zero by default.
    /// - Returns: Created and already activated constraints.
    @discardableResult func constrainToSuperviewEdges(excluding excludedAnchors: [Anchor]? = nil, insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        guard let superview = superview else { fatalError("Cannot constrain to nil superview") }
        return constrainToEdges(of: superview, excluding: excludedAnchors, insets: insets)
    }

    /// Constrain edges of the view to given view edges.
    ///
    /// - Parameters:
    ///   - view: View to constrain edges to.
    ///   - excludedAnchors: Anchors that shouldn't be constrainted.
    ///   - insets: Insets to use, .zero by default.
    /// - Returns: Created and already activated constraints.
    @discardableResult func constrainToEdges(of view: UIView, excluding excludedAnchors: [Anchor]? = nil, insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        assertLayoutability(self)
        var constraints = [NSLayoutConstraint]()
        if let excludedAnchors = excludedAnchors {
            if !excludedAnchors.contains(.top) { constraints.append(topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top)) }
            if !excludedAnchors.contains(.right) { constraints.append(rightAnchor.constraint(equalTo: view.rightAnchor, constant: -insets.right)) }
            if !excludedAnchors.contains(.bottom) { constraints.append(bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom)) }
            if !excludedAnchors.contains(.left) { constraints.append(leftAnchor.constraint(equalTo: view.leftAnchor, constant: insets.left)) }
        } else {
            constraints = [
                topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
                leftAnchor.constraint(equalTo: view.leftAnchor, constant: insets.left),
                rightAnchor.constraint(equalTo: view.rightAnchor, constant: -insets.right),
                bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom)
            ]
        }
        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    /// Constrain edges of the view to its superview layout guide.
    ///
    /// - Parameters:
    ///   - excludedAnchors: Anchors that shouldn't be constrainted.
    ///   - insets: Insets to use, .zero by default.
    /// - Returns: Created and already activated constraints.
    @discardableResult func constrainToSuperviewLayoutGuide(excluding excludedAnchors: [Anchor]? = nil, insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        guard let superview = superview else { fatalError("Cannot constrain to nil superview") }
        return constrainToLayoutGuide(of: superview, excluding: excludedAnchors, insets: insets)
    }

    /// Constrain edges of the view to given view layout guide.
    ///
    /// - Parameters:
    ///   - view: View to constrain edges to.
    ///   - excludedAnchors: Anchors that shouldn't be constrainted.
    ///   - insets: Insets to use, .zero by default.
    /// - Returns: Created and already activated constraints.
    @discardableResult func constrainToLayoutGuide(of view: UIView, excluding excludedAnchors: [Anchor]? = nil, insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        assertLayoutability(self)
        var constraints = [NSLayoutConstraint]()
        if #available(iOS 11.0, *) {
            let layoutGuide = view.safeAreaLayoutGuide
            if let excludedAnchors = excludedAnchors {
                if !excludedAnchors.contains(.top) { constraints.append(topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: insets.top)) }
                if !excludedAnchors.contains(.right) { constraints.append(rightAnchor.constraint(equalTo: layoutGuide.rightAnchor, constant: -insets.right)) }
                if !excludedAnchors.contains(.bottom) { constraints.append(bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -insets.bottom)) }
                if !excludedAnchors.contains(.left) { constraints.append(leftAnchor.constraint(equalTo: layoutGuide.leftAnchor, constant: insets.left)) }
            } else {
                constraints = [
                    topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: insets.top),
                    leftAnchor.constraint(equalTo: layoutGuide.leftAnchor, constant: insets.left),
                    rightAnchor.constraint(equalTo: layoutGuide.rightAnchor, constant: -insets.right),
                    bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -insets.bottom)
                ]
            }
            NSLayoutConstraint.activate(constraints)
            return constraints
        }
        else {
            return []
        }
    }

    /// Constrain center of the view to the superview center.
    ///
    /// - Parameters:
    ///   - axis: Axis that should be constrainted.
    ///   - constant: Constant value to use for constraining.
    /// - Returns: Created and already activated constraints.
    @discardableResult func constrainCenterToSuperview(axis: [UILayoutConstraintAxis] = [.horizontal, .vertical],  constant: CGPoint = .zero) -> [NSLayoutConstraint] {
        guard let superview = superview else { fatalError("Cannot constrain to nil superview") }
        return constrainCenter(to: superview, axis: axis, withConstant: constant)
    }

    /// Constrain center of the view to the given view center.
    ///
    /// - Parameters:
    ///   - view: View to constraint center to.
    ///   - axis: Axis that should be constrainted.
    ///   - constant: Constant value to use for constraining.
    /// - Returns: Created and already activated constraints.
    @discardableResult func constrainCenter(to view: UIView, axis: [UILayoutConstraintAxis] = [.horizontal, .vertical], withConstant constant: CGPoint = .zero) -> [NSLayoutConstraint] {
        assertLayoutability(self)
        var constraints = [NSLayoutConstraint]()
        if axis.contains(.horizontal) { constraints.append(centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: constant.x)) }
        if axis.contains(.vertical) { constraints.append(centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant.y)) }
        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    /// Constraints width and height anchors to the given constant size.
    ///
    /// - Parameter size: Size to be used for creating constraints.
    /// - Returns: Created and already activated constraints.
    @discardableResult func constrainToConstant(size: CGSize) -> [NSLayoutConstraint] {
        assertLayoutability(self)
        let constraints = [
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height)
        ]
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
}
