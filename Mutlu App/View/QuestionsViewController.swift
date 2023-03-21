

import UIKit
import SnapKit

class QuestionsViewController: UIViewController{
    
    private let tableView: UITableView = {
        let tableview = UITableView()
        tableview.register(AnswerTableViewCell.self, forCellReuseIdentifier: "Answer")
        tableview.register(QuestionTableViewCell.self, forCellReuseIdentifier: "Question")
        return tableview
    }()
    
    private let questionTextField: UITextField = {
        let textField = UITextField()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemPurple,
            .font: UIFont.italicSystemFont(ofSize: 15)
        ]
        textField.attributedPlaceholder = NSAttributedString(string: "Soru sorabilirsin :)", attributes: attributes)
        textField.backgroundColor = UIColor(red: 0.97, green: 0.94, blue: 0.73, alpha: 1.00)
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 10.0
        return textField
    }()
    
    private var sections = [section]()
    
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
        // Do any additional setup after loading the view.
        dataAndTableView()
        configure()
    }
    func configure() {
        view.addSubview(tableView)
        view.addSubview(questionTextField)
        view.backgroundColor = .white
        title = "Sorular"
        navigationItem.leftBarButtonItem = backButton
        tableView.rowHeight = view.frame.size.height * 0.13
        tableView.separatorStyle = .none
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalToSuperview().offset(-view.frame.size.height * 0.1)
        }
        questionTextField.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(10)
            make.left.equalTo(view).offset(10)
            make.right.equalTo(view).offset(-10)
            make.bottom.equalTo(view).offset(-10)
        }
    }
    func dataAndTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        sections =  [
            section(title: "Port Nedir?", options: ["Port göğüs bölgesine yerleştirilen, yumuşak plastikten yapılan incecik bir borudur.Port takılmasının amacı, sana iğne yapmadan ve canını acıtmadan ilaç verebilmektir. Bu yapılırken seni uyuturlar ve bu yüzden canın hiç yanmayacak." ,"Alet sayesinde acısız kan alınabilir ve verilebilir. Port haftalarca yada aylarca vücudunda kalabilir ve dışarıdan kimse bunu görmez/anlamaz. Tedavin bittiğinde, canın yanmadan sen uykudayken çıkarılır."], image: [UIImage(named: "Asset 151")!,UIImage(named: "Asset 111")!]),
            section(title: "Ameliyat Nedir?", options: ["Büyümemiz için hücrelerimiz her gün gelişir ve gerektiğinde çoğalarak yeni hücreler oluşturur. Ama bazen normalden daha hızlı büyüyebilir ve çoğalabilirler. Bu durumda fazla olan hücreler bedenimizin doğal çalışmalarını engelleyebilir ve bizi hasta edebilir.", "Bu yüzden bu hücrelerin alınması gerekir ve bu işleme ameliyat denilir. Ameliyat yapılmadan önce, doktor seni gevşetecek ve sonra uyumanı sağlayacak ilaçlar verir. Böylece sen ameliyat sırasında derin bir uykuda olursun ve yapılan işlemleri hissetmezsin. Canın hiç acımaz. Uyandığında yatağında yatıyor olacaksın. Bu işlem hem çocuklara hem büyüklere yapılabilir."], image: [UIImage(named: "Asset 251")!,UIImage(named: "Asset 151")!]),
            section(title: "Radyoterapi Nedir?", options: ["Radyoterapi yani ışın tedavisi, dışarıdan gözle görülmeyen ışınlar vererek normalden daha hızlı büyüyen hücrelerini yok etmek veya küçültmek için kullanılan bir tedavi yöntemidir. Işınları göremez ve hissedemezsin." , "Tek yapman gereken, işlem sırasında elinden geldiğinde hareketsiz durmaktır. Bu tedavi hiç canını acıtmaz."], image: [UIImage(named: "Asset 171")!,UIImage(named: "Asset 291")!]),
            section(title: "Tomografi Nedir?", options: ["Tomografi, diğer adıyla PET ve BT, doktorların bazı hastalıkları bulmak için vücudumuza detaylıca baktığı bir yöntemdir. Vücudun bir resmini çıkartır ve doktorun senin tedavini planlamasına yardımcı olur.",  "Alet kocaman bir simit gibi görünür. Sen özel bir yatağa yatarsın ve bu yatak bu simidin içinden geçer. İşlem sırasında hiçbir şey yapmana gerek yok sadece hareketsiz kalman yeterli. Bu işlem olurken canın hiç yanmayacak."], image: [UIImage(named: "Asset 21")!,UIImage(named: "Asset 281")!]),
            section(title: "Kemik İliği Örnek Alımı", options: ["Doktorların senin kemiğinin içinde bulunan ilikten bir parça örnek almasıdır. Bunu kemik iliğinin yapısını anlayabilmek için alır. Böylece doktor, senin kanın ile ilgili bir hastalığın olup olmadığını anlar." ,"Genelde kalça kemiği gibi büyük kemiklerden alınır.", "Bu işlem olurken doktorun senin gevşemen için verdiği ilaçlar ile uykun gelebilir. Sonrasında senden yüzüstü ya da yana doğru yatmanı ister. Önce cildini temizler, sonra da küçük bir iğne ile verdiği ilaçla o bölgeyi uyuşturur. Böylece örnek alınırken senin canın hiç yanmaz."],image: [UIImage(named: "Asset 271")!,UIImage(named: "Asset 201")!]),
            section(title: "Kemoterapi Nedir?", options: ["Kemoterapi, normalden daha hızlı büyüyen hücrelerin tedavisinde kullanılan çok güçlü bir ilaçtır. Kısaca kemo da denir. Bazen serumla damarından, bazen de hap olarak ağızdan verilebilir. İkisinin de sonunda ilaç kanına karışır ve bu şekilde vücuduna dağılır." ,"Çok güçlü bir ilaç demiştim ya, bu yüzden bazen hızlı büyüyen hücreleri yok ederken bazı normal hücreleri de yok edebilir. O zaman yan/bazı etkiler oluşur. Miden bulanabilir, saçların dökülebilir veya kendini çok yorgun hissedebilirsin. Ama bunlar tedavin bittiğinde geçecektir."],image: [UIImage(named: "Asset 241")!,UIImage(named: "Asset 211")!])
        ]
    }
}


extension QuestionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        return section.isOpened ? 2 : 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Question",for: indexPath) as? QuestionTableViewCell
            cell?.questionLabel.text = sections[indexPath.section].title
            cell?.customImageView.image = sections[indexPath.section].image?[0]
            cell?.backgroundColor = UIColor(red: 1.00, green: 0.92, blue: 0.65, alpha: 1.00)
            return cell!
        } else {
            let answerCell = tableView.dequeueReusableCell(withIdentifier: "Answer",for: indexPath) as? AnswerTableViewCell
            answerCell?.answerLabel1.text = String(sections[indexPath.section].options?[0] ?? "")
            answerCell?.answerLabel2.text = String?(sections[indexPath.section].options?[1] ?? "")
            answerCell?.imageView1.image = sections[indexPath.section].image?[0]
            answerCell?.imageView2.image = sections[indexPath.section].image?[1]
          
            
            answerCell!.backgroundColor = UIColor(red: 0.98, green: 0.83, blue: 0.56, alpha: 0.5)
            return answerCell!
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return view.frame.size.height * 0.15 // QuestionTableViewCell için yükseklik
        } else {
            return view.frame.size.height * 0.45// AnswerTableViewCell için yükseklik
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        sections[indexPath.section].isOpened = !sections[indexPath.section].isOpened
        tableView.reloadSections([indexPath.section], with: .none)
    }
}
