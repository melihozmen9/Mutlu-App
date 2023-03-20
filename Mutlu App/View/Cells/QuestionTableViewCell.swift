//
//  QuestionTableViewCell.swift
//  Mutlu App
//
//  Created by Kullanici on 20.03.2023.
//

import UIKit
import SnapKit

class QuestionTableViewCell: UITableViewCell {
    
    var customImageView: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "arrowtriangle.right.circle")?.withTintColor(.black, renderingMode: .alwaysOriginal))
        return image
    }()
    
    var questionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
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
        
        addSubview(questionLabel)
        contentView.addSubview(customImageView)
        
        // set constraints for customImageView using SnapKit
        customImageView.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left)
            make.top.equalTo(contentView.snp.top)
            make.centerY.equalTo(questionLabel.snp.centerY)
            make.width.equalTo(customImageView.snp.height)
        }
        questionLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(customImageView.snp.right)
        }
        
    }
    
}
