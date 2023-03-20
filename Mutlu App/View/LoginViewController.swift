//
//  LoginViewController.swift
//  Mutlu App
//
//  Created by Kullanici on 14.03.2023.
//

import UIKit
import SnapKit

final class LoginViewController: UIViewController {

    private let username: UITextField = {
        let username = UITextField()
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.italicSystemFont(ofSize: 22)
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
            .font: UIFont.italicSystemFont(ofSize: 22)
        ]
        password.attributedPlaceholder = NSAttributedString(string: "Password", attributes: attributes)
        password.backgroundColor = UIColor(red: 0.98, green: 0.83, blue: 0.56, alpha: 0.5)
        password.layer.cornerRadius = 10.0
        return password
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Giriş Yap"
        label.textAlignment = .center
        label.font = UIFont(name: "EduNSWACTFoundation-Bold", size: 20)
        return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0.98, green: 0.83, blue: 0.56, alpha: 1.00)
        button.layer.cornerRadius = 10.0
        button.frame.size.width = 40
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func loginTapped() {
        let mainViewController = UINavigationController(rootViewController: MainViewController())
        mainViewController.modalPresentationStyle = .fullScreen
        mainViewController.modalTransitionStyle = .crossDissolve
         present(mainViewController, animated: true, completion: nil)
    }
    
    private let loginImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "loginFront2")!)
        imageView.layer.cornerRadius = 10.0
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
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
        design()
        view.addSubview(username)
        view.addSubview(password)
        view.addSubview(loginButton)
        view.addSubview(loginImageView)
        loginButton.addSubview(loginLabel)
        
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
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(password.snp.bottom).offset(view.frame.size.height * 0.05)
            make.left.equalTo(view).offset(view.frame.size.width * 0.38)
            make.right.equalTo(view).offset(-view.frame.size.width * 0.38)
            make.height.equalTo(view.frame.size.height * 0.07)
        }
        
        loginImageView.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(view.frame.size.height * 0.05)
            make.left.equalTo(view).offset(view.frame.size.width * 0.1)
            make.right.equalTo(view).offset(-view.frame.size.width * 0.1)
            make.bottom.equalToSuperview()
        }
        
        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.top)
            make.leading.equalTo(loginButton.snp.leading)
            make.bottom.equalTo(loginButton.snp.bottom)
            make.trailing.equalTo(loginButton.snp.trailing)
        }
    }
    
    private func design() {
        view.backgroundColor = .white
        title = "Giriş Yap"
        navigationItem.leftBarButtonItem = backButton
        navigationController?.navigationBar.backgroundColor = UIColor.white
    }

}
