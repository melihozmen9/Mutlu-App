//
//  ZoomVC.swift
//  Mutlu App
//
//  Created by Kullanici on 2.12.2023.
//

import UIKit
import SnapKit
import Firebase
import FirebaseDatabase

class ZoomVC: UIViewController {
    
    var zoomList = [ZoomModel]()
    var userID: String?
    
    private lazy var comingLbl: UILabel = {
        let l = UILabel()
        l.font = Font.kohoSemiBold18.chooseFont
        l.textColor = .black
        l.textAlignment = .left
        l.text = "Yaklaşan Etkinlikler"
        return l
    }()
    
    private lazy var explanationLbl: UILabel = {
        let l = UILabel()
        l.font = Font.kohoRegular12.chooseFont
        l.textColor = CustomColor.metinGrisi2.color
        l.textAlignment = .center
        l.text = "Etkinliğin üzerine tıklayarak katılabilirsin."
        return l
    }()
    
    private lazy var tableView : UITableView = {
           let tableView = UITableView()
        tableView.backgroundColor = .clear
           tableView.separatorStyle = .none
           tableView.delegate = self
           tableView.dataSource = self
           tableView.register(ZoomCell.self, forCellReuseIdentifier: "zoom")
           tableView.backgroundColor = .clear
           return tableView
       }()

    override func viewDidLoad() {
        super.viewDidLoad()

     setupView()
        fetchZoomData { _ in
            self.tableView.reloadData()
            }
        }
    
  
    func fetchZoomData(completion: @escaping ([ZoomModel]) -> Void) {

        // Veriyi çekme
        Database.database().reference().child("zoom").observeSingleEvent(of: .value) { (snapshot) in
            guard let activitiesSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                completion([])
                return
            }

            // Her alt küme için işlemleri gerçekleştir
            for activitySnapshot in activitiesSnapshot {
                guard let activityData = activitySnapshot.value as? [String: Any] else {
                    continue
                }

                // isActive değeri true olanları filtrele
                if let isActive = activityData["isActive"] as? Bool, isActive {
                    let zoomModel = ZoomModel(
                        title: activityData["title"] as? String ?? "",
                        date: activityData["date"] as? String ?? "",
                        image: activityData["image"] as? String ?? "",
                        location: activityData["location"] as? String ?? ""
                    )
                    self.zoomList.append(zoomModel)
                }
            }
            completion(self.zoomList)
        }
    }
 
    private func setupView() {
        view.backgroundColor = CustomColor.attributedWhite.color
        view.addSubViews(comingLbl,tableView,explanationLbl)
        setupLayout()
    }
    private func setupLayout() {
        comingLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(116)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(24)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(comingLbl.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(explanationLbl.snp.top).offset(-10)
        }
        explanationLbl.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-70)
        }
    }
}

extension ZoomVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           tableView.deselectRow(at: indexPath, animated: true)
        if let userID = userID {
            let vc = ZoomPopUpVC()
            vc.userID = userID
            present(vc, animated: true)
        }
        
       }
}

extension ZoomVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zoomList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "zoom", for: indexPath) as? ZoomCell else {return UITableViewCell()}
        cell.configure(item: zoomList[indexPath.row])
    return cell
    }
}


