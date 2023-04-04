//
//  UIControllerExtesnion.swift
//  iOSAssignmentSwiftUI
//
//  Created by Hassan dad khan on 04/04/2023.
//

import Foundation
import UIKit

extension UIViewController {
    func presentAlertWithTitleAndMessage(title: String, message: String, options: String..., completion: @escaping (Int) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, option) in options.enumerated() {
            alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                completion(index)
            }))
        }
        self.present(alertController, animated: true, completion: nil)
    }
}
