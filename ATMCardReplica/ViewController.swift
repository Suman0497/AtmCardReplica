//
//  ViewController.swift
//  ATMCardReplica
//
//  Created by apple on 27/09/21.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var enterCardNumberTextField: UITextField!
    @IBOutlet weak var additionButton: UIButton!
    @IBOutlet weak var subtractionButton: UIButton!
    @IBOutlet weak var multiplicationButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var divisionButton: UIButton!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var calOutLet: UITextField!

    @IBAction func textFieldAction(_ sender: UITextField) {
        cardNumberLabel.text = enterCardNumberTextField.text
    }
    
    // closure
    let calculator = { (num1: Int, num2: Int, result: Int) -> Int in
           return result
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        additionButton.layer.cornerRadius = 12
        subtractionButton.layer.cornerRadius = 12
        multiplicationButton.layer.cornerRadius = 12
        divisionButton.layer.cornerRadius = 12
        resultLabel.layer.cornerRadius = 12
        
        cardNumberLabel.text = "xxxx xxxx xxxx xxxx"
        enterCardNumberTextField.delegate = self
        enterCardNumberTextField.addTarget(self, action: #selector(textFieldAction), for: .allEvents)
        enterCardNumberTextField.addTarget(self, action: #selector(reformatAsCardNumber), for: .editingChanged)

    }
    
    @objc func reformatAsCardNumber(textField: UITextField) {
        var targetCursorPosition = 0
        if let startPosition = textField.selectedTextRange?.start {
            targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: startPosition)
        }
        
        var cardNumberWithoutSpaces = ""
        if let text = textField.text {
            cardNumberWithoutSpaces = self.removeNonDigits(string: text, andPreserveCursorPosition: &targetCursorPosition)
        }
        
        if cardNumberWithoutSpaces.count > 16 {
            textField.text = previousTextFieldContent
            textField.selectedTextRange = previousSelection
            return
        }
        
        let cardNumberWithSpaces = self.insertSpacesEveryFourDigitsIntoString(string: cardNumberWithoutSpaces, andPreserveCursorPosition: &targetCursorPosition)
        textField.text = cardNumberWithSpaces
        
        if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
            textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
        }
    }

    func removeNonDigits(string: String, andPreserveCursorPosition cursorPosition: inout Int) -> String {
        var digitsOnlyString = ""
        let originalCursorPosition = cursorPosition
        
        for i in Swift.stride(from: 0, to: string.count, by: 1) {
            let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
            if characterToAdd >= "0" && characterToAdd <= "9" {
                digitsOnlyString.append(characterToAdd)
            }
            else if i < originalCursorPosition {
                cursorPosition -= 1
            }
        }
        
        return digitsOnlyString
    }

    func insertSpacesEveryFourDigitsIntoString(string: String, andPreserveCursorPosition cursorPosition: inout Int) -> String {
        var stringWithAddedSpaces = ""
        let cursorPositionInSpacelessString = cursorPosition
        
        for i in Swift.stride(from: 0, to: string.count, by: 1) {
            if i > 0 && (i % 4) == 0 {
                stringWithAddedSpaces.append(contentsOf: " ")
                if i < cursorPositionInSpacelessString {
                    cursorPosition += 1
                }
            }
            let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
            stringWithAddedSpaces.append(characterToAdd)
        }
        
        return stringWithAddedSpaces
    }


}

extension ViewController : UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        if textField == enterCardNumberTextField {
            previousTextFieldContent = textField.text;
            previousSelection = textField.selectedTextRange;
        }
        
        return true
    }
}



// calculator

extension ViewController {
    
     @IBAction func additionButtonTapped(_ sender: UIButton) {
         
    let results = calculator(Int(calOutLet.text!)!, Int(secondTextField.text!)!,(Int(calOutLet.text!)! + (Int(secondTextField.text!)!)))
         resultLabel.text = String(results)
         
     }

     @IBAction func subtractionButtonTapped(_ sender: UIButton) {
         
         let results = calculator(Int(calOutLet.text!)!, Int(secondTextField.text!)!,(Int(calOutLet.text!)! - (Int(secondTextField.text!)!)))
         resultLabel.text = String(results)
     }
     
     @IBAction func multiplicationButtonTapped(_ sender: UIButton) {
         
         let results = calculator(Int(calOutLet.text!)!, Int(secondTextField.text!)!,(Int(calOutLet.text!)! * (Int(secondTextField.text!)!)))
         resultLabel.text = String(results)
     }
     
     @IBAction func divisionButtonTapped(_ sender: UIButton) {
         let results = calculator(Int(calOutLet.text!)!, Int(secondTextField.text!)!,(Int(calOutLet.text!)! / (Int(secondTextField.text!)!)))
         resultLabel.text = String(results)
     }
}
