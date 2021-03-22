//
//  ViewController.swift
//  CodeInputView
//
//  Created by lian on 2021/3/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let inputV = PasswordInputView(origin: CGPoint(x: 0, y: 100), itemSize: CGSize(width: 60, height: 80), itemCount: 4, insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), spacing: 20)
        view.addSubview(inputV)
    }


}

