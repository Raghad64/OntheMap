//
//  FindLocationSetup.swift
//  OnTheMap3
//
//  Created by Raghad Mah on 09/01/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit

extension FindLocationViewController: UITextFieldDelegate {
    
    //MARK: touchesBegan & textFieldShouldReturn
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return textField.resignFirstResponder()
    }
}
