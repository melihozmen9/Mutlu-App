//
//  LetterCell.swift
//  Mutlu App
//
//  Created by Kullanici on 2.12.2023.
//

import UIKit
import SnapKit

class LettersCell: UICollectionViewCell {
    
    private lazy var imageview: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "letterPurple")
        return iv
    }()
    
    private lazy var nameLbl: UILabel = {
        let l = UILabel()
        l.layer.cornerRadius = 3
        l.font = Font.kohoSemibold16.chooseFont
//        if imageview.image == UIImage(named: "letterPurple") {
//
//        }
        return l
    }()
    
    override init(frame: CGRect) {
          super.init(frame: .zero)
          setupView()
      }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(indexpath: Int, name: String) {
        nameLbl.text = name
        if indexpath % 2 == 0 {
            imageview.image = UIImage(named: "letterPurple")
            nameLbl.textColor = .white
        } else {
            imageview.image = UIImage(named: "letterYellow")
            nameLbl.textColor = CustomColor.purpleEnvelope.color
        }
        
    }
    private func setupView() {
        self.backgroundColor = .clear
        self.addSubViews(imageview)
        imageview.addSubViews(nameLbl)
        setupLayout()
    }
    private func setupLayout() {
        imageview.snp.makeConstraints { make in
            make.leading.top.bottom.trailing.equalToSuperview()
        }
        nameLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(22)
            make.leading.equalToSuperview().offset(23)
            make.trailing.equalToSuperview().offset(-23)
            make.height.equalTo(21)
        }
    }
}
