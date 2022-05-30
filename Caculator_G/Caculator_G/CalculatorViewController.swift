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
    @IBOutlet weak var acButton: UIButton!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        acButton.layer.cornerRadius = acButton.frame.width / 2
        acButton.layer.masksToBounds = true
        acButton.backgroundColor = UIColor.lightGray
    }
    
    
    @IBAction private func touchNumber(_ sender: UIButton) {
        let numBtnText = sender.titleLabel?.text
        // 일반 계산일 경우와 연속 계산일 경우 나눠서 처리
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
        
        if isNumEditing == false || numValueText == "0"{
            numValueText = numBtnText!
            numDisplayText = numBtnText!
            if isNegative {
                numDisplayText.insert("-", at: numDisplayText.startIndex)
            }
            numLabel.text = numDisplayText
            isNumEditing = true
            if numValueText != "0"{
                acButton.setTitle("C", for: .normal)
            }
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
            numLabel.font = UIFont.systemFont(ofSize: labelFontSize)
            numLabel.text! = numDisplayText
        }
    }
    
    @IBAction func calculate(_ sender: UIButton) {
        //버튼색상 변경
        sender.configuration?.background.backgroundColor = .white
        sender.configuration?.baseForegroundColor = .systemOrange
        
        isNumEditing = false
        isCalculating = true
        // 현재 화면에 있는 값을 계산할 베이스에 저장
        let replacingDiplayText = numDisplayText.replacingOccurrences(of: ",", with: "")
        numAmount = Float(replacingDiplayText) ?? 0
        
        // 버튼의 identifier에 따라 연산 번호 할당
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
        // 이전에 다른 연산을 클릭하고 현재 연산을 클릭했을떄 버튼 색상변경
        if calculateNum != calculateNumTemp{
            controlCaculateButtonColor(count: calculateNumTemp)
            calculateNumTemp = calculateNum
        }
    }
    
    @IBAction func equalSign(_ sender: UIButton) {
        // 연산할 값에 할당 현재 numValueText 에 저장된 값 타입캐스팅 후 할당
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
        // 연산 번호에 따라 계산
        switch calculateNum{
        case 1:
            addtion(numAmountTemp: numAmountTemp)
        case 2:
            subtraction(numAmountTemp: numAmountTemp)
        case 3:
            multiplication(numAmountTemp: numAmountTemp)
        case 4:
            division(numAmountTemp: numAmountTemp)
        default:
            break
        }
        // 결과 텍스트 표시 후 연속 계산
        refineResultText()
        newCalculation = true
        calculateNumTemp = 5
    }
    
    private func addtion(numAmountTemp: Float){
        numAmount += numAmountTemp
    }
    private func subtraction(numAmountTemp: Float){
        numAmount -= numAmountTemp
    }
    private func multiplication(numAmountTemp: Float){
        numAmount *= numAmountTemp
    }
    private func division(numAmountTemp: Float){
        numAmount /= numAmountTemp
    }
    
    @IBAction func touchPercent(_ sender: UIButton) {
        let replacingDiplayText = numDisplayText.replacingOccurrences(of: ",", with: "")
        numAmount = Float(replacingDiplayText) ?? 0
        numAmount /= 100.0
        refineResultText()
        isNumEditing = false
    }
    
    @IBAction func resetLabel(_ sender: UIButton) {
        acButton.setTitle("AC", for: .normal)
        resetInput()
        numAmount = 0
        numAmountTemp = 0
    }
    
    
    @IBAction func changeSign(_ sender: UIButton) {
        if isCalculating{
            if dotPosition != 0 {
                numValueText.insert(".", at: numValueText.index(numValueText.startIndex, offsetBy: dotPosition))
            }
            if isNegative {
                numValueText.insert("-", at: numValueText.startIndex)
            }
            numAmount = Float(numValueText) ?? 0
            resetInput()
            isNegative = true
            numDisplayText.insert("-", at: numDisplayText.startIndex)
            numLabel.text = numDisplayText
        }else{
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
    
    private func controlCaculateButtonColor(count: Int){
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
    private func resetInput(){
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
    
    private func refineResultText(){
        var resultDisplayText = String(numAmount)
        // 문자열 끝 .0 제거
        if resultDisplayText[resultDisplayText.index(resultDisplayText.endIndex, offsetBy: -1)] == "0" && resultDisplayText[resultDisplayText.index(resultDisplayText.endIndex, offsetBy: -2)] == "."
        {
            resultDisplayText.remove(at: resultDisplayText.index(resultDisplayText.endIndex, offsetBy: -1))
            resultDisplayText.remove(at: resultDisplayText.index(resultDisplayText.endIndex, offsetBy: -1))
        }
        // Dot(.) 의 인덱스 전까지 문자열 슬라이싱
        let resultDotPositionText = resultDisplayText[..<(resultDisplayText.firstIndex(of: ".") ?? resultDisplayText.endIndex)]
        let isResultNegative = resultDisplayText[resultDisplayText.startIndex] == "-" ? true : false
        let resultNegativeCount = isResultNegative ? 1 : 0
        // 자연로그가 뒤 "+" 제거 && comma 처리
        if (resultDisplayText.firstIndex(of: "e") != nil) {
            if let indexOfpositiveLogarithm = resultDisplayText.firstIndex(of: "+"){
                resultDisplayText.remove(at: indexOfpositiveLogarithm)
            }
        }
        else{
            addCommaResultText(count: resultDotPositionText.count - resultNegativeCount, numDisplayText: &resultDisplayText)
        }
        // 폰트 크기 지정 후 화면에 표시
        resizeResultLabelFont(count: resultDisplayText.count, labelFontSize: &labelFontSize)
        numLabel.font = UIFont.systemFont(ofSize: labelFontSize)
        numLabel.text = resultDisplayText
        numDisplayText = resultDisplayText
        controlCaculateButtonColor(count: calculateNum)
        labelFontSize = 70
        isNegative = isResultNegative ? true : false
        numValueTempText = String(numAmountTemp)
    }
    
    private func addCommaText(count: Int, numDisplayText: inout String)
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
    
    private func addCommaResultText(count: Int, numDisplayText: inout String)
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
    
    private func resizeLabelFont(count: Int, labelFontSize : inout CGFloat)
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
    private func resizeResultLabelFont(count: Int, labelFontSize: inout CGFloat)
    {
        switch count{
        case 8:
            labelFontSize = 60
        case 9:
            labelFontSize = 52
        case 10...20:
            labelFontSize = 46
        default:
            break
        }
    }
}
