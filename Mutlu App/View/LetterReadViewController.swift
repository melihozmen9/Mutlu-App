//
//  DiaryReadViewController.swift
//  Mutlu App
//
//  Created by Kullanici on 23.03.2023.
//

import UIKit
import FirebaseDatabase

class ReadLetterViewController: UIViewController {
    
    let databaseRef = Database.database().reference()

    private let backgroundImage = UIImage(named: "background2")
    private var backgroundImageView = UIImageView()
    
    var penpalIDs: String?
    var letters: [[String : Any]]?
    var userType: String?
    private lazy var tableView : UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(LetterCell.self, forCellReuseIdentifier: "letterCell")
        return tv
    }()
    
    private func createBackButton() -> UIBarButtonItem {
        let button = UIBarButtonItem(title: "Geri", style: .plain, target: self, action: #selector(backButtonTapped))
        button.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.systemPink,
            NSAttributedString.Key.font: UIFont(name: "Mansalva-Regular", size: 18)!],
            for: .normal)
        return button
    }
    
    lazy var backButton: UIBarButtonItem = {
        return createBackButton()
    }()
    
    private lazy var newLetterBtn: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 3
        btn.setTitle("Mektup Yaz", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(newBtnTapped), for: .touchUpInside)
        return btn
    }()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        guard let penpalIDs = penpalIDs else {
            return
        }
        getLetters(forPenpalID: penpalIDs) { (lettersArray) in
            if let lettersArray = lettersArray {
                print("Mektuplar: \(lettersArray)")
                self.letters = lettersArray
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("Mektuplar alınamadı veya hata oluştu.")
            }
        }
    }
    
    @objc private func backButtonTapped() {
     dismiss(animated: true, completion: nil)
    }
    
    @objc private func newBtnTapped() {
        let letterVC = LetterVC()
        letterVC.penpalIDKey = penpalIDs
        letterVC.userType = userType
        navigationController?.pushViewController(letterVC, animated: true)
    }
    
    
    func getLetters(forPenpalID penpalID: String, completion: @escaping ([[String: Any]]?) -> Void) {
        let penpalRef = databaseRef.child("penpals").child(penpalID)
        
        // PenpalID'ye ait mektupları çekmek için sorgu oluşturun.
        let lettersRef = penpalRef.child("letters")
        
        lettersRef.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                // Mektuplar verisi bulunduğunda çekilen veriyi işleyin.
                if let lettersData = snapshot.value as? [String: [String: Any]] {
                    // Mektupların verilerini bir dizi olarak alın.
                    let lettersArray = lettersData.values.map { $0 }
                    completion(lettersArray)
                } else {
                    // Mektup verileri doğru çekilemediyse hata döndürün.
                    let error = NSError(domain: "com.example.app", code: 101, userInfo: [NSLocalizedDescriptionKey: "Mektup verileri çekilemedi"])
                    print(error)
                    completion(nil)
                }
            } else {
                // PenpalID bulunamadıysa hata döndürün.
                let error = NSError(domain: "com.example.app", code: 102, userInfo: [NSLocalizedDescriptionKey: "PenpalID bulunamadı"])
                print(error)
                completion(nil)
            }
        }
    }

    func configure() {
        design()
        view.addSubview(tableView)
        view.addSubview(newLetterBtn)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(view.frame.size.width * 0.05)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.snp.width).multipliedBy(0.9)
            make.bottom.equalTo(view).offset(-view.frame.size.width * 0.25)
        }
        
        newLetterBtn.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(view.frame.size.width * 0.05)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(view.frame.width * 0.3)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-view.frame.width * 0.3)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-view.frame.size.width * 0.05)
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
}

extension ReadLetterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
}

extension ReadLetterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let letters = letters else {return 0}
        return letters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "letterCell", for: indexPath) as? LetterCell
        guard let letters = letters else {return cell!}
        print(letters)
        let value = letters[indexPath.row]
        cell?.configure(data: value, userType: userType!)
        return cell!
    }
    
    
}
