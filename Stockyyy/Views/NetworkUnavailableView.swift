import UIKit

final class NetworkUnavailableView: UIView {

    // MARK: - Properties

    lazy var iconImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "antenna.radiowaves.left.and.right")
        imgView.tintColor = .systemRed
        imgView.contentMode = .scaleAspectFit

        return imgView
    }()

    let messageLbl: UILabel = {
        let label = UILabel()
        label.text = "Network Unavailable"
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.minimumScaleFactor = 12
        label.numberOfLines = 1
        label.sizeToFit()

        return label
    }()

    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.alignment = .center
        sv.distribution = .fill
        sv.axis = .horizontal
        sv.spacing = 3
        sv.sizeToFit()

        return sv
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("Using storyboards.  Please add setupView method.")
    }

    // MARK: - Methods

    private func setupView() {
        backgroundColor = .clear

        stackView.addArrangedSubview(iconImgView)
        stackView.addArrangedSubview(messageLbl)

        addSubview(stackView)

        setupConstraints()
    }

    private func setupConstraints() {
        iconImgView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),

            iconImgView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            iconImgView.widthAnchor.constraint(greaterThanOrEqualToConstant: 30)
        ])
    }
}
