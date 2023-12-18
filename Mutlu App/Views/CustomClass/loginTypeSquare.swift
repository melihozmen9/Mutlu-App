//
//  loginTypeSquare.swift
//  Mutlu App
//
//  Created by Kullanici on 11.11.2023.
//

import UIKit

class loginTypeSquare: UIView {

    lazy var imageview: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var Lbl: UILabel = {
        let l = UILabel()
        l.font = Font.kohoMedium14.chooseFont
        l.textColor = CustomColor.gri2.color
        l.textAlignment = .center
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupView()
    }
  
  required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    private func setupView() {
        self.addSubViews(imageview,Lbl)
        self.layer.cornerRadius = 16
        self.layer.borderWidth = 1.0
        self.layer.borderColor = CustomColor.lightGri2.color.cgColor
        setupLayout()
    }
    private func setupLayout() {
        imageview.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(9)
            make.leading.equalToSuperview().offset(28)
            make.trailing.equalToSuperview().offset(-28)
            make.bottom.equalToSuperview().offset(-27)
        }
        Lbl.snp.makeConstraints { make in
            make.top.equalTo(imageview.snp.bottom).offset(3)
            make.leading.equalToSuperview().offset(13)
            make.trailing.equalToSuperview().offset(-13)
            make.bottom.equalToSuperview()
        }
    }

}

extension loginTypeSquare {
    func setBorder(color: UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1.0
    }
}
