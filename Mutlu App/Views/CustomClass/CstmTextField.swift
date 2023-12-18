//
//  CstmTextField.swift
//  Mutlu App
//
//  Created by Kullanici on 11.11.2023.
//

import UIKit

class CstmTextField: UIView {

    let attributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: CustomColor.lightGri.color,
        .font: UIFont(name: "Koho-Medium", size: 16)!
    ]
    
    lazy var imageview: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        //iv.image = UIImage(systemName: "eye.slash")?.withTintColor(CustomColor.anaSarı.color)
        return iv
    }()
    
    lazy var textField: UITextField = {
           let tf = UITextField()
           tf.backgroundColor = .clear
           tf.font = Font.kohoMedium16.chooseFont
           return tf
       }()
    
    
      override init(frame: CGRect) {
          super.init(frame: .zero)
          
          setupView()
      }
    
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    private func setupView() {
        self.backgroundColor = CustomColor.attributedWhite.color
        self.layer.cornerRadius = 16
        self.layer.borderWidth = 1.0
        self.layer.borderColor = CustomColor.lightGri2.color.cgColor
        self.addSubViews(textField,imageview)
        setupLayout()
    }
    private func setupLayout() {
        textField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(17)
            make.bottom.equalToSuperview().offset(-10)
            make.trailing.equalTo(imageview.snp.leading)
        }
        imageview.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.trailing.equalToSuperview().offset(-17)
            make.width.equalTo(17)
        }
    }
}
