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
    
    var lesson: Lessons?
    var selectedOffset: Int?
    func makeUIViewController(context: Context) -> LessonDetailViewController {
        let controller = LessonDetailViewController.init()
        controller.lesson = lesson
        controller.selectedOffset = selectedOffset ?? -1
        return controller
    }
    
    func updateUIViewController(_ uiViewController: LessonDetailViewController, context: Context) {
        
    }
    
    
    
    
    
}
