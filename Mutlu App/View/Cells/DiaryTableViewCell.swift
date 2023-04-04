//
//  DiaryTableViewCell.swift
//  Mutlu App
//
//  Created by Kullanici on 22.03.2023.
//

import UIKit
import SnapKit

class DiaryTableViewCell: UITableViewCell {
    
    
    
    var dayLabel: UILabel = {
        let label = UILabel()
        label.text = "22 Mart Çarşamba"
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        label.numberOfLines = 0
        label.font = UIFont(name: "EduNSWACTFoundation-Bold", size: 20)
        return label
    }()
    
    var dayImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "sun"))
        return image
    }()
    
    var colorArray: [UIColor] = [
        UIColor(red: 0.89, green: 1.00, blue: 0.87, alpha: 1.00),
        UIColor(red: 0.67, green: 0.92, blue: 0.83, alpha: 1.00),
        UIColor(red: 0.69, green: 0.87, blue: 1.00, alpha: 1.00),
        UIColor(red: 1.00, green: 0.49, blue: 0.49, alpha: 1.00)
    ]

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        let customView = UIView(frame: contentView.frame)
//        customView.backgroundColor = colorArray.shuffled()[0]
        customView.backgroundColor = .white
        customView.layer.masksToBounds = true
        customView.layer.cornerRadius = 10
        contentView.addSubview(customView)
        customView.addSubview(dayLabel)
        customView.addSubview(dayImage)
        
//        contentView.backgroundColor = UIColor.clear
//        contentView.isOpaque = false
//        //contentView.backgroundView = UIView(frame: CGRect.zero)
        
        dayLabel.snp.makeConstraints { make in
            make.centerY.equalTo(customView.snp.centerY)
            make.right.equalTo(customView.snp.right)
            make.width.equalTo(customView.snp.width).multipliedBy(0.7)
            make.height.equalTo(customView.snp.height).multipliedBy(0.5)
        }
        
        dayImage.snp.makeConstraints { make in
            make.centerY.equalTo(dayLabel.snp.centerY)
            make.width.height.equalTo(customView.snp.width).multipliedBy(0.2)
            make.left.equalTo(customView.snp.left).offset(customView.frame.size.width * 0.03)
        }
        
        customView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.snp.edges).inset(10)
        }
    }

}
