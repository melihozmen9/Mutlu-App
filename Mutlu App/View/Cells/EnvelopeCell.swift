//
//  EnvelopeCell.swift
//  Mutlu App
//
//  Created by Kullanici on 27.08.2023.
//

import UIKit
import TinyConstraints
class EnvelopeCell: UITableViewCell {
    
    private lazy var imageview: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "envelope")
        return iv
    }()
    
    private lazy var nameLbl: UILabel = {
        let l = UILabel()
        l.layer.cornerRadius = 3
        l.text = "isim"
        return l
    }()
    
    private lazy var Lbl: UILabel = {
        let l = UILabel()
        l.layer.cornerRadius = 3
        l.text = "12 haziran 2008"
        return l
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.contentView.addSubViews(imageview)
        imageview.addSubViews(nameLbl)
        setupLayout()
    }
    private func setupLayout() {
        imageview.edgesToSuperview()
        imageview.height(contentView.frame.size.height * 0.27)
        
        nameLbl.edgesToSuperview(excluding: [.bottom, .right], insets: .top(40) + .left(60))
        nameLbl.height(contentView.frame.size.height * 0.40)
        nameLbl.width(contentView.frame.size.width * 0.3)
    }
    
}
