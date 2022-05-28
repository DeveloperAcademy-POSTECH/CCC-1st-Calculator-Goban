//
//  ViewController.swift
//  Caculator_G
//
//  Created by Lee Myeonghwan on 2022/05/25.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var numLabel: UILabel!
    var labelFontSize : CGFloat = 70
    var numValueText : String = "0"
    var numDisplayText : String = "0"
    var isNegative : Bool = false
    var dotPosition : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func touchNumber(_ sender: UIButton) {
        let numBtnText = sender.titleLabel?.text
        if numLabel.text == "0" || numLabel.text == "-0"{
            numValueText = numBtnText!
            numDisplayText = numBtnText!
            if isNegative == true{
                numDisplayText.insert("-", at: numDisplayText.startIndex)
            }
            numLabel.text = numDisplayText
        }
        else if numValueText.count <= 8 {
            numValueText += numBtnText!
            numDisplayText += numBtnText!
            if dotPosition == 0{
                addCommaText(count: numValueText.count, numDisplayText: &numDisplayText)
            }
            resizeLabelFont(count: numValueText.count, labelFontSize: &labelFontSize)
            numLabel.text! = numDisplayText
            numLabel.font = UIFont.systemFont(ofSize: labelFontSize)
        }
    }
    
    @IBAction func resetLabel(_ sender: UIButton) {
        numLabel.text = "0"
        numDisplayText = "0"
        numValueText = "0"
        isNegative = false
        dotPosition = 0
        labelFontSize = 70
        numLabel.font = UIFont.systemFont(ofSize: labelFontSize)
    }
    
    
    @IBAction func changeSign(_ sender: UIButton) {
        isNegative.toggle()
        if isNegative == true{
            numDisplayText.insert("-", at: numDisplayText.startIndex)
        }
        else
        {
            numDisplayText.remove(at: numDisplayText.startIndex)
        }
        numLabel.text! = numDisplayText
    }
    
    
    @IBAction func addDot(_ sender: UIButton) {
        if dotPosition == 0{
            dotPosition = numDisplayText.count
            numDisplayText.insert(".", at: numDisplayText.index(numDisplayText.startIndex, offsetBy: dotPosition))
            numLabel.text = numDisplayText
        }
    }
    
}

func addCommaText(count:Int, numDisplayText : inout String)
{
    if count == 4
    {
        numDisplayText.insert(",", at: numDisplayText.index(numDisplayText.endIndex,offsetBy: -3))
    }
    else if count == 7
    {
        numDisplayText.insert(",", at: numDisplayText.index(numDisplayText.endIndex,offsetBy: -7))
    }
}

func resizeLabelFont(count:Int, labelFontSize : inout CGFloat)
{
    switch count {
    case 7:
        labelFontSize -= 10
    case 8:
        labelFontSize -= 8
    case 9:
        labelFontSize -= 6
    default:
        break
    }
}
