//
//  ViewController.swift
//  Caculator_G
//
//  Created by Lee Myeonghwan on 2022/05/25.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var numLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func touchNumber(_ sender: UIButton) {
        let numText = sender.titleLabel?.text
        if numLabel.text == "0"{
            numLabel.text = numText
        }
        else{
            numLabel.text! += numText!
        }
    }
    
}

