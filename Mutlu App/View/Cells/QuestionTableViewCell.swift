//
//  QuestionTableViewCell.swift
//  Mutlu App
//
//  Created by Kullanici on 20.03.2023.
//

import UIKit
import SnapKit
import Kingfisher

class QuestionTableViewCell: UITableViewCell {
    
    var customImageView: UIImageView = {
        let image = UIImageView(image: UIImage())
        return image
    }()
    
    func configureUrl(with urlString: String) {
        if let url = URL(string: urlString) {
            customImageView.kf.setImage(with: url)
        }
    }
    
    var questionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Kalam-Bold", size: 20)
        label.textColor = .white
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
        customView.backgroundColor = UIColor(red: 0.25, green: 0.75, blue: 0.79, alpha: 1.00)
        customView.layer.masksToBounds = true
        customView.layer.cornerRadius = 10
        contentView.addSubview(customView)
        customView.addSubview(questionLabel)
        customView.addSubview(customImageView)

        customView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.snp.edges).inset(10)
        }
        
        customImageView.snp.makeConstraints { make in
            make.left.equalTo(customView.snp.left)
            make.top.equalTo(customView.snp.top)
            make.centerY.equalTo(questionLabel.snp.centerY)
            make.width.equalTo(customImageView.snp.height)
        }
        questionLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(customView)
            make.left.equalTo(customImageView.snp.right).offset(contentView.frame.size.width * 0.07)
        }
    }
    
}
