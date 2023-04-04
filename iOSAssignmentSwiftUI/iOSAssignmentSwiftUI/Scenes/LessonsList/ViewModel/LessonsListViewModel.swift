//
//  LessonsListViewModel.swift
//  iOS Assignment
//
//  Created by Hassan dad khan on 31/03/2023.
//

import Foundation
import Combine

class LessonsListViewModel: ObservableObject {
    
    var repository: LessonsListRepositoryProtocol?
    @Published var lessons: LessonsModel?
    private var subscription = Set<AnyCancellable>()
    
    init(repository: LessonsListRepositoryProtocol = LessonsListRepository()) {
        self.repository = repository
    }
    
    
    //MARK: - API Calling
    func getLessonsList() {
        if NetworkMonitor.shared.isReachable {
            self.getLessonListFromAPI()
        } else {
            self.getLessonListFromDatabase()
        }
    }
    func getLessonListFromAPI() {
        self.repository?.getLessonListFromAPI()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    print("Lesson fetch finished")
                }
            }, receiveValue: { [weak self] lessonResult in
                self?.lessons = lessonResult
                DataManager.shared.lessons.lessons = lessonResult?.lessons ?? []
            })
            .store(in: &subscription)
        
    }
    func getLessonListFromDatabase() {
        self.repository?.getLessonListFromDatabase()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    print("Lesson fetch finished")
                }
            }, receiveValue: {[weak self] lessonResult in
                self?.lessons = lessonResult
                DataManager.shared.lessons.lessons = lessonResult?.lessons ?? []

            })
            .store(in: &subscription)
        
    }
}
