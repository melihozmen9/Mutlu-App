//
//  CustomTextField.swift
//  Mutlu App
//
//  Created by Kullanici on 19.08.2023.
//

import UIKit

class CustomTextField: UITextField {
    
    var insets: UIEdgeInsets
    
    let attributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.white,
        .font: UIFont(name: "Mansalva-Regular", size: 22)!
    ]
   
    init(insets:UIEdgeInsets = UIEdgeInsets(top:0,left:10,bottom: 0,right:12)) {
        self.insets = insets
        super.init(frame: .zero)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Mansalva-Regular", size: 22)!
        ]
       self.backgroundColor = UIColor(red: 0.98, green: 0.83, blue: 0.56, alpha: 0.5)
       self.layer.cornerRadius = 10.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

