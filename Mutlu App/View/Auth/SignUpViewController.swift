//
//  SignUpViewController.swift
//  Mutlu App
//
//  Created by Kullanici on 14.03.2023.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    private let backgroundImage = UIImage(named: "background2")
    private var backgroundImageView = UIImageView()

    private let username: UITextField = {
        let username = UITextField()
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Mansalva-Regular", size: 22)!
        ]
        username.attributedPlaceholder = NSAttributedString(string: "Nickname", attributes: attributes)
        username.backgroundColor = UIColor(red: 0.98, green: 0.83, blue: 0.56, alpha: 0.5)
        username.layer.cornerRadius = 10.0
        return username
    }()
    
    private let password: UITextField = {
        let password = UITextField()
        password.isSecureTextEntry = true
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Mansalva-Regular", size: 22)!
        ]
        password.attributedPlaceholder = NSAttributedString(string: "Password", attributes: attributes)
        password.backgroundColor = UIColor(red: 0.98, green: 0.83, blue: 0.56, alpha: 0.5)
        password.layer.cornerRadius = 10.0
        return password
    }()
    
    private let signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Giriş Yap"
        label.textAlignment = .center
        label.font = UIFont(name: "EduNSWACTFoundation-Bold", size: 20)
        return label
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0.98, green: 0.83, blue: 0.56, alpha: 1.00)
        button.layer.cornerRadius = 10.0
        button.frame.size.width = 40
        button.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        return button
    }()

    @objc func signUpTapped() {
        let auth = Auth.auth()
        auth.createUser(withEmail: (username.text! + "@gmail.com"), password: password.text!) { (authResult, error) in
            if error != nil {
                self.present(Service.createAlertController(title: "Error", message: error!.localizedDescription), animated: true, completion: nil)
            }
            let mainViewController = UINavigationController(rootViewController: MainViewController())
            mainViewController.modalPresentationStyle = .fullScreen
            mainViewController.modalTransitionStyle = .crossDissolve
            self.present(mainViewController, animated: true, completion: nil)
        }
       
    }
    
    private let signUpImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "signupFront")!)
        imageView.layer.cornerRadius = 10.0
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
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
    
    
    private func configure() {
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.alpha = 0.1
        backgroundImageView = UIImageView(image: backgroundImage)
        signUpImageView.isHidden = true
        view.insertSubview(backgroundImageView, at: 0)
        navigationController?.navigationBar.barTintColor = UIColor.gray
        navigationItem.leftBarButtonItem = backButton
        title = "Kayıt Ol"
        view.addSubview(username)
        view.addSubview(password)
        view.addSubview(signUpButton)
        view.addSubview(signUpImageView)
        signUpButton.addSubview(signUpLabel)
        
        username.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(view.frame.size.height * 0.05)
            make.left.equalTo(view).offset(view.frame.size.width * 0.2)
            make.right.equalTo(view).offset(-view.frame.size.width * 0.2)
            make.height.equalTo(view.frame.size.height * 0.1)
        }
        
        password.snp.makeConstraints { make in
            make.top.equalTo(username.snp.bottom).offset(view.frame.size.height * 0.03)
            make.left.right.equalTo(username)
            make.height.equalTo(username)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(password.snp.bottom).offset(view.frame.size.height * 0.05)
            make.left.equalTo(view).offset(view.frame.size.width * 0.38)
            make.right.equalTo(view).offset(-view.frame.size.width * 0.38)
            make.height.equalTo(view.frame.size.height * 0.07)
        }
        
        signUpImageView.snp.makeConstraints { make in
            make.top.equalTo(signUpButton.snp.bottom).offset(view.frame.size.height * 0.05)
            make.left.equalTo(view).offset(view.frame.size.width * 0.1)
            make.right.equalTo(view).offset(-view.frame.size.width * 0.1)
            make.bottom.equalToSuperview()
        }
        
        signUpLabel.snp.makeConstraints { make in
            make.top.equalTo(signUpButton.snp.top)
            make.leading.equalTo(signUpButton.snp.leading)
            make.bottom.equalTo(signUpButton.snp.bottom)
            make.trailing.equalTo(signUpButton.snp.trailing)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view)
        }
    }
}
