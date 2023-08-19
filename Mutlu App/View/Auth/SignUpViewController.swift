//
//  SignUpViewController.swift
//  Mutlu App
//
//  Created by Kullanici on 14.03.2023.
//

import UIKit
import Firebase
import TinyConstraints

class SignUpViewController: UIViewController {
    
    private let backgroundImage = UIImage(named: "background2")
    private var backgroundImageView = UIImageView()

    private let username: CustomTextField = {
        let username = CustomTextField()
        username.attributedPlaceholder = NSAttributedString(string: "Kullanıcı adın", attributes: username.attributes)
        username.autocapitalizationType = .none
        return username
    }()
    
    private let password: CustomTextField = {
        let password = CustomTextField()
        password.isSecureTextEntry = true
        password.attributedPlaceholder = NSAttributedString(string: "Şifre", attributes: password.attributes)
        return password
    }()
    
   
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0.98, green: 0.83, blue: 0.56, alpha: 1.00)
        button.layer.cornerRadius = 10.0
        button.frame.size.width = 40
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont(name: "EduNSWACTFoundation-Bold", size: 20)
        ]
        button.setAttributedTitle(NSAttributedString(string: "Giriş Yap", attributes: attributes), for: .normal)
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
    
    private lazy var parentBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(red: 0.98, green: 0.83, blue: 0.56, alpha: 1.00)
        btn.layer.cornerRadius = 10.0
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont(name: "EduNSWACTFoundation-Bold", size: 12)
        ]
        btn.setAttributedTitle(NSAttributedString(string: "Ebeveyn kayıt sayfasına git", attributes: attributes), for: .normal)
        btn.addTarget(self, action: #selector(parentTapped), for: .touchUpInside)
        return btn
    }()
    
    @objc func parentTapped() {
        
    }
    
    private lazy var volunteerBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(red: 0.98, green: 0.83, blue: 0.56, alpha: 1.00)
        btn.layer.cornerRadius = 10.0
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont(name: "EduNSWACTFoundation-Bold", size: 12)
        ]
        btn.setAttributedTitle(NSAttributedString(string: "Gönüllü kayıt sayfasına git", attributes: attributes), for: .normal)
        btn.addTarget(self, action: #selector(volunteerTapped), for: .touchUpInside)
        return btn
    }()
    
    @objc func volunteerTapped() {
        let vc = VolunteerSignUpVC()
        self.navigationController?.pushViewController(vc, animated: true)
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
        view.addSubViews(username,password,signUpButton,signUpImageView,parentBtn,volunteerBtn)
        
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.alpha = 0.1
        backgroundImageView = UIImageView(image: backgroundImage)
        view.insertSubview(backgroundImageView, at: 0)
        signUpImageView.isHidden = true
        
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
        

        parentBtn.width(150)
        parentBtn.topToBottom(of: signUpButton, offset: view.frame.size.height * 0.2)
        parentBtn.height(view.frame.size.height * 0.06)
        parentBtn.centerXToSuperview()
        
        volunteerBtn.width(150)
        volunteerBtn.height(view.frame.size.height * 0.06)
        volunteerBtn.topToBottom(of: parentBtn,offset: view.frame.size.height * 0.02)
        volunteerBtn.centerXToSuperview()

        
        
        backgroundImageView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view)
        }
    }
}
