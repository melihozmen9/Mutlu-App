//
//  AccountViewController.swift
//  Mutlu App
//
//  Created by Kullanici on 4.04.2023.
//

import UIKit
import SnapKit
import Firebase

class AccountViewController: UIViewController {

  
    private let backgroundImage = UIImage(named: "background2")
    private var backgroundImageView = UIImageView()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username : "
        label.backgroundColor = .white
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5.0
        return label
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(deletePressed),for: .touchUpInside)
        button.backgroundColor = .white
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10.0
        return button
    }()
    
    private let deleteLabel: UILabel = {
        let label = UILabel()
        label.text = "Hesabımı Sil"
        label.textAlignment = .center
        label.font = UIFont(name: "EduNSWACTFoundation-Bold", size: 20)
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
    
    @objc private func deletePressed(){
           let user = Auth.auth().currentUser

           // Kullanıcı giriş yapmış mı diye kontrol etmek için
           if let user = user {
               // Kullanıcının hesabını silmek istediğine emin misiniz diye onay isteyin
               let alertController = UIAlertController(title: "Hesap Silme", message: "Hesabınızı silmek istediğinize emin misiniz?", preferredStyle: .alert)
               let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
               let deleteAction = UIAlertAction(title: "Sil", style: .destructive) { _ in
                   // Kullanıcının hesabını silmek için delete metodunu çağırın
                   user.delete { error in
                       if let error = error {
                           // Hata durumunda bir uyarı gösterin
                           print("Hesap silinemedi: \(error.localizedDescription)")
                       } else {
                           // Hesap başarıyla silindiği için kullanıcıyı çıkış yapmaya zorlayın
                           try! Auth.auth().signOut()
                           // Hesap silme işlemi başarılı bir şekilde gerçekleştiği için kullanıcıyı farklı bir sayfaya yönlendirin
                           // örneğin ana sayfaya vb.
                           let openingViewController = UINavigationController(rootViewController: OpeningViewController())
                           openingViewController.modalPresentationStyle = .fullScreen
                           openingViewController.modalTransitionStyle = .crossDissolve
                           self.present(openingViewController, animated: true, completion: nil)
                       }
                   }
               }
               alertController.addAction(cancelAction)
               alertController.addAction(deleteAction)
               present(alertController, animated: true, completion: nil)
           } else {
               // Kullanıcı giriş yapmamışsa, hesap silme işlemi yapamaz
               print("Kullanıcı giriş yapmamış")
           }
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       configure()
       getName()
    }
    func getName() {
        if let email = Auth.auth().currentUser?.email {
            let username = email.replacingOccurrences(of: "@gmail.com", with: "")
            usernameLabel.text = "Username: \(username)"
        }
    }
    
    
    func configure() {
        design()
        view.addSubview(deleteButton)
        view.addSubview(usernameLabel)
        deleteButton.addSubview(deleteLabel)
        
        usernameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(deleteButton.snp.top).offset(-20)
        }
        deleteButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
            make.width.equalTo(view.snp.width).multipliedBy(0.4)
            make.height.equalTo(view.snp.height).multipliedBy(0.1)

        }
        
        deleteLabel.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(deleteButton)
        }
        backgroundImageView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view)
        }
    }
    
    private func design() {
        title = "Hesabım"
        navigationItem.leftBarButtonItem = backButton
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.alpha = 0.1
        backgroundImageView = UIImageView(image: backgroundImage)
        view.insertSubview(backgroundImageView, at: 0)
    }


}
