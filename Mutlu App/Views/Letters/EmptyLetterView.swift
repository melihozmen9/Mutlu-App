//
//  EmptyLetterView.swift
//  Mutlu App
//
//  Created by Kullanici on 2.12.2023.
//

import UIKit
import SnapKit

class EmptyLetterView: UIView {
    
    private lazy var imageview: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "duckPaper")
        iv.alpha = 0.5
        return iv
    }()
    
    private lazy var mainLbl: UILabel = {
        let l = UILabel()
        l.font = Font.kohoSemiBold18.chooseFont
        l.textColor = CustomColor.anaSarı.color
        l.textAlignment = .center
        l.text = "Yeni bir mektup yok gibi görünüyor."
        return l
    }()
    
    private lazy var detailLbl: UILabel = {
        let l = UILabel()
        l.font = Font.kohoMedium12.chooseFont
        l.textColor = CustomColor.metinGrisi.color
        l.textAlignment = .center
        l.numberOfLines = 2
        l.text = "Mektup oluştur butonuna basarak yeni bir mektup oluştur."
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
        self.backgroundColor = .clear
        self.addSubViews(imageview,mainLbl,detailLbl)
        setupLayout()
    }
    private func setupLayout() {
        imageview.snp.makeConstraints { make in
          make.top.equalToSuperview().offset(100)
            make.leading.equalToSuperview().offset(112)
            make.trailing.equalToSuperview().offset(-112)
            make.height.equalTo(250)
        }
        mainLbl.snp.makeConstraints { make in
            make.top.equalTo(imageview.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-40)
            make.height.equalTo(26)
        }
        detailLbl.snp.makeConstraints { make in
            make.top.equalTo(mainLbl.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(90)
            make.trailing.equalToSuperview().offset(-90)
            make.height.equalTo(50)
        }
    }

}
