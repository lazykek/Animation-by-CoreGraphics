//
//  SecondViewController.swift
//  Animation by CoreGraphics
//
//  Created by Ilya Cherkasov on 27.01.2021.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var animationView: SecondAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animationView.startAnimation()
        // Do any additional setup after loading the view.
    }

}
