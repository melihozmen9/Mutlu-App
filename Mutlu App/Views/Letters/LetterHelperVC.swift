//
//  LetterHelperVC.swift
//  Mutlu App
//
//  Created by Kullanici on 2.12.2023.
//

import UIKit
import SnapKit

class LetterHelperVC: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
           let scrollView = UIScrollView()
           scrollView.backgroundColor = .clear
           scrollView.isScrollEnabled = true
           scrollView.showsVerticalScrollIndicator = false
           scrollView.showsHorizontalScrollIndicator = false
           return scrollView
       }()
       
       private lazy var contentView: UIView = {
           let contentView = UIView()
           contentView.backgroundColor = .clear
           return contentView
       }()
    
    private lazy var popUpView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 25
        v.backgroundColor = CustomColor.attributedWhite.color
        return v
    }()
    
    private lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
        btn.setTitleColor(.gray, for: .normal)
        btn.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var hintTitle: UILabel = {
        let l = UILabel()
        l.font = Font.kohoSemiBold18.chooseFont
        l.textColor = CustomColor.anaSarı.color
        l.text = "Mektupta değinebileceğin konular"
        return l
    }()
    
    private lazy var ruleTitle: UILabel = {
        let l = UILabel()
        l.font = Font.kohoSemiBold18.chooseFont
        l.textColor = CustomColor.anaSarı.color
        l.text = "Mektup yazarken dikkat etmen gereken kurallar"
        return l
    }()
    
    private lazy var hintLbl: UILabel = {
        let l = UILabel()
        l.font = Font.kohoMedium14.chooseFont
        l.textColor = CustomColor.metinGrisi2.color
        l.text = "Tomografi, bir tür sihirli makinedir! Doktorların, vücudun içine bakmalarına yardımcı olur. Bu makine sayesinde, vücudumuzun içinde neler olduğunu görmek için özel bir ışık kullanılır. Ancak bu ışık yetişkinlerin kullanılanlardan biraz daha farklıdır, çünkü çocuklarımızın vücutları daha hassas olduğu için onları daha fazla koruruz.Tomografi, bir tür sihirli makinedir! Doktorların, vücudun içine bakmalarına yardımcı olur. Bu makine sayesinde, vücudumuzun içinde neler olduğunu görmek için özel bir ışık kullanılır. Ancak bu ışık yetişkinlerin kullanılanlardan biraz daha farklıdır, çünkü çocuklarımızın vücutları daha hassas olduğu için onları daha fazla koruruz.Tomografi, bir tür sihirli makinedir! Doktorların, vücudun içine bakmalarına yardımcı olur. Bu makine sayesinde, vücudumuzun içinde neler olduğunu görmek için özel bir ışık kullanılır. Ancak bu ışık yetişkinlerin kullanılanlardan biraz daha farklıdır, çünkü çocuklarımızın vücutları daha hassas olduğu için onları daha fazla koruruz."
        l.numberOfLines = 0
        return l
    }()
    
    private lazy var ruleLbl: UILabel = {
        let l = UILabel()
        l.font = Font.kohoMedium14.chooseFont
        l.textColor = CustomColor.metinGrisi2.color
        l.text = "Tomografi, bir tür sihirli makinedir! Doktorların, vücudun içine bakmalarına yardımcı olur. Bu makine sayesinde, vücudumuzun içinde neler olduğunu görmek için özel bir ışık kullanılır. Ancak bu ışık yetişkinlerin kullanılanlardan biraz daha farklıdır, çünkü çocuklarımızın vücutları daha hassas olduğu için onları daha fazla sinde, vücudumuzun içinde neler olduğunu görmek için özel bir ışık kullanılır. Ancak bu ışık yetişkinlerin kullanılanlardan biraz daha farklıdır, çünkü çocuklarımızın vücutları daha hassas olduğu için onları daha fazla koruruz.Tomografi, bir tür sihirli makinedir! Doktorların, vücudun içine bakmalarına yardımcı olur. Bu makine sayesinde, vücudumuzun içinde neler olduğunu görmek için özel bir ışık kullanılır. Ancak bu ışık yetişkinlerin kullanılanlardan biraz daha farklıdır, çünkü çocuklarımızın vücutları daha hassas olduğu için onları daha fazla koruruz.Tomografi, bir tür sihirli makinedir! Doktorların, vücudun içine bakmalarına yardımcı olur. Bu makine sayesinde, vücudumuzun içinde neler olduğunu görmek için özel bir ışık kullanılır. Ancak bu ışık yetişkinlerin kullanılanlardan biraz daha farklıdır, çünkü çocuklarımızın vücutları daha hassas olduğu için onları daha fazla koruruz.koruruz."
        l.numberOfLines = 0
        return l
    }()
    
    private lazy var imageview: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "duckPaper")
        return iv
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewDidLayoutSubviews() {
            let height = (ruleLbl.frame.height + ruleLbl.frame.origin.y)
        print(height)
            scrollView.contentSize = CGSize(width: self.view.frame.width, height: height)
        }
    
    @objc func closeTapped() {
        dismiss(animated: true)
    }
    
    private func setupView() {
        view.backgroundColor = .clear
        view.addSubViews(popUpView)
        popUpView.addSubViews(closeBtn,scrollView,imageview)
        scrollView.addSubViews(contentView)
        contentView.addSubViews(hintLbl,hintTitle,ruleLbl,ruleTitle)
        setupLayout()
    }
    private func setupLayout() {
        popUpView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(62)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-105)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(closeBtn.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(imageview.snp.top).offset(-20)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
      
        hintTitle.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(20)
        }
        hintLbl.snp.makeConstraints { make in
            make.top.equalTo(hintTitle.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.lessThanOrEqualTo(ruleTitle.snp.top).offset(-35)
        }
        ruleTitle.snp.makeConstraints { make in
            make.top.equalTo(hintLbl.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        ruleLbl.snp.makeConstraints { make in
            make.top.equalTo(ruleTitle.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
        closeBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.width.height.equalTo(24)
        }
        imageview.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(180)
            make.width.equalTo(150)
        }
        contentView.layoutSubviews()
    }

}
