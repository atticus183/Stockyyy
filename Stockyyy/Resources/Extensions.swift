import Foundation
import UIKit

extension Date {
    static func numberOf(_ period: Calendar.Component, from startDate: Date, to endDate: Date) -> Int? {
        let daysSince = Calendar.current.dateComponents([period], from: startDate, to: endDate)

        switch period {
        case .hour:
            return daysSince.hour
        case .day:
            return daysSince.day
        case .month:
            return daysSince.month
        case .year:
            return daysSince.year
        default:
            return nil
        }
    }
}

extension UIApplication {
    // Source: https://stackoverflow.com/questions/26667009/get-top-most-uiviewcontroller
    class func getTopMostViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        } else {
            return nil
        }
    }
}

extension UITableViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}

extension UIViewController {
    func alert(message: String, title: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }

    // Source: https://stackoverflow.com/questions/27960556/loading-an-overlay-when-running-long-tasks-in-ios
    func startActivityView() {
        DispatchQueue.main.async {
            let alert = CustomActivityView.createAlert()
            let presentingVC = UIApplication.getTopMostViewController()!
            presentingVC.present(alert, animated: true)
        }
    }

    func stopActivityView() {
        DispatchQueue.main.async {
            let presentingVC = UIApplication.getTopMostViewController()!
            if let alertController = presentingVC as? CustomActivityView {
                alertController.dismiss(animated: true)
            }
        }
    }
}
