//
//  TextFieldDelegate.swift
//  ImagePickerExperiment
//
//  Created by Brian M Payawal on 5/20/15.
//  Copyright (c) 2015 Brian Payawal. All rights reserved.
//

import Foundation
import UIKit

//Hides keyboard when user presses "return".
class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
        
    }
    
    // Clears text in textfields when user starts editing.
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
}

