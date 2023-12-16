//
//  CustomButton.swift
//  Mutlu App
//
//  Created by Kullanici on 7.11.2023.
//

import UIKit

class CustomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = CustomColor.anaSarı.color
        self.layer.cornerRadius = 30
        self.titleLabel?.font = Font.kohoSemiBold18.chooseFont
        self.setTitleColor(.white, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

