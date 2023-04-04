//
//  ResourcesViewController.swift
//  Mutlu App
//
//  Created by Kullanici on 4.04.2023.
//

import UIKit

class ResourcesViewController: UIViewController {

    
    private let backgroundImage = UIImage(named: "background2")
    private var backgroundImageView = UIImageView()
    
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
    
    func configure() {
        design()
        backgroundImageView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view)
        }
    }
    
    private func design() {
        title = "Kaynaklar"
        navigationItem.leftBarButtonItem = backButton
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.alpha = 0.1
        backgroundImageView = UIImageView(image: backgroundImage)
        view.insertSubview(backgroundImageView, at: 0)
    }


}
