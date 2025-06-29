import UIKit

final class CustomActivityView: UIAlertController {

    static func createAlert() -> CustomActivityView {
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating()

        let alert = CustomActivityView(title: nil, message: "Please wait...", preferredStyle: .alert)
        alert.view.addSubview(loadingIndicator)

        return alert
    }
}
