//
//  MainPageVC.swift
//  Mutlu App
//
//  Created by Kullanici on 12.11.2023.
//

import UIKit
import SnapKit
import Firebase
import FirebaseDatabase
import Kingfisher

class MainPageVC: UIViewController {
    
    var userType: UserType?
    var userID: String?
    var profilePicture: URL?
    var ageRange: AgeRange?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .clear
        return contentView
    }()
    
    private lazy var topView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 20
        return v
    }()
    
    private lazy var ppImageview: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var welcomeLbl: UILabel = {
        let l = UILabel()
        l.textColor = .black
        l.font = Font.kohoMedium14.chooseFont
        l.text = "Hoş Geldin!"
        return l
    }()
    
    private lazy var nameLbl: UILabel = {
        let l = UILabel()
        l.font = Font.kohoBold16.chooseFont
        l.textColor = CustomColor.orange.color
        return l
    }()
    
    private lazy var feelingLbl: UILabel = {
        let l = UILabel()
        l.textColor = .black
        l.font = Font.kohoMedium16.chooseFont
        l.text = "Bugün nasıl hissediyorsun?"
        return l
    }()
    
    private lazy var emotionView1: UIView = {
        let v = UIView()
        v.backgroundColor = CustomColor.green.color.withAlphaComponent(0.75)
        v.layer.cornerRadius = v.frame.size.width / 2
        v.clipsToBounds = true
        return v
    }()
    
    private lazy var emotionIV1: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        return iv
    }()
    private lazy var emotionView2: UIView = {
        let v = UIView()
        v.backgroundColor = CustomColor.purpleOpacity15.color.withAlphaComponent(0.75)
        v.layer.cornerRadius = v.frame.size.width / 2
        v.clipsToBounds = true
        return v
    }()
    private lazy var emotionIV2: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        
        return iv
    }()
    private lazy var emotionView3: UIView = {
        let v = UIView()
        v.backgroundColor = CustomColor.orange.color.withAlphaComponent(0.75)
        v.layer.cornerRadius = v.frame.size.width / 2
        v.clipsToBounds = true
        return v
    }()
    private lazy var emotionIV3: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        
        return iv
    }()
    private lazy var rightIV: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "duckPaper")
        return iv
    }()
    
    private lazy var questionOption: OptionView = {
        let v = OptionView()
        v.imageview.image = UIImage(named: "questions")
        v.titleLbl.text = "Sorular"
        v.subtitleLbl.text = "Merak ettiğin sorulara buradan ulaşabilirsin."
        v.titleLbl.textColor = CustomColor.green.color
        v.backgroundColor = CustomColor.green.color.withAlphaComponent(0.15)
        return v
    }()
    private lazy var videoOption: OptionView = {
        let v = OptionView()
        v.imageview.image = UIImage(named: "videos")
        v.titleLbl.text = "Videolar"
        v.subtitleLbl.text = "Videoları izlemek için tıkla"
        v.titleLbl.textColor = CustomColor.orange.color
        v.backgroundColor = CustomColor.lightOrange.color
        return v
    }()
    private lazy var letterOption: OptionView = {
        let v = OptionView()
        v.imageview.image = UIImage(named: "letters")
        v.titleLbl.text = "Mektup Yaz"
        v.subtitleLbl.text = "Mektuplarına buradan ulaşabilirsin."
        v.titleLbl.textColor = CustomColor.purpleOpacity15.color
        v.backgroundColor = CustomColor.purpleOpacity15.color.withAlphaComponent(0.15)
        return v
    }()
    private lazy var zoomOption: OptionView = {
        let v = OptionView()
        v.imageview.image = UIImage(named: "zoom")
        v.titleLbl.text = "Zoom"
        v.subtitleLbl.text = "Oyun etkinliklerine buradan ulaşabilirsin."
        v.titleLbl.textColor = CustomColor.blueOpacity15.color
        v.backgroundColor = CustomColor.blueOpacity15.color.withAlphaComponent(0.15)
        return v
    }()
    
    private lazy var childRightViews: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 20
        v.backgroundColor = CustomColor.pembe.color
        return v
    }()
    
    private lazy var childRightIV: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "childRights")
        iv.backgroundColor = CustomColor.pembe.color
        return iv
    }()
    
    private lazy var crtitleLbl: UILabel = {
        let l = UILabel()
        l.font = Font.kohoBold16.chooseFont
        l.textColor = CustomColor.koyuPembe.color
        l.text = "Çocuk Hakları"
        l.textAlignment = .left
        return l
    }()
    
    private lazy var crsubtitleLbl: UILabel = {
        let l = UILabel()
        l.font = Font.kohoMedium14.chooseFont
        l.textColor = CustomColor.gri2.color
        l.text = "Çocuk Hakları Bildirgesi’ni okumak için buraya tıkla."
        l.textAlignment = .left
        l.numberOfLines = 0
        l.textAlignment = .center
        return l
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewGestures()
        addTapgestureToIV()
        
        guard let userID = userID, let userType = userType else { return }
        
        getUserDetails(userID: userID, database: returnDatabase(userType: userType)) { username, profile in
            guard let username = username, let profile = profile else { return }
            
            self.configure(username: username, profileURL: profile)
        }
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        if let tappedView = gesture.view {
            // Tıklanan view bulundu
            updateOpacity(tappedView)
        }
    }
    
    func configure(username: String, profileURL: String) {
        
        nameLbl.text = username
        
        topView.backgroundColor = userType == .child ? CustomColor.lightSarı.color : CustomColor.avokadoGreen.color
        ppImageview.image = UIImage(named: userType == .child ? "duckSleep" : "avokadoPP")
        emotionIV1.image = UIImage(named: userType == .child ? "happy" : "aHappy")
        emotionIV2.image = UIImage(named: userType == .child ? "normal" : "aNormal")
        emotionIV3.image = UIImage(named: userType == .child ? "angry" : "aBad")
        if profileURL.isEmpty {
            rightIV.kf.setImage(with: URL(string: profileURL))
        } else {
            rightIV.image = UIImage(named: userType == .child ? "duckPaper" : "aMain")
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
    
    public func addTapgestureToIV(){
        emotionView1.isUserInteractionEnabled = true
        emotionView1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        
        emotionView2.isUserInteractionEnabled = true
        emotionView2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        
        emotionView3.isUserInteractionEnabled = true
        emotionView3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
    }
    
    private func updateOpacity(_ tappedView: UIView) {
        // Tıklanan view'un opacity'sini değiştir
        tappedView.alpha = 1.0
        
        // Diğer view'ların opacity'sini sıfırla
        let allViews = [emotionView1, emotionView2, emotionView3]
        
        for view in allViews where view != tappedView {
            view.alpha = 0.15
        }
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
    
    override func viewDidLayoutSubviews() {
        // let height = descriptionLabel.frame.height + descriptionLabel.frame.origin.y
        scrollView.contentSize = CGSize(width: self.view.frame.width,
                                        height: self.view.frame.height)
    }
    
    @objc private func questionTapped() {
        let vc = QuestionVC()
        vc.userType = userType
        vc.userID = userID
        vc.ageRange = ageRange
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func videoTapped() {
        let vc = VideosVC()
        vc.userType = userType
        vc.userID = userID
        vc.ageRange = ageRange
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func zoomTapped() {
        let vc = ZoomVC()
        vc.userID = userID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func letterTapped() {
        let vc = LettersMainVC()
        vc.userID = userID
        vc.userType = userType
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func childRightsTapped() {
        let vc = ChildRightsVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubViews(scrollView)
        scrollView.addSubViews(contentView)
        contentView.addSubViews(topView,questionOption,videoOption,letterOption,zoomOption,childRightViews)
        topView.addSubViews(ppImageview,welcomeLbl,nameLbl,feelingLbl,emotionView1,emotionView2,emotionView3,rightIV)
        emotionView1.addSubViews(emotionIV1)
        emotionView2.addSubViews(emotionIV2)
        emotionView3.addSubViews(emotionIV3)
        childRightViews.addSubViews(childRightIV,crtitleLbl,crsubtitleLbl)
        setupLayout()
    }
    private func setupLayout() {
        
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            //            make.top.leading.trailing.bottom.equalToSuperview()
        }
        topView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(190)
        }
        ppImageview.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
            make.height.width.equalTo(56)
        }
        welcomeLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalTo(ppImageview.snp.trailing).offset(10)
            make.height.equalTo(18)
            make.width.equalTo(100)
        }
        nameLbl.snp.makeConstraints { make in
            make.top.equalTo(welcomeLbl.snp.bottom).offset(1)
            make.leading.equalTo(welcomeLbl.snp.leading)
            make.width.equalTo(100)
            make.height.equalTo(21)
        }
        feelingLbl.snp.makeConstraints { make in
            make.top.equalTo(ppImageview.snp.bottom).offset(9)
            make.leading.equalTo(ppImageview.snp.leading)
            make.width.equalTo(200)
            make.height.equalTo(21)
        }
        emotionView1.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.width.height.equalTo(40)
        }
        emotionIV1.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.width.height.equalTo(30)
        }
        emotionView2.snp.makeConstraints { make in
            make.leading.equalTo(emotionIV1.snp.trailing).offset(10)
            make.bottom.equalToSuperview().offset(-16)
            make.width.height.equalTo(40)
        }
        emotionIV2.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.width.height.equalTo(30)
        }
        emotionView3.snp.makeConstraints { make in
            make.leading.equalTo(emotionIV2.snp.trailing).offset(10)
            make.bottom.equalToSuperview().offset(-16)
            make.width.height.equalTo(40)
        }
        emotionIV3.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.width.height.equalTo(30)
        }
        emotionCornerRadius()
        
        rightIV.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.bottom.equalToSuperview().offset(-28)
            make.trailing.equalToSuperview().offset(-21)
            make.width.equalTo(85)
        }
        
        switch userType {
        case .child:
            childLayout()
        case .parent:
            parentLayout()
        case .volunteer:
            volunteerLayout()
        case .none:
            break
        }
        childRightIV.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.width.equalTo(152)
        }
        crtitleLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(23)
            make.leading.equalTo(childRightIV.snp.trailing).offset(11)
            make.trailing.equalToSuperview().offset(-5)
            make.height.equalTo(20)
        }
        crsubtitleLbl.snp.makeConstraints { make in
            make.top.equalTo(crtitleLbl.snp.bottom)
            make.leading.equalTo(crtitleLbl.snp.leading)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        
        contentView.layoutSubviews()
    }
    func emotionCornerRadius() {
        emotionView1.layoutIfNeeded()
        emotionView1.layer.cornerRadius = 0.5 * emotionView1.bounds.size.width
        emotionView2.layoutIfNeeded()
        emotionView2.layer.cornerRadius = 0.5 * emotionView2.bounds.size.width
        emotionView3.layoutIfNeeded()
        emotionView3.layer.cornerRadius = 0.5 * emotionView2.bounds.size.width
    }
    
    func childLayout() {
        questionOption.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(165)
            make.height.equalTo(190)
        }
        videoOption.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(24)
            make.leading.equalTo(questionOption.snp.trailing).offset(20)
            make.width.equalTo(165)
            make.height.equalTo(190)
        }
        letterOption.snp.makeConstraints { make in
            make.top.equalTo(questionOption.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(165)
            make.height.equalTo(190)
        }
        zoomOption.snp.makeConstraints { make in
            make.top.equalTo(videoOption.snp.bottom).offset(24)
            make.leading.equalTo(letterOption.snp.trailing).offset(20)
            make.width.equalTo(165)
            make.height.equalTo(190)
        }
        childRightViews.snp.makeConstraints { make in
            make.top.equalTo(letterOption.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
    }
    
    func volunteerLayout() {
        letterOption.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(165)
            make.height.equalTo(190)
        }
        videoOption.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(24)
            make.leading.equalTo(letterOption.snp.trailing).offset(20)
            make.width.equalTo(165)
            make.height.equalTo(190)
        }
        childRightViews.snp.makeConstraints { make in
            make.top.equalTo(videoOption.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
    }
    func parentLayout() {
        questionOption.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(165)
            make.height.equalTo(190)
        }
        videoOption.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(24)
            make.leading.equalTo(questionOption.snp.trailing).offset(20)
            make.width.equalTo(165)
            make.height.equalTo(190)
        }
        childRightViews.snp.makeConstraints { make in
            make.top.equalTo(videoOption.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
    }
    
    
    
    
    private func viewGestures() {
        let questionGesture = UITapGestureRecognizer(target: self, action: #selector(questionTapped))
        questionOption.addGestureRecognizer(questionGesture)
        questionOption.isUserInteractionEnabled = true
        
        let videoGesture = UITapGestureRecognizer(target: self, action: #selector(videoTapped))
        videoOption.addGestureRecognizer(videoGesture)
        videoOption.isUserInteractionEnabled = true
        
        let zoomGesture = UITapGestureRecognizer(target: self, action: #selector(zoomTapped))
        zoomOption.addGestureRecognizer(zoomGesture)
        zoomOption.isUserInteractionEnabled = true
        
        let letterGesture = UITapGestureRecognizer(target: self, action: #selector(letterTapped))
        letterOption.addGestureRecognizer(letterGesture)
        letterOption.isUserInteractionEnabled = true
        
        let childRightsGesture = UITapGestureRecognizer(target: self, action: #selector(childRightsTapped))
        childRightViews.addGestureRecognizer(childRightsGesture)
        childRightViews.isUserInteractionEnabled = true
    }
    
}
