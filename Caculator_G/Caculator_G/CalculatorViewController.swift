//
//  ViewController.swift
//  Caculator_G
//
//  Created by Lee Myeonghwan on 2022/05/25.
//

import UIKit


final class CalculatorViewController: UIViewController {
    
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var subButton: UIButton!
    @IBOutlet weak var mulButton: UIButton!
    @IBOutlet weak var divButton: UIButton!
    
    private var labelFontSize : CGFloat = 70
    private var numValueText = "0"
    private var numValueTempText = ""
    private var numDisplayText = "0"
    private var isNegative = false
    private var dotPosition  = 0
    private var isCalculating  = false
    private var newCalculation = false
    private var calculateNum = 0
    private var calculateNumTemp = 5
    private var tempIndentifier = ""
    private var numAmountTemp : Float = 0
    private var numAmount : Float = 0
    private var isNumEditing = false
    private var moreNumEqual : Float = 0
    
    
    @IBAction private func touchNumber(_ sender: UIButton) {
        let numBtnText = sender.titleLabel?.text
        if calculateNum != 0 && isCalculating{
            resetInput()
        }else if calculateNum != 0 && newCalculation{
            if dotPosition != 0 {
                numValueText.insert(".", at: numValueText.index(numValueText.startIndex, offsetBy: dotPosition))
            }
            if isNegative {
                numValueText.insert("-", at: numValueText.startIndex)
            }
            numAmount = Float(numValueText) ?? 0
            resetInput()
        }
        
        if isNumEditing == false {
            numValueText = numBtnText!
            numDisplayText = numBtnText!
            if isNegative {
                numDisplayText.insert("-", at: numDisplayText.startIndex)
            }
            numLabel.text = numDisplayText
            isNumEditing = true
        }
        else if numValueText.count <= 8 {
            numValueText += numBtnText!
            if dotPosition == 0{
                numDisplayText = numValueText
                addCommaText(count: numValueText.count, numDisplayText: &numDisplayText)
                if isNegative {
                    numDisplayText.insert("-", at: numDisplayText.startIndex)
                }
            }else{
                numDisplayText += numBtnText!
            }
            resizeLabelFont(count: numValueText.count, labelFontSize: &labelFontSize)
            numLabel.text! = numDisplayText
            numLabel.font = UIFont.systemFont(ofSize: labelFontSize)
        }
    }
    
    @IBAction func calculate(_ sender: UIButton) {
        isNumEditing = false
        isCalculating = true
        let replacingDiplayText = numDisplayText.replacingOccurrences(of: ",", with: "")
        numAmount = Float(replacingDiplayText) ?? 0
        
        if calculateNum != 0 && isCalculating{
            sender.configuration?.background.backgroundColor = .white
            sender.configuration?.baseForegroundColor = .systemOrange
            //caculate
        }
        switch sender.restorationIdentifier{
        case "add":
            calculateNum = 1
        case "sub":
            calculateNum = 2
        case "mul":
            calculateNum = 3
        case "div":
            calculateNum = 4
        default:
            calculateNum = 0
        }
        if calculateNum != calculateNumTemp{
            sender.configuration?.background.backgroundColor = .white
            sender.configuration?.baseForegroundColor = .systemOrange
            controlCaculateButtonColor(count: calculateNumTemp)
            calculateNumTemp = calculateNum
        }
    }
    
    @IBAction func equalSign(_ sender: UIButton) {
        if numValueTempText == "" {
            if dotPosition != 0 {
                numValueText.insert(".", at: numValueText.index(numValueText.startIndex, offsetBy: dotPosition))
            }
            if isNegative {
                numValueText.insert("-", at: numValueText.startIndex)
            }
            numAmountTemp = Float(numValueText) ?? 0
        }
        else{
            numAmountTemp = Float(numValueTempText) ?? 0
        }

        switch calculateNum{
        case 1:
            addtion(numAmountTemp: numAmountTemp)
        default:
            break
        }
        var resultDisplayText = String(numAmount)
        if resultDisplayText[resultDisplayText.index(resultDisplayText.endIndex, offsetBy: -1)] == "0" && resultDisplayText[resultDisplayText.index(resultDisplayText.endIndex, offsetBy: -2)] == "."
        {
            resultDisplayText.remove(at: resultDisplayText.index(resultDisplayText.endIndex, offsetBy: -1))
            resultDisplayText.remove(at: resultDisplayText.index(resultDisplayText.endIndex, offsetBy: -1))
        }
        let resultDotPositionText = resultDisplayText[..<(resultDisplayText.firstIndex(of: ".") ?? resultDisplayText.endIndex)]
        let isResultNagative = resultDisplayText[resultDisplayText.startIndex] == "-" ? true : false
        let resultNegativeCount = isResultNagative ? 1 : 0
        addCommaResultText(count: resultDotPositionText.count - resultNegativeCount, numDisplayText: &resultDisplayText,isNagative: isResultNagative)
        resizeLabelFont(count: resultDisplayText.count, labelFontSize: &labelFontSize)
        numLabel.font = UIFont.systemFont(ofSize: labelFontSize)
        controlCaculateButtonColor(count: calculateNum)
        numLabel.text = resultDisplayText
        numLabel.font = UIFont.systemFont(ofSize: labelFontSize)
        numDisplayText = resultDisplayText
        newCalculation = true
        calculateNumTemp = 5
        labelFontSize = 70
        isNegative = isResultNagative ? true : false
        numValueTempText = String(numAmountTemp)
    }
    
