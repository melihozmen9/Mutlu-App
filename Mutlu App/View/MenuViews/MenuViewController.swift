//
//  MenuViewController.swift
//  Mutlu App
//
//  Created by Kullanici on 4.04.2023.
//


import UIKit
import SnapKit

class MenuViewController: UIViewController {
    
    private let menuView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let hesap: UIButton = {
        let button = UIButton()
        button.setTitle("Hesabım", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(hesapTapped(_:)), for: .touchUpInside)
        button.backgroundColor = .white
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10.0
        return button
    }()
    
    private let resources: UIButton = {
        let button = UIButton()
        button.setTitle("Kaynaklar", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(resourcesTapped(_:)), for: .touchUpInside)
        button.backgroundColor = .white
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10.0
        return button
    }()
    private let close: UIButton = {
        let button = UIButton()
        button.setTitle("Menu kapat", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(closeTapped(_:)), for: .touchUpInside)
        button.backgroundColor = .white
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10.0
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
        return button
    }()
    
    @objc func menuButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        design()
        
    }
    
    func design(){
        menuView.backgroundColor =  UIColor(red: 0.25, green: 0.75, blue: 0.79, alpha: 1.00)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "menubar.rectangle"), style: .plain, target: self, action: #selector(menuButtonTapped))
    }
    func configure() {
        view.addSubview(menuView)
        menuView.addSubview(hesap)
        menuView.addSubview(resources)
        menuView.addSubview(close)
        
        menuView.snp.makeConstraints { make in
            make.top.right.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view).offset(view.frame.size.width * 0.6)
            make.height.equalTo(hesap.snp.height).multipliedBy(3.5)
        }
        
        hesap.snp.makeConstraints { make in
            make.top.equalTo(menuView.snp.top).offset(10)
            make.width.equalTo(view.snp.width).multipliedBy(0.25)
            make.height.equalTo(view.snp.height).multipliedBy(0.1)
            make.centerX.equalTo(menuView.snp.centerX)
        }
        
        resources.snp.makeConstraints { make in
            make.top.equalTo(hesap.snp.bottom).offset(10)
            make.width.equalTo(view.snp.width).multipliedBy(0.25)
            make.height.equalTo(view.snp.height).multipliedBy(0.1)
            make.centerX.equalTo(menuView.snp.centerX)
        }
        
        close.snp.makeConstraints { make in
            make.top.equalTo(resources.snp.bottom).offset(10)
            make.width.equalTo(view.snp.width).multipliedBy(0.25)
            make.height.equalTo(view.snp.height).multipliedBy(0.1)
            make.centerX.equalTo(menuView.snp.centerX)
        }
    }
    
    @objc func hesapTapped(_ sender: UIButton) {
        
        let accountViewController = UINavigationController(rootViewController: AccountViewController())
        accountViewController.modalPresentationStyle = .fullScreen
        accountViewController.modalTransitionStyle = .crossDissolve
        self.present(accountViewController, animated: true, completion: nil)
    }
    @objc func resourcesTapped(_ sender: UIButton) {
        
        let resourcesViewController = UINavigationController(rootViewController: ResourcesViewController())
        resourcesViewController.modalPresentationStyle = .fullScreen
        resourcesViewController.modalTransitionStyle = .crossDissolve
        self.present(resourcesViewController, animated: true, completion: nil)
    }
    @objc func closeTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
