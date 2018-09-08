//
//  ViewController.swift
//  Example
//
//  Copyright © 2018 kwiecien.co. All rights reserved.
//

import UIKit
import Layoutable

final class ViewController: UIViewController {

    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view.layoutable()
    }()

    private let headerCenterView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view.layoutable()
    }()

    private let contentContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view.layoutable()
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view.layoutable()
    }()

    override func loadView() {
        view = UIView()
        view.addSubview(headerView)
        view.addSubview(contentContainerView)
        headerView.addSubview(headerCenterView)
        contentContainerView.addSubview(contentView)

        headerView.constrainToSuperviewEdges(excluding: [.bottom])
        headerView.heightAnchor.constraint(equalToConstant: 200).isActive = true

        headerCenterView.constrainToConstant(size: .init(width: 80, height: 80))
        headerCenterView.constrainCenterToSuperview()

        contentContainerView.constrainToSuperviewEdges(excluding: [.top])
        contentContainerView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true

        contentView.constrainToSuperviewEdges(insets: .init(top: 80, left: 20, bottom: 20, right: 20))
    }
}
