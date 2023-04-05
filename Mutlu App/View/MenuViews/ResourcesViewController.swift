//
//  ResourcesViewController.swift
//  Mutlu App
//
//  Created by Kullanici on 4.04.2023.
//

import UIKit
import FirebaseDatabase

class ResourcesViewController: UIViewController {

    private let resourcesLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.numberOfLines = 0
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10.0
        label.isUserInteractionEnabled = true

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        label.addGestureRecognizer(longPressGesture)
        return label
    }()

    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began, let textView = sender.view as? UITextView {
            UIPasteboard.general.string = textView.text // TextView'ın metnini kopyala.
        }
    }
    
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
    
    let database = Database.database().reference()
    private var resources = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        getResources()
        
    }
    
    func getResources() {
        database.child("resources").child("kaynakDizisi").observeSingleEvent(of: .value, with: { (snapshot) in
            if let valueDictionary = snapshot.value as? [String: String] {
                for (_, value) in valueDictionary {
                    self.resources.append(value)
                }
                let resourcesString = self.resources.joined(separator: "\n\n")
                self.resourcesLabel.text = resourcesString
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func configure() {
        design()
        view.addSubview(resourcesLabel)

        
        resourcesLabel.snp.makeConstraints { make in
            make.top.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
//            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-60)
        }
        
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
