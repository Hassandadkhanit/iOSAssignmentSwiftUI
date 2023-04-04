//
//  LessonDetailViewModel.swift
//  iOSAssignmentSwiftUI
//
//  Created by Hassan dad khan on 04/04/2023.
//

import Foundation
import Combine

class LessonDetailViewModel {
    var repository: LessonDetailRepositoryProtocol?
    var subscription = Set<AnyCancellable>()
    var isDownloadInProgress = false
    @Published var progress: Float = 0.0
    @Published var downloadResult: Result<Bool,Error>?
    
    var lesson: Lessons?
    var selectedOffset: Int?

    init(repository: LessonDetailRepositoryProtocol = LessonDetailRepository()) {
        self.repository = repository
    }
    
    func downloadVideoFrom(lesson: Lessons?) {
        self.isDownloadInProgress = true
        repository?.downloadVideo(lesson: lesson, completionProgress: { progress in
            self.progress = progress
        })
        .sink(receiveCompletion: { completion in
            self.isDownloadInProgress = false
            switch completion {
            case .failure(let error):
                self.downloadResult = .failure(error)
                print(error.localizedDescription)
                break
            case.finished:
                break
            }
        }, receiveValue: { [weak self] success in
            self?.downloadResult = .success(success)

        })
        .store(in: &subscription)
        
    }
    func getLessonBy(id: Int) -> Lessons? {
        if let result =  repository?.getLessonBy(id: id) {
            return result
        }
        return nil
    }
    
}
