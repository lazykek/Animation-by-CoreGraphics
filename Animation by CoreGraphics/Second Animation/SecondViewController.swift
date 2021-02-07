//
//  SecondViewController.swift
//  Animation by CoreGraphics
//
//  Created by Ilya Cherkasov on 27.01.2021.
//

import UIKit

class SecondViewController: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        let animationView = SecondAnimationView()
        view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        animationView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        animationView.sizeToFit()
        animationView.layoutIfNeeded()
        animationView.backgroundColor = .clear

        animationView.startAnimation()
    }

}
