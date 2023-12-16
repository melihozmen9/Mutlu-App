//
//  ZoomCell.swift
//  Mutlu App
//
//  Created by Kullanici on 2.12.2023.
//

import UIKit
import SnapKit
import Kingfisher

class ZoomCell: UITableViewCell {
    
    private lazy var activityImageview: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 6
        return iv
    }()
    
    private lazy var activityLbl: UILabel = {
        let l = UILabel()
        l.textColor = .black
        l.font = Font.kohoMedium15.chooseFont
        return l
    }()
    
    private lazy var dateLbl: UILabel = {
        let l = UILabel()
        l.textColor = CustomColor.metinGrisi.color
        l.font = Font.kohoMedium15.chooseFont
        return l
    }()
    
    private lazy var locationLbl: UILabel = {
        let l = UILabel()
        l.textColor = CustomColor.metinGrisi.color
        l.font = Font.kohoRegular14.chooseFont
        return l
    }()
    
    private lazy var calendarImageview: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "calendar")
        return iv
    }()
    
    private lazy var locationImageview: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "location")
        return iv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(item: ZoomModel) {
        activityLbl.text = item.title
        //activityImageview.kf.setImage(with: URL(string: item.image))
        activityImageview.image = UIImage(named: "zoomImage")
        dateLbl.text = item.date
        locationLbl.text = item.location
    }

    private func setupView() {
        self.layer.cornerRadius = 14
        self.clipsToBounds = true
        contentView.backgroundColor = .white
        contentView.addSubViews(activityImageview,activityLbl,dateLbl,calendarImageview,locationLbl,locationImageview)
        setupLayout()
    }
    private func setupLayout() {
        activityImageview.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(74)
        }
        activityLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalTo(activityImageview.snp.trailing).offset(12)
            make.height.equalTo(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        calendarImageview.snp.makeConstraints { make in
            make.height.width.equalTo(18)
            make.leading.equalTo(activityImageview.snp.trailing).offset(12)
            make.top.equalTo(activityLbl.snp.bottom).offset(14)
        }
        dateLbl.snp.makeConstraints { make in
            make.top.equalTo(calendarImageview.snp.top)
            make.leading.equalTo(calendarImageview.snp.trailing).offset(4)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(calendarImageview.snp.bottom)
        }
        locationImageview.snp.makeConstraints { make in
            make.height.width.equalTo(18)
            make.leading.equalTo(activityImageview.snp.trailing).offset(12)
            make.top.equalTo(calendarImageview.snp.bottom).offset(8)
        }
        locationLbl.snp.makeConstraints { make in
            make.top.equalTo(locationImageview.snp.top)
            make.leading.equalTo(locationImageview.snp.trailing).offset(4)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(locationImageview.snp.bottom)
        }
    }
}
