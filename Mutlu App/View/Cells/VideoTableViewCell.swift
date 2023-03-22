//
//  VideoTableViewCell.swift
//  Mutlu App
//
//  Created by Kullanici on 22.03.2023.
//

import UIKit

class VideoTableViewCell: UITableViewCell {
    
    var subView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor(red: 0.93, green: 0.81, blue: 1.00, alpha: 0.3)
        return view
    }()
    
    var customImageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "bilmece"))
        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 10.0
        return image
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Kalam-Regular", size: 25)
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        label.numberOfLines = 0
        return label
    }()
    
    var explanationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Kalam-Light", size: 18)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
        let customView = UIView(frame: contentView.frame)
        customView.backgroundColor = UIColor(red: 1.00, green: 0.92, blue: 0.65, alpha: 1.00)
        customView.layer.masksToBounds = true
        customView.layer.cornerRadius = 10
        contentView.addSubview(customView)
        customView.addSubview(customImageView)
        customView.addSubview(subView)
        subView.addSubview(nameLabel)
        subView.addSubview(explanationLabel)
        
        
        customView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.snp.edges).inset(10)
        }
        
        customImageView.snp.makeConstraints { make in
            make.left.equalTo(customView.snp.left).inset(7)
            make.top.equalTo(customView.snp.top)
            make.centerY.equalTo(subView.snp.centerY)
            make.width.equalTo(contentView.frame.size.width * 0.3)
        }
        
        subView.snp.makeConstraints { make in
            make.top.equalTo(customView.snp.top).inset(7)
            make.bottom.equalTo(customView.snp.bottom).inset(7)
            make.right.equalTo(customView.snp.right).inset(7)
            make.left.equalTo(customImageView.snp.right).offset(contentView.frame.size.width * 0.03)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(subView.snp.top)
            make.left.equalTo(subView.snp.left)
            make.right.equalTo(subView.snp.right)
            make.height.equalTo(contentView).multipliedBy(0.43)
        }
        
        explanationLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.bottom.left.right.equalTo(subView)
        }
        
    }

}
