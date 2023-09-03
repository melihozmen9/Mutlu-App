//
//  DiaryPageViewController.swift
//  Mutlu App
//
//  Created by Kullanici on 22.03.2023.
//

import UIKit
import SnapKit
import FirebaseDatabase
import CoreData

class DiaryPageViewController: UIViewController, UITextViewDelegate {
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    let diaryViewController = LettersViewController()
    
    private let backgroundImage = UIImage(named: "background2")
    private var backgroundImageView = UIImageView()
    
    private let diaryImageView: UIImageView = {
        let imageview = UIImageView(image: UIImage(named: "diaryPage"))
        imageview.contentMode = .scaleToFill
        return imageview
    }()
    
    private var diaryTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.backgroundColor = .clear
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 10
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.text = "Sevgili Günlük"
        textView.textColor = .lightGray
        textView.font = UIFont(name: "Kalam-Regular", size: 18)
        return textView
    }()
    
    private var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Kaydet", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemRed
        button.titleLabel?.font = UIFont(name: "Mansalva-Regular", size: 15)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func saveButtonTapped(_ sender: UIButton) {
        if let text = diaryTextView.text, !text.isEmpty {
            let formatter = DateFormatter()
            let locale = Locale(identifier: "tr_TR")
            formatter.locale = locale
            formatter.dateFormat = "dd MMMM yyyy, EEEE"
            let dateString = formatter.string(from: Date())
            
            let newDiary = Diary(context: context!)
            newDiary.tarih = dateString
            newDiary.metin = text
            
            saveDiary()
            dismiss(animated: true, completion: nil)
    
        }
    }
 
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
        diaryTextView.delegate = self
        view.addSubview(diaryImageView)
        view.insertSubview(diaryTextView, aboveSubview: diaryImageView)
        view.insertSubview(saveButton, aboveSubview: diaryImageView)
        
        diaryImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(view.frame.size.width * 0.05)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.snp.width).multipliedBy(0.9)
            make.bottom.equalTo(view).offset(-view.frame.size.width * 0.1)
        }
        
        diaryTextView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(view.frame.size.width * 0.13)
            make.left.equalTo(view.snp.left).offset(view.frame.size.width * 0.13)
            make.right.equalTo(view.snp.right).offset(-view.frame.size.width * 0.13)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-view.frame.size.width * 0.18)
        }
        
        saveButton.snp.makeConstraints { make in
            make.centerX.equalTo(diaryTextView.snp.centerX)
            make.top.equalTo(diaryTextView.snp.bottom)
            make.height.equalTo(view.frame.size.width * 0.07)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view)
        }
    }
    
    func design() {
        title = "Günlüğüm"
        navigationItem.leftBarButtonItem = backButton
        backgroundImageView.contentMode = .scaleAspectFit
        backgroundImageView.alpha = 0.1
        backgroundImageView = UIImageView(image: backgroundImage)
        view.insertSubview(backgroundImageView, at: 0)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Sevgili Günlük" {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
           if textView.text.isEmpty {
               textView.text = "Sevgili Günlük"
               textView.textColor = .lightGray
           }
       }
}

extension DiaryPageViewController {
    func saveDiary() {
        do {
           try context?.save()
        } catch  {
            print("error: \(error)")
        }
    }
}
