//
//  ViewController.swift
//  Caculator_G
//
//  Created by Lee Myeonghwan on 2022/05/25.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        // Do any additional setup after loading the view.
    }

    @IBAction func touchNumber(_ sender: UIButton) {
        let num = sender.titleLabel?.text
        print("touched \(num ?? "error")")
    }
    
}

