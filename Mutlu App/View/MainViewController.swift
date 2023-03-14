//
//  MainViewController.swift
//  Mutlu App
//
//  Created by Kullanici on 14.03.2023.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.text = "Hoşgeldin İSİM"
        label.textAlignment = .center
        label.font = UIFont(name: "Verdana-Bold", size: 16)
        return label
    }()

    private let optionImageView1: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "sorular"))
        imageView.layer.cornerRadius = 10.0
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let optionLabel1: UILabel = {
        let label = UILabel()
        label.text = "Sorularım var"
        label.backgroundColor = UIColor(red: 1.00, green: 0.62, blue: 0.95, alpha: 0.5)
        label.layer.cornerRadius = 10.0
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let optionImageView2: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "çizgiFilm"))
        imageView.layer.cornerRadius = 10.0
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let optionLabel2: UILabel = {
        let label = UILabel()
        label.text = "Çizgi Film"
        label.backgroundColor = UIColor(red: 0.28, green: 0.86, blue: 0.98, alpha: 0.5)
        label.layer.cornerRadius = 10.0
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let optionImageView3: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "günlük"))
        imageView.layer.cornerRadius = 10.0
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let optionLabel3: UILabel = {
        let label = UILabel()
        label.text = "Günlük"
        label.backgroundColor = UIColor(red: 1.00, green: 0.79, blue: 0.34, alpha: 0.5)
        label.layer.cornerRadius = 10.0
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    
    private func configure() {
        title = "Ana Sayfa"
        navigationController?.navigationBar.barTintColor = UIColor.white
        view.backgroundColor = UIColor(red: 0.99, green: 0.92, blue: 0.99, alpha: 1.00)
        view.addSubview(topLabel)
        view.addSubview(optionImageView1)
        view.addSubview(optionLabel1)
        view.addSubview(optionImageView2)
        view.addSubview(optionLabel2)
        view.addSubview(optionImageView3)
        view.addSubview(optionLabel3)
        
        topLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(25)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
        }
        
        optionImageView1.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(25)
            make.left.equalTo(view).offset(view.frame.size.width * 0.17)
            make.height.equalTo(170)
            make.width.equalTo(140)
        }
        
        optionLabel1.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(60)
            make.height.equalTo(50)
            make.width.equalTo(130)
            make.leading.equalTo(optionImageView1.snp.trailing).offset(20)
        }

        optionLabel2.snp.makeConstraints { make in
            make.top.equalTo(optionImageView1.snp.bottom).offset(75)
            make.height.equalTo(50)
            make.width.equalTo(100)
            make.centerX.equalTo(optionImageView1.snp.centerX)
        }
        
        optionImageView2.snp.makeConstraints { make in
            make.centerX.equalTo(optionLabel1.snp.centerX)
            make.centerY.equalTo(optionLabel2.snp.centerY)
            make.height.equalTo(170)
            make.width.equalTo(140)
        }
        
        optionImageView3.snp.makeConstraints { make in
            make.top.equalTo(optionLabel2.snp.bottom).offset(75)
            make.centerX.equalTo(optionLabel2.snp.centerX)
            make.height.equalTo(170)
            make.width.equalTo(140)
        }
        
        optionLabel3.snp.makeConstraints { make in
            make.top.equalTo(optionImageView2.snp.bottom).offset(75)
            make.centerX.equalTo(optionImageView2.snp.centerX)
            make.centerY.equalTo(optionImageView3.snp.centerY)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
    }
}
