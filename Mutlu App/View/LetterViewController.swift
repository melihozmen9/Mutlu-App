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
class LettersViewController: UIViewController {
    
    // let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    private let backgroundImage = UIImage(named: "background2")
    private var backgroundImageView = UIImageView()
    let databaseRef = Database.database().reference()
    var userID = Auth.auth().currentUser?.uid
    var userType: String?
    var penpalIDs: [String]?
    //var letterDetails: [(isim:String,tarih:String,penpalID:String)]?
    var letterDetails = [[String]]()
    var penpalIDKey: String? {
        didSet {
            if let penpalIDKey = penpalIDKey {
                let letterVC = LetterVC()
                letterVC.penpalIDKey = penpalIDKey
                letterVC.userType = userType
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
    
        getPenpalIDs(forUserID: userID!) { (penpalIDs, error) in
            if let error = error {
                print("Veri çekme hatası: \(error.localizedDescription)")
            } else if let penpalIDs = penpalIDs {
                print("Penpal IDs: \(penpalIDs)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        
    }
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
                            "volunteerUserID": selectedVolunteerUserID,
                            "lastDate": ""
                        ]
                        
                       
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
                            "volunteerUserID": currentUserID,
                            "lastDate": ""
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
    

    
    func getPenpalIDs(forUserID userID: String, completion: @escaping ([String]?, Error?) -> Void) {
       
        
        getUserType(userID: userID) { userType in
            if userType == "child" {
                
                self.getPenpalIDs2(userID: userID, database: "children") { (penpalIDs, error) in
                    if let error = error {
                        print("Veri çekme hatası: \(error.localizedDescription)")
                    } else if let penpalIDs = penpalIDs {
                        print("Penpal IDs: \(penpalIDs)")
                    }
                }
            } else {
                self.getPenpalIDs2(userID: userID, database: "volunteers") { (penpalIDs, error) in
                    if let error = error {
                        print("Veri çekme hatası: \(error.localizedDescription)")
                    } else if let penpalIDs = penpalIDs {
                        print("Penpal IDs: \(penpalIDs)")
                    }
                }

            }
        }
    }
  

    
    func getPenpalIDs2(userID: String, database: String, completion: @escaping ([String]?, Error?) -> Void) {
        let reference = databaseRef.child(database)

           // Veritabanındaki belirli bir kullanıcıyı sorgulayın ve penpalIDs alanını alın.
           reference.queryOrdered(byChild: "userID").queryEqual(toValue: userID).observeSingleEvent(of: .value) { (snapshot) in
               if snapshot.exists() {
                   // Veritabanından gelen verileri dizi olarak alın.
                   
                   if let userData = snapshot.children.allObjects.first as? DataSnapshot,
                      let penpalIDsValue = userData.childSnapshot(forPath: "penpalIDs").value as? [String] {
                       // Veri doğru çekildi, şimdi veri yapısını kontrol edebiliriz.
                       self.penpalIDs = penpalIDsValue
                      
                       print(penpalIDsValue)
                       self.getDetails(forPenpalIDs: self.penpalIDs!)
                   } else {
                       // PenpalIDs bilgisi eksikse veya çekilemediyse hata döndürün.
                       let error = NSError(domain: "com.example.app", code: 101, userInfo: [NSLocalizedDescriptionKey: "PenpalIDs eksik veya çekilemedi"])
                       completion(nil, error)
                   }
               } else {
                   // Kullanıcı bulunamadıysa hata döndürün.
                   let error = NSError(domain: "com.example.app", code: 102, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı bulunamadı"])
                   completion(nil, error)
               }
           }
        
     
    }
    
    func getUserDetails(userID: String, database: String, completion: @escaping (String?) -> Void){
        let reference = databaseRef.child(database)
           // Veritabanındaki belirli bir kullanıcıyı sorgulayın ve penpalIDs alanını alın.
           reference.queryOrdered(byChild: "userID").queryEqual(toValue: userID).observeSingleEvent(of: .value) { (snapshot) in
               if snapshot.exists() {
                   // Veritabanından gelen verileri dizi olarak alın.
                   
                   if let userData = snapshot.children.allObjects.first as? DataSnapshot,
                      let username = userData.childSnapshot(forPath: "name").value as? String {
                       // Veri doğru çekildi, şimdi veri yapısını kontrol edebiliriz.
                     completion(username)
                   } else {
                       // PenpalIDs bilgisi eksikse veya çekilemediyse hata döndürün.
                       let error = NSError(domain: "com.example.app", code: 101, userInfo: [NSLocalizedDescriptionKey: "PenpalIDs eksik veya çekilemedi"])
                       completion(error as! String)
                   }
               } else {
                   // Kullanıcı bulunamadıysa hata döndürün.
                   let error = NSError(domain: "com.example.app", code: 102, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı bulunamadı"])
                   completion(error as! String)
               }
               
           }
        
    }
    
    func getDetails(forPenpalIDs penpalIDs: [String]) {
        // Her penpalID için sorgu oluşturun.
        for penpalID in penpalIDs {
            let penpalRef = databaseRef.child("penpals").child(penpalID)
            
            penpalRef.observeSingleEvent(of: .value) { (snapshot) in
                if snapshot.exists() {
                    
                    if let penpalData = snapshot.value as? [String: Any],
                       let childUserID = penpalData["childUserID"] as? String,
                       let volunteerUserID = penpalData["volunteerUserID"] as? String,
                       let date = penpalData["lastDate"] as? String {
                        
                        var userType: String
                        var userID: String
                        
                        if self.userType == "child" {
                            userType = "volunteers"
                            userID = volunteerUserID
                        } else {
                            userType = "children"
                            userID = childUserID
                        }
                        
                        self.getUserDetails(userID: userID, database: userType) { username in
                            if let username = username {
                                let item: [String] = [username, date, penpalID]
                                self.letterDetails.append(item)
                                print(self.letterDetails as Any)
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
       
    }

 


    
    func getUserType(userID: String, completion: @escaping (String?) -> Void) {
        let databaseRef = Database.database().reference()
        
        // Children koleksiyonunda arama yapma
        databaseRef.child("children").queryOrdered(byChild: "userID").queryEqual(toValue: userID).observeSingleEvent(of: .value) { (childSnapshot) in
            if childSnapshot.exists() {
                self.userType = "child"
                completion("child")
            } else {
                // Volunteers koleksiyonunda arama yapma
                
                databaseRef.child("volunteers").queryOrdered(byChild: "userID").queryEqual(toValue: userID).observeSingleEvent(of: .value) { (volunteerSnapshot) in
                    if volunteerSnapshot.exists(), let volunteerData = volunteerSnapshot.value as? [String: [String: Any]],
                       let userType = volunteerData.values.first?["type"] as? String {
                        self.userType = "volunteer"
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

extension LettersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // guard let penpalIDs = penpalIDs else {return 0}
        
        return letterDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "envelope", for: indexPath) as? EnvelopeCell
        print(letterDetails)
        let value = letterDetails[indexPath.section]
        print(value)
        cell?.configure(data: letterDetails[indexPath.section])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.width * 0.5675
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let readLettersVC = ReadLetterViewController()
        print(letterDetails)
        readLettersVC.penpalIDs = letterDetails[indexPath.section][2]
        readLettersVC.userType = userType
        navigationController?.pushViewController(readLettersVC, animated: true)
    }
    
    
    
    
}
