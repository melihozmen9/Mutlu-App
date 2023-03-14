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
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Giriş Yap", for: .normal)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
       
    }
 
    private func configure() {
        view.backgroundColor = .white
        title = "Giriş Yap"
        navigationController?.navigationBar.backgroundColor = UIColor.white
        view.addSubview(username)
        view.addSubview(password)
        view.addSubview(loginButton)
        view.addSubview(loginImageView)
        
        username.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(25)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(50)
        }
        
        password.snp.makeConstraints { make in
            make.top.equalTo(username.snp.bottom).offset(25)
            make.left.right.equalTo(username)
            make.height.equalTo(username)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(password.snp.bottom).offset(25)
            make.left.equalTo(view).offset(view.frame.size.width * 0.40)
            make.width.equalTo(90)
            make.height.equalTo(50)
        }
        
        loginImageView.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(25)
            make.left.equalTo(view).offset(10)
            make.right.equalTo(view).offset(-10)
            make.bottom.equalToSuperview()
        }
    }

}
