//
//  PhotoCell.swift
//  Mutlu App
//
//  Created by Kullanici on 11.11.2023.
//

import UIKit
import Kingfisher

class PhotoCell: UICollectionViewCell {
    
    private lazy var imageview: UIImageView = {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFit
            return iv
        }()
    
    override init(frame: CGRect) {
          super.init(frame: .zero)
          setupView()
      }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(imageURL: URL) {
        imageview.kf.setImage(with: imageURL)
    }
    
    private func setupView() {
        self.addSubViews(imageview)
        setupLayout()
    }
    private func setupLayout() {
        imageview.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
