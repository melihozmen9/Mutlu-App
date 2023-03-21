//
//  AnswerTableViewCell.swift
//  Mutlu App
//
//  Created by Kullanici on 20.03.2023.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {
    
    
    
    
    var imageView1: UIImageView = {
        let imageview = UIImageView(image: UIImage())
        imageview.layer.masksToBounds = true
        imageview.contentMode = .scaleAspectFit
        return imageview
    }()
    var answerLabel1: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Kalam-Light", size: 18)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.backgroundColor = .white
        label.sizeToFit()
        //label.minimumScaleFactor = 0.5 // minimum ölçek faktörü
        return label
    }()
    var imageView2: UIImageView = {
        let imageview = UIImageView(image: UIImage())
        imageview.layer.masksToBounds = true
        imageview.contentMode = .scaleAspectFit
        return imageview
    }()
    var answerLabel2: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Kalam-Light", size: 18)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.backgroundColor = .white
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
        customView.backgroundColor = .white
        contentView.addSubview(customView)
        customView.addSubview(answerLabel1)
        customView.addSubview(imageView1)
        customView.addSubview(answerLabel2)
        customView.addSubview(imageView2)
        design()
        customView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(contentView)
        }
        answerLabel1.snp.makeConstraints { make in
            make.top.equalTo(customView)
            make.left.equalTo(customView)
            make.height.equalTo(contentView).multipliedBy(0.5)
            make.width.equalTo(contentView).multipliedBy(0.7)
        }
        imageView1.snp.makeConstraints { make in
            make.centerY.equalTo(answerLabel1.snp.centerY)
            make.width.height.equalTo(contentView).multipliedBy(0.3)
            make.right.equalTo(contentView.snp.right)
        }
        answerLabel2.snp.makeConstraints { make in
            make.top.equalTo(answerLabel1.snp.bottom)
            make.left.equalTo(imageView2.snp.right)
            make.right.equalTo(customView)
            make.height.equalTo(contentView).multipliedBy(0.5)
            make.width.equalTo(contentView).multipliedBy(0.7)
        }
        imageView2.snp.makeConstraints { make in
            make.width.height.equalTo(contentView).multipliedBy(0.3)
            make.left.equalTo(contentView.snp.left)
            make.centerY.equalTo(answerLabel2.snp.centerY)
        }
    }
    func design() {
        
        
    }

}
