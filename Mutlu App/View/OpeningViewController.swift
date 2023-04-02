//
//  ViewController.swift
//  Mutlu App
//
//  Created by Kullanici on 8.03.2023.
//

import UIKit
import SnapKit

class OpeningViewController: UIViewController {
    
    private let backgroundImage = UIImage(named: "openingBackground2")
    private var backgroundImageView = UIImageView()
    
    private let navLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Mutlu App"
        titleLabel.font = UIFont(name: "Bobby Rough Soft", size: 38)
        titleLabel.textColor = .black
        titleLabel.sizeToFit()
        return titleLabel
    }()
    private lazy var titleItem = UIBarButtonItem(customView: navLabel)
    
    private let mainLabel : UILabel = {
        let label = UILabel()
        label.text = "Canın\nSıkılırsa\nBuraya\nGel"
        label.font = UIFont(name: "Kalam-Bold", size: FontSize.large.size)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.backgroundColor = UIColor(red: 1.00, green: 0.80, blue: 0.80, alpha: 0.5)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 27.36
        label.sizeToFit()
       return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        //button.setImage(UIImage(systemName: "arrowtriangle.right.circle")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        button.backgroundColor = UIColor(red: 0.59, green: 0.79, blue: 0.29, alpha: 1.00)
        button.layer.cornerRadius = 27.36
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        return button
    }()
    
    private let loginImageView: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "arrowtriangle.right.circle")?.withTintColor(.white, renderingMode: .alwaysOriginal))
        return image
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Giriş Yap"
        label.textAlignment = .center
        label.font = UIFont(name: "Kalam-Bold", size: 20)
        return label
    }()
    
    @objc func loginTapped() {
        let loginViewController = UINavigationController(rootViewController: LoginViewController())
        loginViewController.modalPresentationStyle = .fullScreen
        loginViewController.modalTransitionStyle = .crossDissolve
        present(loginViewController, animated: true, completion: nil)
    }
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        //button.setImage(UIImage(systemName: "arrowtriangle.right.circle")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        button.backgroundColor = UIColor(red: 0.29, green: 0.75, blue: 0.94, alpha: 1.00)
        button.layer.cornerRadius = 27.36
        button.addTarget(self, action: #selector(singUpTapped), for: .touchUpInside)
        return button
    }()
    
    private let signUpImageView: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "arrowtriangle.right.circle")?.withTintColor(.white, renderingMode: .alwaysOriginal))
        return image
    }()
    
    private let signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Kayıt Ol"
        label.textAlignment = .center
        label.font = UIFont(name: "Kalam-Bold", size: 20)
        return label
    }()
    
    @objc func singUpTapped() {
       let singUpViewController = UINavigationController(rootViewController: SignUpViewController())
        singUpViewController.modalPresentationStyle = .fullScreen
        singUpViewController.modalTransitionStyle = .crossDissolve
        present(singUpViewController, animated: true, completion: nil)
    }
    
    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.text = "Çocuklar için mutluluk bir seçenek değil, zorunluluktur."
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        label.font = UIFont(name: "Kalam-Bold", size: FontSize.medium.size)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.backgroundColor = UIColor(red: 1.00, green: 0.62, blue: 0.25, alpha: 1.00)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 27.36
//        label.adjustsFontSizeToFitWidth = true
//        label.sizeToFit()
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
       configure()
        print("kullanılan size'ın boyutu: \(FontSize.medium.size)")
    }
    
    func printFonts() {
       for familyName in UIFont.familyNames {
           print("\n-- \(familyName) \n")
           for fontName in UIFont.fontNames(forFamilyName: familyName) {
               print(fontName)
           }
       }
   }
    
    private func configure() {
        design()
        view.addSubview(mainLabel)
        view.addSubview(loginButton)
        view.addSubview(signUpButton)
        view.addSubview(bottomLabel)
        
        signUpButton.addSubview(signUpLabel)
        signUpButton.addSubview(signUpImageView)
        loginButton.addSubview(loginLabel)
        loginButton.addSubview(loginImageView)
        
        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(view.frame.size.height * 0.03)
            make.height.equalTo(view.frame.size.height * 0.40)
            make.left.equalTo(view).offset(view.frame.size.width * 0.1)
            make.right.equalTo(view).offset(-view.frame.size.width * 0.1)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(view.frame.size.height * 0.03)
            make.height.equalTo(view.frame.size.height * 0.10)
            make.left.equalTo(view).offset(view.frame.size.width * 0.26)
            make.right.equalTo(view).offset(-view.frame.size.width * 0.26)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(view.frame.size.height * 0.03)
            make.height.equalTo(view.frame.size.height * 0.10)
            make.left.equalTo(view).offset(view.frame.size.width * 0.26)
            make.right.equalTo(view).offset(-view.frame.size.width * 0.26)
        }
        
        bottomLabel.snp.makeConstraints { make in
            make.top.equalTo(signUpButton.snp.bottom).offset(view.frame.size.height * 0.03)
            make.left.equalTo(view).offset(view.frame.size.width * 0.1)
            make.right.equalTo(view).offset(-view.frame.size.width * 0.1)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-view.frame.size.height * 0.05)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view)
        }
        
        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.top)
            make.leading.equalTo(loginButton.snp.leading).offset(view.frame.size.width * 0.1)
            make.bottom.equalTo(loginButton.snp.bottom)
        }
        
        loginImageView.snp.makeConstraints { make in
            make.centerY.equalTo(loginLabel.snp.centerY)
            make.left.equalTo(loginLabel.snp.right)//.offset(view.frame.size.width * 0.05)
            //make.trailing.equalTo(loginButton.snp.trailing)
            make.width.height.equalTo(view.frame.size.height * 0.05)
        }
        
        signUpLabel.snp.makeConstraints { make in
            make.top.equalTo(signUpButton.snp.top)
            make.leading.equalTo(signUpButton.snp.leading).offset(view.frame.size.width * 0.3)
            make.bottom.equalTo(signUpButton.snp.bottom)
        }
        
        signUpImageView.snp.makeConstraints { make in
            make.centerY.equalTo(signUpLabel.snp.centerY)
            make.centerX.equalTo(loginImageView)//.offset(view.frame.size.width * 0.05)
            //make.trailing.equalTo(loginButton.snp.trailing)
            make.width.height.equalTo(view.frame.size.height * 0.05)
        }
    }

    
    private func design() {
         navigationItem.leftBarButtonItem = titleItem
        backgroundImageView.contentMode = .scaleToFill
         backgroundImageView.alpha = 0.1
         backgroundImageView = UIImageView(image: backgroundImage)
         view.insertSubview(backgroundImageView, at: 0)
    }
    
    

}