    func addtion(numAmountTemp : Float){
        numAmount += numAmountTemp
        print("----caculate----")
        print("numAmount")
        print(numAmount)
        print("numAmountTemp")
        print(numAmountTemp)
    }
    
    
    @IBAction func resetLabel(_ sender: UIButton) {
        numLabel.text = "0"
        numDisplayText = "0"
        numValueText = "0"
        numValueTempText = ""
        isNegative = false
        isCalculating = false
        isNumEditing = false
        newCalculation = false
        calculateNumTemp = 5
        dotPosition = 0
        labelFontSize = 70
        numLabel.font = UIFont.systemFont(ofSize: labelFontSize)
        controlCaculateButtonColor(count: calculateNum)
        numAmount = 0
        numAmountTemp = 0
    }
    
    
    @IBAction func changeSign(_ sender: UIButton) {
        isNegative.toggle()
        if isNegative {
            numDisplayText.insert("-", at: numDisplayText.startIndex)
        }
        else
        {
            numDisplayText.remove(at: numDisplayText.startIndex)
        }
        numLabel.text! = numDisplayText
    }
    
    
    @IBAction func addDot(_ sender: UIButton) {
        if newCalculation{
            if dotPosition != 0 {
                numValueText.insert(".", at: numValueText.index(numValueText.startIndex, offsetBy: dotPosition))
            }
            if isNegative {
                numValueText.insert("-", at: numValueText.startIndex)
            }
            numAmount = Float(numValueText) ?? 0
            resetInput()
            dotPosition = numDisplayText.count
            numDisplayText.insert(".", at: numDisplayText.index(numDisplayText.startIndex, offsetBy: dotPosition))
            numLabel.text = numDisplayText
            isNumEditing = true
        }else{
            if dotPosition == 0 && numValueText.count < 9{
                dotPosition = numDisplayText.count
                numDisplayText.insert(".", at: numDisplayText.index(numDisplayText.startIndex, offsetBy: dotPosition))
                numLabel.text = numDisplayText
                isNumEditing = true
            }
        }
    }
    
    func controlCaculateButtonColor(count:Int){
        switch count{
        case 1:
            addButton.configuration?.background.backgroundColor = .systemOrange
            addButton.configuration?.baseForegroundColor = .white
        case 2:
            subButton.configuration?.background.backgroundColor = .systemOrange
            subButton.configuration?.baseForegroundColor = .white
        case 3:
            mulButton.configuration?.background.backgroundColor = .systemOrange
            mulButton.configuration?.baseForegroundColor = .white
        case 4:
            divButton.configuration?.background.backgroundColor = .systemOrange
            divButton.configuration?.baseForegroundColor = .white
        default:
            break
        }
    }
    func resetInput(){
        numLabel.text = "0"
        numDisplayText = "0"
        numValueText = "0"
        numValueTempText = ""
        isNegative = false
        isCalculating = false
        isNumEditing = false
        newCalculation = false
        calculateNumTemp = 5
        dotPosition = 0
        labelFontSize = 70
        numLabel.font = UIFont.systemFont(ofSize: labelFontSize)
        controlCaculateButtonColor(count: calculateNum)
    }
    
    func addCommaText(count: Int, numDisplayText: inout String)
    {

        if count >= 4 && count < 7
        {
            numDisplayText.insert(",", at: numDisplayText.index(numDisplayText.endIndex,offsetBy: -3))
        }
        else if count >= 7 && count <= 9
        {
            numDisplayText.insert(",", at: numDisplayText.index(numDisplayText.endIndex,offsetBy: -3))
            numDisplayText.insert(",", at: numDisplayText.index(numDisplayText.endIndex,offsetBy: -7))
        }
    }
    
    func addCommaResultText(count: Int, numDisplayText: inout String,isNagative:Bool)
    {
        if count >= 4 && count < 7
        {
            numDisplayText.insert(",", at: numDisplayText.index(numDisplayText.firstIndex(of: ".") ?? numDisplayText.endIndex,offsetBy: -3))
        }
        else if count >= 7 && count <= 9
        {
            numDisplayText.insert(",", at: numDisplayText.index(numDisplayText.firstIndex(of: ".") ?? numDisplayText.endIndex,offsetBy: -3))
            numDisplayText.insert(",", at: numDisplayText.index(numDisplayText.firstIndex(of: ".") ?? numDisplayText.endIndex,offsetBy: -7))
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
    func resizeResultLabelFont(count:Int, labelFontSize : inout CGFloat)
    {
        switch count{
        case 7:
            labelFontSize = 70
        case 8:
            labelFontSize = 68
        case 9:
            labelFontSize = 66
        case 10...20:
            labelFontSize = 60
        default:
            break
        }
    }
    
    
}
