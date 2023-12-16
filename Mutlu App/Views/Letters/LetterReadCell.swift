//
//  LetterReadCell.swift
//  Mutlu App
//
//  Created by Kullanici on 3.12.2023.
//

import UIKit

class LetterReadCell: UICollectionViewCell {
    
    private lazy var imageview: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private lazy var letterTextview: UITextView = {
        let tv = UITextView()
        tv.font = Font.vollkornMedium15.chooseFont
        tv.textColor = CustomColor.letterTextColor.color
        tv.backgroundColor = .clear
        tv.text = "Tomografi, bir tür sihirli makinedir! Doktorların, vücudun içine bakmalarına yardımcı olur. Bu makine sayesinde, vücudumuzun içinde neler olduğunu görmek için özel bir ışık kullanılır. Ancak bu ışık yetişkinlerin kullanılanlardan biraz daha farklıdır, çünkü çocuklarımızın vücutları daha hassas olduğu için onları daha fazla sinde, vücudumuzun içinde neler olduğunu görmek için özel bir ışık kullanılır. Ancak bu ışık yetişkinlerin kullanılanlardan biraz daha farklıdır, çünkü çocuklarımızın vücutları daha hassas olduğu için onları daha fazla koruruz.Tomografi, bir tür sihirli makinedir! Doktorların, vücudun içine bakmalarına yardımcı olur. Bu makine sayesinde, vücudumuzun içinde neler olduğunu görmek için özel bir ışık kullanılır. Ancak bu ışık yetişkinlerin kullanılanlardan biraz daha farklıdır, çünkü çocuklarımızın vücutları daha hassas olduğu için onları daha fazla koruruz.Tomografi, bir tür sihirli makinedir! Doktorların, vücudun içine bakmalarına yardımcı olur. Bu makine sayesinde, vücudumuzun içinde neler olduğunu görmek için özel bir ışık kullanılır. Ancak bu ışık yetişkinlerin kullanılanlardan biraz daha farklıdır, çünkü çocuklarımızın vücutları daha hassas olduğu için onları daha fazla koruruz.koruruz.Tomografi, bir tür sihirli makinedir! Doktorların, vücudun içine bakmalarına yardımcı olur. Bu makine sayesinde, vücudumuzun içinde neler olduğunu görmek için özel bir ışık kullanılır. Ancak bu ışık yetişkinlerin kullanılanlardan biraz daha farklıdır, çünkü çocuklarımızın vücutları daha hassas olduğu için onları daha fazla sinde, vücudumuzun içinde neler olduğunu görmek için özel bir ışık kullanılır. Ancak bu ışık yetişkinlerin kullanılanlardan biraz daha farklıdır, çünkü çocuklarımızın vücutları daha hassas olduğu için onları daha fazla koruruz.Tomografi, bir tür sihirli makinedir! Doktorların, vücudun içine bakmalarına yardımcı olur. Bu makine sayesinde, vücudumuzun içinde neler olduğunu görmek için özel bir ışık kullanılır. Ancak bu ışık yetişkinlerin kullanılanlardan biraz daha farklıdır, çünkü çocuklarımızın vücutları daha hassas olduğu için onları daha fazla koruruz.Tomografi, bir tür sihirli m"
        return tv
    }()
    
    override init(frame: CGRect) {
          super.init(frame: .zero)
          setupView()
      }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(data: [String : Any], isMine:Bool ) {
        letterTextview.text = data["text"] as? String
        imageview.image = UIImage(named: isMine ? "paper" : "pinkPaper")
    }
    
    private func setupView() {
        self.backgroundColor = .clear
        self.addSubViews(imageview)
        self.insertSubview(letterTextview, aboveSubview: imageview)
        setupLayout()
    }
    private func setupLayout() {
        imageview.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
        letterTextview.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(70)
            make.leading.equalToSuperview().offset(47)
            make.trailing.equalToSuperview().offset(-45)
            make.bottom.equalToSuperview().offset(-70)
        }
    }
    
}
