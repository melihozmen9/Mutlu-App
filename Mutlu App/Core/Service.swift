//
//  Service.swift
//  Mutlu App
//
//  Created by Kullanici on 24.03.2023.
//

import UIKit
import Firebase

class Service {
    
    static func singUpUser(email: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (_ error: Error?) -> Void ) {
        let auth = Auth.auth()
        
        auth.createUser(withEmail: email, password: password) { (authResult, error) in
            if error != nil {
                onError(error!)
                return 
            }

        }
    }
    
    static func getData() {
       
        
    }
    
    static func createAlertController(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        return alert
    }
}
