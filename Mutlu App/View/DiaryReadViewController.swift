//
//  DiaryReadViewController.swift
//  Mutlu App
//
//  Created by Kullanici on 23.03.2023.
//

import UIKit

class DiaryReadViewController: UIViewController {

    private let backgroundImage = UIImage(named: "background2")
    private var backgroundImageView = UIImageView()
    
    private let diaryImageView: UIImageView = {
        let imageview = UIImageView(image: UIImage(named: "diaryPage"))
        imageview.contentMode = .scaleToFill
        return imageview
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
        
        return label
    }()
    
    private func createBackButton() -> UIBarButtonItem {
        let button = UIBarButtonItem(title: "Geri", style: .plain, target: self, action: #selector(backButtonTapped))
        button.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemPink, NSAttributedString.Key.font: UIFont(name: "Mansalva-Regular", size: 18)!], for: .normal)
        return button
    }
    
    lazy var backButton: UIBarButtonItem = {
        return createBackButton()
    }()
    
    @objc private func backButtonTapped() {
     dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    func configure() {
        design()
        view.addSubview(diaryImageView)
        view.addSubview(diaryLabel)
        
        diaryImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(view.frame.size.width * 0.05)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.snp.width).multipliedBy(0.9)
            make.bottom.equalTo(view).offset(-view.frame.size.width * 0.1)
        }
        
        diaryLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(view.frame.size.width * 0.13)
            make.left.equalTo(view.snp.left).offset(view.frame.size.width * 0.13)
            make.right.equalTo(view.snp.right).offset(-view.frame.size.width * 0.13)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-view.frame.size.width * 0.18)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view)
        }
    }
    
    func design() {
        title = "Günlüğüm"
        navigationItem.leftBarButtonItem = backButton
        backgroundImageView.contentMode = .scaleAspectFit
        backgroundImageView.alpha = 0.1
        backgroundImageView = UIImageView(image: backgroundImage)
        view.insertSubview(backgroundImageView, at: 0)
    }
}
