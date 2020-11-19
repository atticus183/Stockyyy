//
//  Extensions.swift
//  Stockyyy
//
//  Created by Josh R on 11/15/20.
//

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
    //Source: https://stackoverflow.com/questions/26667009/get-top-most-uiviewcontroller
    class func getTopMostViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
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

extension UIViewController {
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
