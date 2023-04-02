//
//  MainViewController.swift
//  Mutlu App
//
//  Created by Kullanici on 14.03.2023.
//

import UIKit
import SnapKit
import Firebase

final class MainViewController: UIViewController {
    
    private let backgroundImage = UIImage(named: "background2")
    private var backgroundImageView = UIImageView()
    
    
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
    
    func setupLabelTap() {
        
        let optionLabel1Tap = UITapGestureRecognizer(target: self, action: #selector(optionLabel1Tapped(_:)))
        self.optionLabel1.isUserInteractionEnabled = true
        self.optionLabel1.addGestureRecognizer(optionLabel1Tap)
        self.optionImageView1.isUserInteractionEnabled = true
        self.optionImageView1.addGestureRecognizer(optionLabel1Tap)
        
        let optionLabel2Tap = UITapGestureRecognizer(target: self, action: #selector(optionLabel2Tapped(_:)))
        self.optionLabel2.isUserInteractionEnabled = true
        self.optionLabel2.addGestureRecognizer(optionLabel2Tap)
        self.optionImageView2.isUserInteractionEnabled = true
        self.optionImageView2.addGestureRecognizer(optionLabel2Tap)
        
        let optionLabel3Tap = UITapGestureRecognizer(target: self, action: #selector(optionLabel3Tapped(_:)))
        self.optionLabel3.isUserInteractionEnabled = true
        self.optionLabel3.addGestureRecognizer(optionLabel3Tap)
        self.optionImageView3.isUserInteractionEnabled = true
        self.optionImageView3.addGestureRecognizer(optionLabel3Tap)
        
    }
    
    private let optionLabel1: UILabel = {
        let label = UILabel()
        label.text = "Sorular"
        label.backgroundColor = UIColor(red: 1.00, green: 0.62, blue: 0.95, alpha: 0.5)
        label.layer.cornerRadius = 10.0
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    @objc func optionLabel1Tapped(_ sender: UITapGestureRecognizer) {
       // Kodunuzu buraya yazın
        let questionViewController = UINavigationController(rootViewController: QuestionsViewController())
        questionViewController.modalPresentationStyle = .fullScreen
        questionViewController.modalTransitionStyle = .crossDissolve
         present(questionViewController, animated: true, completion: nil)
    }
    
    @objc func optionLabel2Tapped(_ sender: UITapGestureRecognizer) {
       // Kodunuzu buraya yazın
        let videoViewController = UINavigationController(rootViewController: VideoViewController())
        videoViewController.modalPresentationStyle = .fullScreen
        videoViewController.modalTransitionStyle = .crossDissolve
         present(videoViewController, animated: true, completion: nil)
    }
    
    @objc func optionLabel3Tapped(_ sender: UITapGestureRecognizer) {
       // Kodunuzu buraya yazın
        let diaryViewController = UINavigationController(rootViewController: DiaryViewController())
        diaryViewController.modalPresentationStyle = .fullScreen
        diaryViewController.modalTransitionStyle = .crossDissolve
         present(diaryViewController, animated: true, completion: nil)
    }
    
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
        let imageView = UIImageView(image: UIImage(named: "günlük2"))
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
    
    private func createBackButton() -> UIBarButtonItem {
        let button = UIBarButtonItem(title: "Çıkış Yap", style: .plain, target: self, action: #selector(backButtonTapped))
        button.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemPink, NSAttributedString.Key.font: UIFont(name: "Mansalva-Regular", size: 18)!], for: .normal)
        return button
    }
    
    lazy var backButton: UIBarButtonItem = {
        return createBackButton()
    }()
    
    @objc private func backButtonTapped() {
        let auth = Auth.auth()
        
        do {
            try auth.signOut()
            let defaults = UserDefaults.standard
            defaults.set(false, forKey: "isUserSignIn")
            dismiss(animated: true, completion: nil)
        } catch let signOutError {
            self.present(Service.createAlertController(title: "OK", message: signOutError.localizedDescription), animated: true, completion: nil)
        }
        
     
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        setupLabelTap()
    
    }
    
    private func buttons(){
        setupLabelTap()
    }
    
    private func design() {
        title = "Ana Sayfa"
        navigationItem.leftBarButtonItem = backButton
        backgroundImageView.contentMode = .scaleAspectFill
         backgroundImageView.alpha = 0.1
         backgroundImageView = UIImageView(image: backgroundImage)
         view.insertSubview(backgroundImageView, at: 0)
    }
    
    private func configure() {
        design()
        view.addSubview(topLabel)
        view.addSubview(optionImageView1)
        view.addSubview(optionLabel1)
        view.addSubview(optionImageView2)
        view.addSubview(optionLabel2)
        view.addSubview(optionImageView3)
        view.addSubview(optionLabel3)
        
        topLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(view.frame.size.height * 0.04)
            make.left.equalTo(view).offset(view.frame.size.width * 0.30)
            make.right.equalTo(view).offset(-view.frame.size.width * 0.30)
        }
        
        optionImageView1.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(view.frame.size.height * 0.04)
            make.left.equalTo(view).offset(view.frame.size.width * 0.1)
            make.height.equalTo(view.frame.size.height * 0.20)
            make.width.equalTo(view.frame.size.width * 0.38)
        }
        
        optionLabel1.snp.makeConstraints { make in
            make.centerY.equalTo(optionImageView1.snp.centerY)
            make.centerX.equalTo(optionImageView2.snp.centerX)
            make.height.equalTo(view.frame.size.height * 0.05)
            make.width.equalTo(view.frame.size.width * 0.3)
        }
        
        optionImageView2.snp.makeConstraints { make in
            make.right.equalTo(view).offset(-view.frame.size.width * 0.1)
            make.top.equalTo(optionImageView1.snp.bottom).offset(view.frame.size.height * 0.04)
            make.height.equalTo(optionImageView1)
            make.width.equalTo(optionImageView1)
        }
        
        optionLabel2.snp.makeConstraints { make in
            make.height.equalTo(optionLabel1)
            make.width.equalTo(optionLabel1)
            make.centerX.equalTo(optionImageView1)
            make.centerY.equalTo(optionImageView2)
        }
        
        optionImageView3.snp.makeConstraints { make in
            make.top.equalTo(optionImageView2.snp.bottom).offset(view.frame.size.height * 0.04)
            make.centerX.equalTo(optionImageView1.snp.centerX)
            make.height.equalTo(optionImageView1)
            make.width.equalTo(optionImageView1)
        }
        
        optionLabel3.snp.makeConstraints { make in
            make.centerX.equalTo(optionLabel1.snp.centerX)
            make.centerY.equalTo(optionImageView3.snp.centerY)
            make.height.equalTo(optionLabel1)
            make.width.equalTo(optionLabel1)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view)
        }
    }
}
