//
//  OptionView.swift
//  Mutlu App
//
//  Created by Kullanici on 12.11.2023.
//

import UIKit

class OptionView: UIView {
    
    lazy var imageview: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var titleLbl: UILabel = {
        let l = UILabel()
        l.font = Font.kohoBold16.chooseFont
        l.textAlignment = .center
        return l
    }()
    
    lazy var subtitleLbl: UILabel = {
        let l = UILabel()
        l.font = Font.kohoMedium14.chooseFont
        l.textColor = CustomColor.gri2.color
        l.numberOfLines = 0
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
        self.layer.cornerRadius = 20
        self.addSubViews(imageview,titleLbl,subtitleLbl)
        setupLayout()
    }
    private func setupLayout() {
        imageview.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(110)
        }
        titleLbl.snp.makeConstraints { make in
            make.top.equalTo(imageview.snp.bottom)
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-40)
            make.height.equalTo(20)
        }
        subtitleLbl.snp.makeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom)
            make.leading.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().offset(-4)
            make.bottom.equalToSuperview()
        }
    }
}
