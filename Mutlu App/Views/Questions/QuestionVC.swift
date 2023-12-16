//
//  QuestionVC.swift
//  Mutlu App
//
//  Created by Kullanici on 12.11.2023.
//

import UIKit
import SnapKit
import Firebase
import FirebaseDatabase

class QuestionVC: UIViewController {
    
    var questions: [QuestionsModel] = []
    
    var ageRange: AgeRange?
    
    var userID: String?
    
    var userType: UserType?
    
    private lazy var tableView : UITableView = {
           let tableView = UITableView()
           tableView.backgroundColor = .clear
           tableView.separatorStyle = .none
           tableView.delegate = self
           tableView.dataSource = self
           tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
           tableView.backgroundColor = .clear
           return tableView
       }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
      

       fetchQuestions()
        
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubViews(tableView)
        setupLayout()
    }
    private func setupLayout() {
        tableView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func fetchQuestions() {
        if userType == .child {
            if let ageRange = ageRange {
                fetchChildQuestions(for: ageRange)
            }
        } else {
            fetchParentQuestions()
        }
    }
    
    func fetchChildQuestions(for ageRange: AgeRange) {
        print(ageRange.rawValue)
            let ref = Database.database().reference().child("NewBase/cocuk/\(ageRange.rawValue)/questions")

            ref.observeSingleEvent(of: .value) { [weak self] (snapshot) in
                guard let self = self else { return }

                if let data = snapshot.value as? [String: Any] {
                    var fetchedQuestions: [QuestionsModel] = []

                    for (_, value) in data {
                        if let questionData = value as? [String: Any],
                            let answer = questionData["answer"] as? String,
                            let image = questionData["image"] as? String,
                            let title = questionData["title"] as? String {

                            let question = QuestionsModel(title: title, answer: answer, image: image)
                            self.questions.append(question)
                        }
                    }
                    print(self.questions[0].answer)
                    self.tableView.reloadData()
                }
            }
        }
    func fetchParentQuestions() {
            let ref = Database.database().reference().child("NewBase/refakatci/questions")

            ref.observeSingleEvent(of: .value) { [weak self] (snapshot) in
                guard let self = self else { return }

                if let data = snapshot.value as? [String: Any] {

                    for (_, value) in data {
                        if let questionData = value as? [String: Any],
                            let answer = questionData["answer"] as? String,
                            let image = questionData["image"] as? String,
                            let title = questionData["title"] as? String {

                            let question = QuestionsModel(title: title, answer: answer, image: image)
                            self.questions.append(question)
                        }
                    }
                    print(self.questions[0].answer)
                    self.tableView.reloadData()
                }
            }
        }


   

}

extension QuestionVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = AnswerVC()
        vc.configure(item: questions[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension QuestionVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomTableViewCell else {return UITableViewCell()}
        cell.configureQuestion(item: questions[indexPath.row])
        cell.rightView.isHidden = true
        return cell
    }
}
