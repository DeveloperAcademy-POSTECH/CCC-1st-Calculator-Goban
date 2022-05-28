//
//  ViewController.swift
//  Caculator_G
//
//  Created by Lee Myeonghwan on 2022/05/25.
//

import UIKit


final class CaculatorViewController: UIViewController {
    
    @IBOutlet weak var numLabel: UILabel!
    var labelFontSize : CGFloat = 70
    var numValueText = "0"
    var numDisplayText = "0"
    var isNegative = false
    

    @IBAction private func touchNumber(_ sender: UIButton) {
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
            numDisplayText = numValueText
            addCommaText(count: numValueText.count, numDisplayText: &numDisplayText)
            resizeLabelFont(count: numValueText.count, labelFontSize: &labelFontSize)
            if isNegative == true{
                numDisplayText.insert("-", at: numDisplayText.startIndex)
            }
            numLabel.text! = numDisplayText
            numLabel.font = UIFont.systemFont(ofSize: labelFontSize)
        }
    }
    
    @IBAction func resetLabel(_ sender: UIButton) {
        numLabel.text = "0"
        numDisplayText = "0"
        numValueText = "0"
        isNegative = false
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
}

func addCommaText(count: Int, numDisplayText: inout String)
{
    if count >= 4 && count <= 6
    {
        numDisplayText.insert(",", at: numDisplayText.index(numDisplayText.endIndex,offsetBy: -3))
    }
    else if count >= 7 && count <= 9
    {
        numDisplayText.insert(",", at: numDisplayText.index(numDisplayText.endIndex,offsetBy: -3))
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
