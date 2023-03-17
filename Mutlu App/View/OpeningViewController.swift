//
//  ViewController.swift
//  Mutlu App
//
//  Created by Kullanici on 8.03.2023.
//

import UIKit
import SnapKit

class OpeningViewController: UIViewController {
    
    private let backgroundImage = UIImage(named: "mainBackground")
    private var backgroundImageView = UIImageView()
    
    private let navLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Mutlu App"
        titleLabel.font = UIFont(name: "AvenirNext-Bold", size: 28)
        titleLabel.textColor = .black
        titleLabel.sizeToFit()
        return titleLabel
    }()
    private lazy var titleItem = UIBarButtonItem(customView: navLabel)
    
    private let mainLabel : UILabel = {
        let label = UILabel()
        label.text = "Canın\nSıkılırsa\nBuraya\nGel"
        label.font = UIFont(name: "Futura-Bold", size: 72)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.backgroundColor = UIColor(red: 1.00, green: 0.80, blue: 0.80, alpha: 0.5)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 27.36
       return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setImage(UIImage(systemName: "arrowtriangle.right.circle")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: (button.titleLabel?.font.pointSize ?? 12) * 3)
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 17.52)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = UIColor(red: 0.59, green: 0.79, blue: 0.29, alpha: 1.00)
        button.layer.cornerRadius = 27.36
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func loginTapped() {
        let loginViewController = UINavigationController(rootViewController: LoginViewController())
        loginViewController.modalPresentationStyle = .fullScreen
        loginViewController.modalTransitionStyle = .crossDissolve
        present(loginViewController, animated: true, completion: nil)
    }
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.setImage(UIImage(systemName: "arrowtriangle.right.circle")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 27.52)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = UIColor(red: 0.29, green: 0.75, blue: 0.94, alpha: 1.00)
        button.layer.cornerRadius = 27.36
        button.addTarget(self, action: #selector(singUpTapped), for: .touchUpInside)
        return button
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
        label.font = UIFont(name: "Lato-Black", size: 17.52)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.backgroundColor = UIColor(red: 1.00, green: 0.62, blue: 0.25, alpha: 1.00)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 27.36
        return label
    }()
    
    private lazy var vstack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
        mainLabel,
        loginButton,
        signUpButton,
        bottomLabel
        ])
        view.axis = .vertical
        view.spacing = 25
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
       configure()
printFonts()
    }
    func printFonts() {
       for familyName in UIFont.familyNames {
           print("\n-- \(familyName) \n")
           for fontName in UIFont.fontNames(forFamilyName: familyName) {
               print(fontName)
           }
       }
   }
    // tableView.rowHeight = self.view.frame.size.height * 0.3
    private func configure() {
        design()
        view.addSubview(vstack)
        vstack.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leadingMargin).offset(16)
            make.top.equalTo(view.snp.topMargin).offset(16)
            make.bottom.equalTo(view.snp.bottomMargin).offset(-16)
            make.trailing.equalTo(view.snp.trailingMargin).offset(-16)
        }

        loginButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        bottomLabel.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view)
        }
    }

    
    private func design() {
        
         navigationController?.navigationBar.backgroundColor = UIColor.white
         navigationItem.leftBarButtonItem = titleItem

         backgroundImageView.contentMode = .scaleToFill
         backgroundImageView.alpha = 0.1
         backgroundImageView = UIImageView(image: backgroundImage)
         view.insertSubview(backgroundImageView, at: 0)
    }
    
    

}

