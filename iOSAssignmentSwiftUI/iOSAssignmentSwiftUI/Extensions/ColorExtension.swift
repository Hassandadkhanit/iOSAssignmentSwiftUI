//
//  ColorExtension.swift
//  iOS Assignment
//
//  Created by Hassan dad khan on 31/03/2023.
//

import Foundation
import UIKit
import SwiftUI

extension Color {
    static let customTextColor = Color("CustomTextColor")
    static let separatorColor = Color("SeparatorColor")
    static let customBackgroundColor = Color("CustomBackgroundColor")
    
}

extension UIColor {
    static let  customTextColor = UIKit.UIColor(named: "CustomTextColor") ?? .black
    static let  separatorColor = UIKit.UIColor(named: "SeparatorColor") ?? .black
    static let  customBackgroundColor = UIKit.UIColor(named: "CustomBackgroundColor") ?? .black
}
extension View {
    /// Sets the text color for a navigation bar title.
    /// - Parameter color: Color the title should be
    ///
    /// Supports both regular and large titles.
    @available(iOS 14, *)
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
    
        // Set appearance for both normal and large sizes.
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
    
        return self
    }
}
