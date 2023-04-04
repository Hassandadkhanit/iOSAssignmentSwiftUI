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
        let viewModel = LessonDetailViewModel()
        viewModel.lesson = lesson
        viewModel.selectedOffset = selectedOffset ?? -1
        let controller = LessonDetailViewController.init(viewModel: viewModel)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: LessonDetailViewController, context: Context) {
        
    }

}
