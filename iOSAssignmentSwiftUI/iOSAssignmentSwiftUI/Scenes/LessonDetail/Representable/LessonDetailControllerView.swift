//
//  LessonDetailControllerView.swift
//  iOS Assignment
//
//  Created by Hassan dad khan on 03/04/2023.
//

import Foundation
import SwiftUI

struct LessonDetailControllerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = LessonDetailViewController
    
    func makeUIViewController(context: Context) -> LessonDetailViewController {
        let controller = LessonDetailViewController.init()
       
        return controller
    }
    
    func updateUIViewController(_ uiViewController: LessonDetailViewController, context: Context) {
        
    }
    
    
    
    
    
}
