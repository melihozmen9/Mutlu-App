//
//  MainTabBarVC.swift
//  Mutlu App
//
//  Created by Melih on 17.12.2023.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class MainTabBarController: UITabBarController {
  
  var userType: UserType
  var userID: String
  var ageRange: AgeRange?
  var profilePicture: String?
  var name: String?
  
  init(userType: UserType, userID: String) {
    self.userType = userType
    self.userID = userID
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    getUserDetails(userID: userID, database: returnDatabase(userType: userType)) { username, profile in
        guard let username = username, let profile = profile else { return }
        
      self.name = username
      self.profilePicture = profile
      
      self.setupTabWithNavigation(username: username, profilePicture: profile)
    }
  }
  
  func setupTabWithNavigation(username: String, profilePicture: String) {
    
    self.navigationController?.isNavigationBarHidden = true
    
    let mainVc = MainPageVC()
    mainVc.userType = userType
    mainVc.userID = userID
    mainVc.ageRange = ageRange
    mainVc.configure(username: username, profileURL: profilePicture)
    let mainPage = UINavigationController(rootViewController: mainVc)
    mainPage.tabBarItem = UITabBarItem(title: "Anasayfa", image: UIImage(named: "anasayfa1x"), tag: 0)
    
    let zoomVc = ZoomVC()
    zoomVc.userID = userID
    let activity = UINavigationController(rootViewController: zoomVc)
    activity.tabBarItem = UITabBarItem(title: "Etkinlik", image: UIImage(named: "etkinlik1x"), tag: 1)
    
    let notiVC = NotificationVC()
    notiVC.userID = userID
    let notification = UINavigationController(rootViewController: notiVC )
    notification.tabBarItem = UITabBarItem(title: "Bildirimler", image: UIImage(named: "bildirim1x"), tag: 2)
    
    let profilVc = ProfileVC()
    profilVc.userID = userID
    profilVc.userType = userType
    profilVc.profilePicture = profilePicture
    let profil = UINavigationController(rootViewController: ProfileVC())
    profil.tabBarItem = UITabBarItem(title: "Profil", image: UIImage(named: "profil"), tag: 3)
    
    switch userType {
    case .volunteer:
      self.viewControllers = [mainPage,notification,profil]
    case .parent:
      self.viewControllers = [mainPage, profil]
    case .child:
      self.viewControllers = [mainPage,activity,notification,profil]
    }
    
    tabDesign()
  }
  
  func setupTab() {
    
    self.navigationController?.isNavigationBarHidden = true
    
    
    
    let mainPage = MainPageVC()
    mainPage.tabBarItem = UITabBarItem(title: "Anasayfa", image: UIImage(named: "anasayfa"), tag: 0)
    
    let activity = ZoomVC()
    activity.tabBarItem = UITabBarItem(title: "Etkinlik", image: UIImage(named: "etkinlik"), tag: 1)
    
    let notification = NotificationVC()
    notification.tabBarItem = UITabBarItem(title: "Bildirimler", image: UIImage(named: "bildirim"), tag: 2)
    
    let profil = ProfileVC()
    profil.tabBarItem = UITabBarItem(title: "Profil", image: UIImage(named: "profil"), tag: 3)
    
    self.viewControllers = [mainPage,activity,notification,profil]
    
    tabDesign()
  }
  
  func tabDesign() {
    let appereance = UITabBar.appearance()
    appereance.backgroundColor = .white
    appereance.unselectedItemTintColor = CustomColor.anaSarı.color
        appereance.tintColor = CustomColor.anaSarı.color
  }
  
  func getUserDetails(userID: String, database: String, completion: @escaping (String?, String?) -> Void) {
      let databaseRef = Database.database().reference()
      let reference = databaseRef.child(database).child(userID)

      reference.observeSingleEvent(of: .value) { (snapshot) in
          guard snapshot.exists() else {
              // Kullanıcı bulunamadıysa hata döndürün.
              print("Kullanıcı bulunamadıysa hata döndürün")
              let error = NSError(domain: "com.example.app", code: 102, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı bulunamadı"])
              completion(nil, nil)
              return
          }

          if let userData = snapshot.value as? [String: Any],
             let profileURL = userData["profilePicture"] as? String,
              let username = userData["name"] as? String {

              if self.userType == .child, let ageString = userData["age"] as? String {
                  guard let age = Int(ageString) else { return }
                  switch age {
                  case 7...12:
                      self.ageRange = .age7to12
                  case 13...15:
                      self.ageRange = .age13to15
                  case 16...18:
                      self.ageRange = .age16to18
                  default:
                      self.ageRange = .age7to12
                  }
                  print("Age Range: \(self.ageRange?.rawValue)")
              } else {
                  print("Age not found in Firebase")
              }
           
              completion(username, profileURL)
          } else {
              // Kullanıcı verileri eksikse veya çekilemediyse hata döndürün.
              print("Kullanıcı verileri eksik veya çekilemedi")
              let error = NSError(domain: "com.example.app", code: 101, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı verileri eksik veya çekilemedi"])
              completion(nil, nil)
          }
      }
  }
  
  func returnDatabase(userType: UserType) -> String {
      switch userType {
      case .volunteer:
          return "volunteers"
      case .parent:
          return "parents"
      case .child:
          return "children"
      }
  }
  
}
