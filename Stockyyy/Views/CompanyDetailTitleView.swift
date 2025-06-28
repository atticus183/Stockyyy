import Kingfisher
import UIKit

class CompanyDetailTitleView: UIView {

    var company: CompanyJSON? {
        didSet {
            if let url = URL(string: company?.image ?? "") {
                companyLogoImgView.kf.setImage(with: url, placeholder: UIImage(systemName: "questionmark.circle.fill"))
                companyLogoImgViewConstraints = [
                    companyLogoImgView.heightAnchor.constraint(equalToConstant: 35),
                    companyLogoImgView.widthAnchor.constraint(equalToConstant: 35)
                ]
            } else {
                companyLogoImgViewConstraints = [
                    companyLogoImgView.heightAnchor.constraint(equalToConstant: 0),
                    companyLogoImgView.widthAnchor.constraint(equalToConstant: 0)
                ]
            }

            companyLbl.text = company?.symbol ?? ""
        }
    }

    lazy var companyLogoImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        imgView.backgroundColor = .clear
        imgView.contentMode = .scaleAspectFit
        imgView.layer.cornerRadius = 5
        imgView.clipsToBounds = true

        return imgView
    }()

    lazy var companyLbl: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 1
        label.textAlignment = .left

        return label
    }()

    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 4

        return sv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews(views: stackView)
    }

    // Note - Not using SB
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubViews(views: UIView...) {
        stackView.addArrangedSubview(companyLogoImgView)
        stackView.addArrangedSubview(companyLbl)

        views.forEach { self.addSubview($0) }
        views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        setConstraints()
    }

    // Since the API doesn't always provide a valid picture, the constraints need to be dynamic so they can be set to 0.
    private var companyLogoImgViewConstraints: [NSLayoutConstraint] = [] {
            willSet { NSLayoutConstraint.deactivate(companyLogoImgViewConstraints) }
            didSet { NSLayoutConstraint.activate(companyLogoImgViewConstraints) }
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0),
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0)
        ])
    }
}
