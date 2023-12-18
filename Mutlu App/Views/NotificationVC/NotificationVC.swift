//
//  NotificationVC.swift
//  Mutlu App
//
//  Created by Kullanici on 12.12.2023.
//

import UIKit
import Firebase
import FirebaseDatabase

class NotificationVC: UIViewController {
  
  var notificationArray = [[String]]()
  var userID: String?
  
    private lazy var tableView : UITableView = {
           let tableView = UITableView()
           tableView.backgroundColor = .clear
           tableView.separatorStyle = .none
           tableView.delegate = self
           tableView.dataSource = self
           tableView.register(NotificationCell.self, forCellReuseIdentifier: "noCell")
           tableView.backgroundColor = .clear
           return tableView
       }()

    override func viewDidLoad() {
        super.viewDidLoad()

      setupView()
      guard let userID = userID else {return}
      fetchNotification(userID: userID) { array in
        self.notificationArray = array
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      }
    }
  
  func fetchNotification(userID: String, completion: @escaping ([[String]]) -> Void) {
      
      // Veriyi çekme
      Database.database().reference().child("notifications").child(userID).observeSingleEvent(of: .value) { (snapshot) in
          guard snapshot.exists(), let notificationsData = snapshot.children.allObjects as? [DataSnapshot] else {
              completion([])
              return
          }
          
          var notificationArray: [[String]] = []
          
          // Her alt küme için işlemleri gerçekleştir
          for notificationSnapshot in notificationsData {
              guard let notificationData = notificationSnapshot.value as? [String: Any],
                    let name = notificationData["name"] as? String,
                    let date = notificationData["date"] as? String,
                    let from = notificationData["from"] as? String,
                    let path = notificationData["path"] as? String else {
                  continue
              }
            
            let smallDate = self.calculateTimeDifference(from: date)
              
              let notificationRow = [name, smallDate, from, path]
              notificationArray.append(notificationRow)
          }
          
          completion(notificationArray)
      }
  }

  func calculateTimeDifference(from date: String) -> String {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
      
      guard let startDate = dateFormatter.date(from: date) else {
          return ""
      }
      
      let endDate = Date() // Şu anki tarih ve saat
      
      let calendar = Calendar.current
      let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: startDate, to: endDate)
      
      if let year = components.year, year > 0 {
          return "\(year)y"
      } else if let month = components.month, month > 0 {
          return "\(month)m"
      } else if let day = components.day, day > 0 {
          return "\(day)d"
      } else if let hour = components.hour, hour > 0 {
          return "\(hour)h"
      } else if let minute = components.minute, minute > 0 {
          return "\(minute)m"
      } else if let second = components.second, second > 0 {
          return "\(second)s"
      } else {
          return "Now"
      }
  }
    

  private func setupView() {
      view.backgroundColor = CustomColor.attributedWhite.color
    self.navigationItem.title = "Bildirimler"
      view.addSubViews(tableView)
      setupLayout()
  }
  private func setupLayout() {
   
      tableView.snp.makeConstraints { make in
          make.top.equalToSuperview().offset(10)
          make.leading.equalToSuperview()
          make.trailing.equalToSuperview()
          make.bottom.equalToSuperview()
      }
  }


}

extension NotificationVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
}

extension NotificationVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return notificationArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "noCell", for: indexPath) as?  NotificationCell else {return UITableViewCell()}
 print("notifi array\(notificationArray)")
    cell.configure(item: notificationArray[indexPath.row])
    
    return cell
  }
  

}
