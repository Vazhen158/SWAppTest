//
//  CurrencyTextField.swift
//  SWAppTest
//
//  Created by Андрей Важенов on 26.08.2022.
//

import Foundation
import UIKit

protocol ActionMailTextFieldProtocol: AnyObject {
    func typingText(text: String)
    func clenOutTextField()
}

class CurrencyTextField: UITextField {
    
    weak var textFieldDelegate: ActionMailTextFieldProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .white
        borderStyle = .none
        layer.cornerRadius = 10
        textColor = .black
        layer.borderWidth = 2
        layer.borderColor = UIColor.gray.cgColor
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))
        leftViewMode = .always
        clearButtonMode = .always
        returnKeyType = .done
        placeholder = "Enter amount"
        font = UIFont(name: "Apple SD Gothic Neo", size: 20)
        tintColor = .black
        translatesAutoresizingMaskIntoConstraints = false
    }
}
extension CurrencyTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let rangeText = Range(range, in: text) {
            let updateText = text.replacingCharacters(in: rangeText, with: string)
            textFieldDelegate?.typingText(text: updateText)
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textFieldDelegate?.clenOutTextField()
        return true
    }
}
