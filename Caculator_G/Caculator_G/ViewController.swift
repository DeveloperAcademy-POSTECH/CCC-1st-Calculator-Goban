//
//  ViewController.swift
//  Caculator_G
//
//  Created by Lee Myeonghwan on 2022/05/25.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var numLabel: UILabel!
    var labelFontSize : CGFloat = 80
    var numValueText : String = ""
    var numCommaText : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func touchNumber(_ sender: UIButton) {
        let numBtnText = sender.titleLabel?.text
        if numLabel.text == "0"{
            numLabel.text = numBtnText
            numValueText += numBtnText!
        }
        else if numValueText.count <= 8 {
            numValueText += numBtnText!
            numCommaText = numValueText
            addCommaText(count: numValueText.count, numCommaText: &numCommaText)
            resizeLabelFont(count: numValueText.count, labelFontSize: &labelFontSize)
            numLabel.text! = numCommaText
            numLabel.font = UIFont.systemFont(ofSize: labelFontSize)
        }
    }
    
    @IBAction func resetLabel(_ sender: UIButton) {
        numLabel.text = "0"
        numValueText = ""
        labelFontSize = 80
        numLabel.font = UIFont.systemFont(ofSize: labelFontSize)
    }
}

func addCommaText(count:Int, numCommaText : inout String)
{
    if count >= 4 && count <= 6
    {
        numCommaText.insert(",", at: numCommaText.index(numCommaText.endIndex,offsetBy: -3))
    }
    else if count >= 7 && count <= 9
    {
        numCommaText.insert(",", at: numCommaText.index(numCommaText.endIndex,offsetBy: -3))
        numCommaText.insert(",", at: numCommaText.index(numCommaText.endIndex,offsetBy: -7))
    }
}

func resizeLabelFont(count:Int, labelFontSize : inout CGFloat)
{
    switch count {
    case 7:
        labelFontSize -= 13
    case 8:
        labelFontSize -= 10
    case 9:
        labelFontSize -= 7
    default:
        break
    }
}
