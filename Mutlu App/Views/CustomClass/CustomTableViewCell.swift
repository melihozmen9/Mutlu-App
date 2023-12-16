//
//  CustomTableViewCell.swift
//  Mutlu App
//
//  Created by Kullanici on 12.11.2023.
//

import UIKit
import Kingfisher

class CustomTableViewCell: UITableViewCell {
    
    private lazy var view1: UIView = {
        let v = UIView()
        return v
    }()

    
    private lazy var leftView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 15
        return v
    }()
    
    private lazy var leftIV: UIImageView = {
          let iv = UIImageView()
          iv.contentMode = .scaleAspectFit
            return iv
      }()
    
    private lazy var titleLbl: UILabel = {
        let l = UILabel()
        l.font = Font.kohoMedium16.chooseFont
        l.textAlignment = .left
        return l
    }()
    
    private lazy var subtitleLbl: UILabel = {
        let l = UILabel()
        l.font = Font.kohoMedium12.chooseFont
        l.textAlignment = .left
        l.numberOfLines = 0
        l.textColor = CustomColor.metinGrisi2.color
        return l
    }()
    
     lazy var rightView: UIView = {
        let v = UIView()
        
        v.layer.cornerRadius = 21.5
           v.clipsToBounds = true
        return v
    }()
    
     lazy var rightIV: UIImageView = {
          let iv = UIImageView()
          iv.contentMode = .scaleAspectFit
            return iv
      }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
           setupView()
          
       }
    
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    func configureQuestion(item: QuestionsModel) {
        let randomColour = CellColors.random()
        let colorsArray = randomColour.colors
        let url = URL(string: item.image)
        leftIV.kf.setImage(with: url)
        titleLbl.text = item.title
        subtitleLbl.text = item.answer
        
        view1.backgroundColor = colorsArray[1]
        leftView.backgroundColor = colorsArray[0]
        leftIV.backgroundColor = colorsArray[0]
        titleLbl.textColor = colorsArray[0]
    }
    func configureVideo(item: VideosModel) {
        let randomColour = CellColors.random()
        let colorsArray = randomColour.colors
        
        let url = URL(string: item.image)
        leftIV.kf.setImage(with: url)
        titleLbl.text = item.title
        subtitleLbl.text = item.detail
        
        view1.backgroundColor = colorsArray[1]
        leftView.backgroundColor = colorsArray[0]
        leftIV.backgroundColor = colorsArray[0]
        titleLbl.textColor = colorsArray[0]
        rightView.backgroundColor = colorsArray[2]
        rightIV.image = UIImage(named: "play")?.withTintColor(colorsArray[0])
    }
    
    private func setupView() {
        view1.layer.cornerRadius = 20
        self.addSubViews(view1)
        view1.addSubViews(leftView,titleLbl,subtitleLbl,rightView)
        rightView.addSubViews(rightIV)
        leftView.addSubViews(leftIV)
        setupLayout()
    }
    private func setupLayout() {
        view1.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.bottom.equalToSuperview().offset(-20)
        }
        leftView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(13)
            make.width.equalTo(90)
            make.bottom.equalToSuperview().offset(-13)
        }
        leftIV.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().offset(-4)
            make.bottom.equalToSuperview().offset(-14)
        }
        titleLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalTo(leftView.snp.trailing).offset(13)
            make.trailing.equalTo(rightView.snp.leading)
            make.height.equalTo(21)
        }
        subtitleLbl.snp.makeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom).offset(8)
            make.trailing.equalTo(titleLbl.snp.trailing)
            make.leading.equalTo(titleLbl.snp.leading)
            make.bottom.equalToSuperview().offset(-25)
        }
        rightView.snp.makeConstraints { make in
            make.width.height.equalTo(43)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-13)
        }
        rightIV.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-11)
            make.bottom.equalToSuperview().offset(-11)
        }
    }
}
