//
//  NotificationCell.swift
//  Mutlu App
//
//  Created by Kullanici on 12.12.2023.
//

import UIKit
import SnapKit

class NotificationCell: UITableViewCell {

  private lazy var letterImageview: UIImageView = {
      let iv = UIImageView()
      iv.contentMode = .scaleAspectFit
      iv.image = UIImage(named: "notification")
      return iv
  }()
  
  private lazy var infoLbl: UILabel = {
      let l = UILabel()
      l.layer.cornerRadius = 3
      l.font = Font.kohoSemibold16.chooseFont
    l.text = "Mert mektup yolladı."
      l.textColor = .black
      return l
  }()
  
  private lazy var timeLbl: UILabel = {
      let l = UILabel()
      l.layer.cornerRadius = 3
      l.font = Font.kohoSemibold16.chooseFont
    l.textColor = .black.withAlphaComponent(0.4)
    l.text = "1sa"
      return l
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      setupView()
  }

  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  public func configure(item: [String]?) {
    guard let item = item else {return}
    infoLbl.text = item[0]
    timeLbl.text = item[1]
  }
  
  func setupView() {
    self.backgroundColor = CustomColor.attributedWhite.color
    self.addSubViews(letterImageview,infoLbl,timeLbl)
    
    setupLayout()
  }

  func setupLayout() {
    letterImageview.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(5)
      make.leading.equalToSuperview().offset(20)
      make.bottom.equalToSuperview().offset(-5)
      make.width.height.equalTo(30)
    }
    infoLbl.snp.makeConstraints { make in
      make.centerY.equalTo(letterImageview.snp.centerY)
      make.height.equalTo(25)
      make.leading.equalTo(letterImageview.snp.trailing).offset(12)
      make.trailing.equalTo(timeLbl.snp.leading).offset(-10)
    }
    timeLbl.snp.makeConstraints { make in
      make.centerY.equalTo(letterImageview.snp.centerY)
      make.height.equalTo(25)
      make.trailing.equalToSuperview().offset(-16)
      make.width.equalTo(40)
    }
  }
}
