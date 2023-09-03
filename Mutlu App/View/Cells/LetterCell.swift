//
//  LetterCell.swift
//  Mutlu App
//
//  Created by Kullanici on 3.09.2023.
//

import UIKit
import TinyConstraints
class LetterCell: UITableViewCell {
    
        private let diaryImageView: UIImageView = {
            let imageview = UIImageView(image: UIImage(named: "diaryPage"))
            imageview.contentMode = .scaleToFill
            return imageview
        }()
    
    private let leftIV: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "heart")
        return iv
    }()
    
    private let rightIV: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "lion")
        return iv
    }()
    
    
        var diaryLabel: UILabel = {
            let label = UILabel()
            label.textColor = .black
            label.backgroundColor = .clear
            label.layer.masksToBounds = true
            label.layer.cornerRadius = 10
            label.font = UIFont(name: "Kalam-Regular", size: 18)
            label.baselineAdjustment = .alignBaselines
            label.textAlignment = .left
            label.numberOfLines = 0
            return label
        }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: [String : Any],userType:String ) {
        diaryLabel.text = data["text"] as? String
        if data["sender"] as? String == userType {
            leftIV.isHidden = true
        } else {
            rightIV.isHidden = true
        }
    }
    
    private func setupView() {
        contentView.addSubview(diaryImageView)
        diaryImageView.addSubview(diaryLabel)
        contentView.addSubview(leftIV)
        contentView.addSubview(rightIV)
        setupLayout()
    }
    private func setupLayout() {
        leftIV.edgesToSuperview(excluding: [.right,.bottom])
        leftIV.height(50)
        leftIV.width(50)
        
        rightIV.edgesToSuperview(excluding: [.left,.bottom])
        rightIV.height(50)
        rightIV.width(50)
        
        diaryImageView.leftToRight(of: leftIV)
        diaryImageView.top(to: contentView)
        diaryImageView.bottom(to: contentView)
        diaryImageView.rightToLeft(of: rightIV)
        
        diaryLabel.edgesToSuperview(insets:.left(contentView.frame.width * 0.1) +
                                        .top(contentView.frame.width * 0.1) +
                                        .bottom(contentView.frame.width * 0.1) +
                                        .right(contentView.frame.width * 0.1) 
        )
       
    }
}
