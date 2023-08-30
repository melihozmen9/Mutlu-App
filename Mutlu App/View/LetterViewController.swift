//
//  DiaryViewController.swift
//  Mutlu App
//
//  Created by Kullanici on 22.03.2023.
//

import UIKit
import SnapKit
import CoreData
import FirebaseDatabase
import FirebaseAuth
class DiaryViewController: UIViewController {
    
    // let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    private let backgroundImage = UIImage(named: "background2")
    private var backgroundImageView = UIImageView()
    let databaseRef = Database.database().reference()
    var penpalIDKey: String? {
        didSet {
            if let penpalIDKey = penpalIDKey {
                let letterVC = LetterVC()
                letterVC.penpalIDKey = penpalIDKey
                self.navigationController?.pushViewController(letterVC, animated: true)
            }
        }
    }
    private let topView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor(red: 1.00, green: 0.87, blue: 0.87, alpha: 1.00)
        
        return view
    }()
    
    
    @objc func topViewTapped() {
       
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Current user ID not available.")
            return
        }
        print(currentUserID)
        let databaseRef = Database.database().reference()
        
        // Kullanıcının tipine göre işlem yapma
        
        getUserType(userID: currentUserID) { userType in
            if userType == "child" {
                self.updateCountForCollection("children", userID: currentUserID)
                
                // "volunteers" koleksiyonundan en düşük "count" değerine sahip olan birini bulma
                databaseRef.child("volunteers").queryOrdered(byChild: "count").queryLimited(toFirst: 1).observeSingleEvent(of: .value) { (snapshot) in
                    if let volunteersData = snapshot.value as? [String: [String: Any]],
                       let selectedVolunteerID = volunteersData.keys.first,
                       let selectedVolunteerData = volunteersData[selectedVolunteerID],
                       let selectedVolunteerUserID = selectedVolunteerData["userID"] as? String {
                        
                        self.updateCountForCollection("volunteers", userID: selectedVolunteerUserID)
                        
                        // Penpals koleksiyonuna veri ekleme
                        let penpalsData: [String: Any] = [
                            "childUserID": currentUserID,
                            "volunteerUserID": selectedVolunteerUserID
                        ]
                        
                        //FIXME: - artık bir sonraki sayfaya yönelendirebilirim. yönlendirirken. penpalKey'i yollucam. ve onun içine gönderen ve mesajı diye mesaj atıcam.
                        let newPenpalsRef = databaseRef.child("penpals").childByAutoId()
                        newPenpalsRef.setValue(penpalsData) { (error, ref) in
                            if let error = error {
                                print("Error adding penpals data: \(error.localizedDescription)")
                            } else {
                                if let newPenpalsID = newPenpalsRef.key {
                                    print("Penpals data added successfully with ID: \(newPenpalsID)")
                                    self.addPenpalIDToUserArray(collection: "children", userID: currentUserID, penpalIDKey: newPenpalsID)
                                    self.addPenpalIDToUserArray(collection: "volunteers", userID: selectedVolunteerUserID, penpalIDKey: newPenpalsID)
                                    self.penpalIDKey = newPenpalsID
                                }
                            }
                        }
                    }
                  
                }
                
            } else if userType == "volunteer" {
                self.updateCountForCollection("volunteers", userID: currentUserID)
                
                databaseRef.child("children").queryOrdered(byChild: "count").queryLimited(toFirst: 1).observeSingleEvent(of: .value) { (snapshot) in
                    if let childrenData = snapshot.value as? [String: [String: Any]],
                       let selectedChildID = childrenData.keys.first,
                       let selectedChildData = childrenData[selectedChildID],
                       let selectedChildUserID = selectedChildData["userID"] as? String {
                        
                        self.updateCountForCollection("children", userID: selectedChildUserID)
                        
                        // Penpals koleksiyonuna veri ekleme
                        let penpalsData: [String: Any] = [
                            "childUserID": selectedChildUserID,
                            "volunteerUserID": currentUserID
                        ]
                        
                        
                        
                        let newPenpalsRef = databaseRef.child("penpals").childByAutoId()
                        newPenpalsRef.setValue(penpalsData) { (error, ref) in
                            if let error = error {
                                print("Error adding penpals data: \(error.localizedDescription)")
                            } else {
                                if let newPenpalsID = newPenpalsRef.key {
                                    print("Penpals data added successfully with ID: \(newPenpalsID)")
                                    self.addPenpalIDToUserArray(collection: "children", userID: selectedChildUserID, penpalIDKey: newPenpalsID)
                                    self.addPenpalIDToUserArray(collection: "volunteers", userID: currentUserID, penpalIDKey: newPenpalsID)
                                    self.penpalIDKey = newPenpalsID
                                }
                            }
                        }
                    }
               
                }
            } else {
                print("Invalid user type.")
            
            }
          

            
        }
       
    }
    
    func getUserType(userID: String, completion: @escaping (String?) -> Void) {
        let databaseRef = Database.database().reference()
        
        // Children koleksiyonunda arama yapma
        databaseRef.child("children").queryOrdered(byChild: "userID").queryEqual(toValue: userID).observeSingleEvent(of: .value) { (childSnapshot) in
            if childSnapshot.exists() {
                completion("child")
            } else {
                // Volunteers koleksiyonunda arama yapma
                databaseRef.child("volunteers").queryOrdered(byChild: "userID").queryEqual(toValue: userID).observeSingleEvent(of: .value) { (volunteerSnapshot) in
                    if volunteerSnapshot.exists(), let volunteerData = volunteerSnapshot.value as? [String: [String: Any]],
                       let userType = volunteerData.values.first?["type"] as? String {
                        completion(userType)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    
    func updateCountForCollection(_ collection: String, userID: String) {
        let databaseRef = Database.database().reference()
        
        // Belirli bir koleksiyon içerisindeki veriyi bulma
        databaseRef.child(collection).queryOrdered(byChild: "userID").queryEqual(toValue: userID).observeSingleEvent(of: .value) { (snapshot) in
            if let data = snapshot.value as? [String: [String: Any]],
               let dataID = data.keys.first,
               var dataToUpdate = data[dataID] {
                
                // Count değerini artırma
                if let currentCount = dataToUpdate["count"] as? Int {
                    dataToUpdate["count"] = currentCount + 1
                    
                    // Güncellenmiş veriyi kaydetme
                    databaseRef.child(collection).child(dataID).setValue(dataToUpdate) { (error, ref) in
                        if let error = error {
                            print("Error updating count: \(error.localizedDescription)")
                        } else {
                            print("Count updated successfully.")
                        }
                    }
                }
            }
        }
    }
    func addPenpalIDToUserArray(collection: String, userID: String, penpalIDKey: String) {
        let databaseRef = Database.database().reference()
        
        // Belirli bir koleksiyon içerisindeki veriyi bulma
        databaseRef.child(collection).queryOrdered(byChild: "userID").queryEqual(toValue: userID).observeSingleEvent(of: .value) { (snapshot) in
            if var dataToUpdate = snapshot.value as? [String: [String: Any]] {
                // İlgili user verisini bulma
                if let dataID = dataToUpdate.keys.first, var userData = dataToUpdate[dataID] {
                    // PenpalID'yi eklemek için bir array oluşturun
                    var penpalIDs: [String] = []
                    
                    // Eğer user zaten bir penpalID array'ine sahipse onu alın
                    if let existingPenpalIDs = userData["penpalIDs"] as? [String] {
                        penpalIDs = existingPenpalIDs
                    }
                    
                    // PenpalID'yi array'e ekle
                    penpalIDs.append(penpalIDKey)
                    userData["penpalIDs"] = penpalIDs
                    
                    // Güncellenmiş veriyi kaydetme
                    databaseRef.child(collection).child(dataID).setValue(userData) { (error, ref) in
                        if let error = error {
                            print("Error adding penpalID: \(error.localizedDescription)")
                        } else {
                            print("PenpalID added successfully.")
                        }
                    }
                }
            }
        }
    }

    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Yeni Mektup Arkadaşı"
        label.font = UIFont(name: "EduNSWACTFoundation-Bold", size: 25)
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let imageview: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "mainLabelImage"))
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    var diaryArray = [Diary]()
    
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
    
    var imageArray: [UIImage] = [
        UIImage(named: "sun")!,
        UIImage(named: "flower1")!,
        UIImage(named: "flower2")!,
        UIImage(named: "heart")!,
        UIImage(named: "whale")!,
        UIImage(named: "lion")!
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // loadDiary()
        tableView.reloadData()
    }
    
    //    func loadDiary(){
    //        let request : NSFetchRequest<Diary> = Diary.fetchRequest()
    //        do {
    //            diaryArray = try context!.fetch(request)
    //        } catch {
    //            print("error \(error)")
    //        }
    //    }
    
    func tableViewSetup(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(EnvelopeCell.self, forCellReuseIdentifier: "envelope")
        tableView.backgroundColor = UIColor.clear
        tableView.backgroundView = UIView(frame: CGRect.zero)
        tableView.isOpaque = false
    }
    
    func configure() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(topViewTapped))
        topView.isUserInteractionEnabled = true
        topView.addGestureRecognizer(tapGesture)
        title = "Mektuplar"
        navigationItem.leftBarButtonItem = backButton
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.alpha = 0.1
        backgroundImageView = UIImageView(image: backgroundImage)
        view.insertSubview(backgroundImageView, at: 0)
        
        
        view.addSubview(topView)
        view.addSubview(tableView)
        topView.addSubview(mainLabel)
        topView.addSubview(imageview)
        
        mainLabel.snp.makeConstraints { make in
            make.left.equalTo(topView.snp.left).offset(view.frame.size.height * 0.01)
            make.centerY.equalTo(topView.snp.centerY)
            make.width.equalTo(topView.snp.width).multipliedBy(0.7)
            make.height.equalTo(topView.snp.height).multipliedBy(0.6)
        }
        
        imageview.snp.makeConstraints { make in
            make.right.equalTo(topView)
            make.centerY.equalTo(topView.snp.centerY)
            make.width.height.equalTo(topView.snp.height).multipliedBy(0.7)
        }
        
        topView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(view.frame.size.height * 0.03)
            make.left.equalTo(view).offset(view.frame.size.width * 0.20)
            make.right.equalTo(view).offset(-view.frame.size.width * 0.20)
            make.height.equalTo(view.frame.size.height * 0.10)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(view.frame.size.height * 0.03)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.frame.size.width * 0.80)
            make.bottom.equalToSuperview()
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view)
        }
    }
}

extension DiaryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "envelope", for: indexPath) as? EnvelopeCell
        //        cell?.dayLabel.text = diaryArray[indexPath.row].tarih
        //        cell?.dayImage.image = imageArray.shuffled()[0]
        //        cell?.backgroundColor = UIColor.clear
        //        cell?.isOpaque = false
        //        cell?.backgroundView = UIView(frame: CGRect.zero)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height * 0.15
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let diaryReadViewController = DiaryReadViewController()
        diaryReadViewController.diaryLabel.text = diaryArray[indexPath.row].metin
        
        navigationController?.pushViewController(diaryReadViewController, animated: true)
    }
    
    
    
    
}
