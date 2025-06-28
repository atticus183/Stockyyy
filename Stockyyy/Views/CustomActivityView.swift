import UIKit

class CustomActivityView: UIAlertController {

    static func createAlert() -> CustomActivityView {
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating()

        let alert = CustomActivityView(title: nil, message: "Please wait...", preferredStyle: .alert)
        alert.view.addSubview(loadingIndicator)

        return alert
    }

    static func startActivityView() {
        // Source: https://stackoverflow.com/questions/27960556/loading-an-overlay-when-running-long-tasks-in-ios
        let alert = CustomActivityView.createAlert()
        let presentingVC = UIApplication.getTopMostViewController()!
        presentingVC.present(alert, animated: true, completion: nil)
    }

    // Be sure to call this method on the main thread
    static func stopActivityView() {
        let presentingVC = UIApplication.getTopMostViewController()!
        if let alertController = presentingVC as? CustomActivityView {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
}
