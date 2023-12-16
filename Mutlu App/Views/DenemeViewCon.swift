import UIKit
import SnapKit

class DenemeViewCon: UIViewController {

    var options: [String] = ["Gelişim", "Moral", "Oyun"]
    var choosen = "Gelişim"

    private lazy var dropdownView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2
        view.layer.borderColor = CustomColor.anaSarı.color.cgColor
        view.backgroundColor = CustomColor.anaSarı.color.withAlphaComponent(0.15)
        view.layer.cornerRadius = 28

       
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 200
        // Metin
        let attributedString = NSAttributedString(string: choosen, attributes: [
            NSAttributedString.Key.font: Font.kohoSemibold14.chooseFont,
            NSAttributedString.Key.foregroundColor: CustomColor.anaSarı.color,
        ])
        let label = UILabel()
        label.attributedText = attributedString

        stackView.addArrangedSubview(label)

        // Aşağı yönlü ok görseli
        let arrowImage = UIImage(systemName: "chevron.down")
        let arrowImageView = UIImageView(image: arrowImage)
        arrowImageView.tintColor = CustomColor.anaSarı.color

        stackView.addArrangedSubview(arrowImageView)


        view.addSubview(stackView)
        

        // StackView'a constraint'leri ayarla
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview()
        }

        // UIView'a dokunma tanımla
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dropdownViewTapped))
        view.addGestureRecognizer(tapGesture)

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        choosen = options.first ?? ""
        view.backgroundColor = .white
        view.addSubview(dropdownView)

        dropdownView.snp.makeConstraints { make in
            make.width.equalTo(350)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

    @objc func dropdownViewTapped() {
        showDropdownMenu()
    }

    func showDropdownMenu() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        for option in options {
            let action = UIAlertAction(title: option, style: .default) { [weak self] _ in
                self?.handleDropdownSelection(option)
            }
            alertController.addAction(action)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        if let presentationController = alertController.popoverPresentationController {
            presentationController.sourceView = dropdownView
            presentationController.sourceRect = dropdownView.bounds
        }

        present(alertController, animated: true, completion: nil)
    }

    func handleDropdownSelection(_ selectedOption: String) {
        choosen = selectedOption
        updateDropdownViewTitle()
    }

    func updateDropdownViewTitle() {
        if let stackView = dropdownView.subviews.first as? UIStackView,
            let label = stackView.arrangedSubviews.first as? UILabel {

            let attributedString = NSAttributedString(string: choosen, attributes: [
                NSAttributedString.Key.font: Font.kohoSemibold14.chooseFont,
                NSAttributedString.Key.foregroundColor: CustomColor.anaSarı.color,
            ])
            label.attributedText = attributedString
        }
    }

}


