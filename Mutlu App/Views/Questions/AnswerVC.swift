//
//  AnswerVC.swift
//  Mutlu App
//
//  Created by Kullanici on 13.11.2023.
//

import UIKit
import SnapKit
import FirebaseCoreInternal
import Kingfisher

class AnswerVC: UIViewController {
    
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
    
    private lazy var view1: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 20
        v.backgroundColor = CustomColor.purpleOpacity15.color.withAlphaComponent(0.15)
        return v
    }()
    
    private lazy var imageview: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
//        iv.image = UIImage(named:"doctor")
        return iv
    }()
    
    private lazy var questionLabel: UILabel = {
        let l = UILabel()
        l.layer.cornerRadius = 3
        l.backgroundColor = .white
        l.font = Font.kohoSemiBold24.chooseFont
//        tf.text = "Kemoterapi Nedir?"
        return l
    }()

    private lazy var answerTf: UITextView = {
        let tf = UITextView()
        tf.backgroundColor = .white
        tf.font = Font.kohoSemibold16.chooseFont
        tf.textColor = CustomColor.metinGrisi.color
//        tf.text = "Tomografi, bir tür sihirli makinedir! Doktorların, vücudun içine bakmalarına yardımcı olur. Bu makine sayesinde, vücudumuzun içinde neler olduğunu görmek için özel bir ışık kullanılır. Ancak bu ışık yetişkinlerin kullanılanlardan biraz daha farklıdır, çünkü çocuklarımızın vücutları daha hassas olduğu için onları daha fazla koruruz.  İşlem sırasında, çocuklar bir yatak üzerine yatırılır ve bu yatak, büyük bir halkanın içinden geçer. Bu halka, vücudun farklı bölgelerinden resimler çeker ve bu resimler bilgisayar yardımıyla bir araya getirilir. Böylece doktorlar, iç organları ve kemikleri daha iyi görebilirler. Tomografi yapılırken, çocuklar sessizce yatmalı ve hareket etmemelidirler, bu yüzden bazen bu işlem için yardımcı olacak özel teknikler veya ilaçlar kullanılabilir. İşlem çok kısa sürer ve hiçbir şey hissetmezsiniz, sadece biraz garip veya sıkıcı gelebilir. Tomografi, doktorların çocukların vücutlarını daha iyi anlamalarına ve sorunları tespit etmelerine yardımcı olur. Her şeyden önemlisi, çocuklarınızın sağlığına yardımcı olan harika bir araçtır."
        return tf
    }()
    
    private lazy var lineView: UIView = {
        let v = UIView()
        v.backgroundColor = .purple
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    public func configure(item: QuestionsModel) {
        let url = URL(string: item.image)
        imageview.kf.setImage(with: url)
        questionLabel.text = item.title
        answerTf.text = item.answer
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubViews(view1,questionLabel,lineView,answerTf)
        view1.addSubViews(imageview)
        setupLayout()
    }
    private func setupLayout() {
        view1.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(28)
            make.trailing.equalToSuperview().offset(-20)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(205)
        }
        imageview.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(36)
            make.trailing.equalToSuperview().offset(-36)
            make.bottom.equalToSuperview()
        }
        questionLabel.snp.makeConstraints { make in
            make.top.equalTo(view1.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(30)
        }
        lineView.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(8)
            make.leading.equalTo(questionLabel.snp.leading)
            make.height.equalTo(1)
            make.width.equalTo(50)
        }
        answerTf.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview()
        }
        contentView.layoutSubviews()
    }

   
}
