//
//  PhotoCell.swift
//  Mutlu App
//
//  Created by Kullanici on 11.11.2023.
//

import UIKit
import SnapKit

class GetStartedCell: UICollectionViewCell {
    
    private lazy var topImageview: UIImageView = {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFit
            iv.image = UIImage(named: "contributors")
            return iv
        }()
    
    private lazy var imageview: UIImageView = {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFit
            return iv
        }()
    
    private lazy var introLbl: UILabel = {
        let l = UILabel()
        l.font = Font.kohoSemiBold24.chooseFont
        l.textColor = CustomColor.anaSarı.color
        l.numberOfLines = 2
        l.textAlignment = .center
        return l
    }()
    
    private lazy var detailLbl: UILabel = {
        let l = UILabel()
        l.font = Font.kohoMedium16.chooseFont
        l.textColor = CustomColor.metinGrisi2.color
        l.numberOfLines = 2
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
    
    func configure(item: (String,String,UIImage)) {
        imageview.image = item.2
        introLbl.text = item.0
        detailLbl.text = item.1
    }
    
    private func setupView() {
        self.addSubViews(topImageview, imageview, introLbl, detailLbl)
        setupLayout()
    }
    private func setupLayout() {
        topImageview.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(68)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-21)
            make.height.equalTo(92)
        }
        imageview.snp.makeConstraints { make in
            make.top.equalTo(topImageview.snp.bottom).offset(54)
            make.leading.equalToSuperview().offset(120)
            make.trailing.equalToSuperview().offset(-120)
            make.height.equalTo(240)
        }
        introLbl.snp.makeConstraints { make in
            make.top.equalTo(imageview.snp.bottom).offset(56)
            make.leading.equalToSuperview().offset(28)
            make.trailing.equalToSuperview().offset(-28)
            make.height.equalTo(64)
        }
        detailLbl.snp.makeConstraints { make in
            make.top.equalTo(introLbl.snp.bottom)
            make.leading.equalToSuperview().offset(34)
            make.trailing.equalToSuperview().offset(-34)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
}
