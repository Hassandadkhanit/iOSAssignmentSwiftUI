//
//  MockLessonDetailRepository.swift
//  iOSAssignmentSwiftUI
//
//  Created by Hassan dad khan on 04/04/2023.
//

import Foundation
import CoreData
import Combine

class MockLessonDetailRepository: LessonDetailRepositoryProtocol {
    var subscription = Set<AnyCancellable>()
    
    func downloadVideo(lesson: Lessons?, completionProgress: @escaping  (Float) -> Void) -> Future<Bool,Error> {
        return Future<Bool,Error> { promise in
            guard let url = URL.init(string: lesson?.video_url ?? "") else {
                return promise(.failure(NetworkError.invalidURL))
            }
            if NetworkMonitor.shared.isReachable {
                APIClientHandler.shared.sendRequestDownload(url: url)
            } else {
                promise(.failure(NetworkError.connectionError))

            }
            
            APIClientHandler.shared.$downloadedResultPublisher
                .sink(receiveValue: { result in
                    switch result {
                    case .failure(let error):
                        promise(.failure(error))
                        break
                    case .success(let resultURL):
                        promise(.success(true))
                        break
                    case .none:
                        print("none")
                    }
                })
                .store(in: &self.subscription)
            
            APIClientHandler.shared.$progressResultPublisher
                .sink(receiveValue: { result in
                    switch result {
                    case .failure(let error):
                        break
                    case .success(let progress):
                        completionProgress(progress ?? 0.0)
                        break
                    case .none:
                        print("none")
                    }
                })
                .store(in: &self.subscription)

        }
    }
    func cancelDownload() {
        APIClientHandler.shared.cancelDownload()
    }
    
    func saveToFileManager(url : URL,lesson: Lessons?) {
        if let urlPath = Utilities.save(url: url, fileName: String(lesson?.id ?? 0), fileType: .mp4) {
            var updatedLesson = lesson
            updatedLesson?.saved_video_url = urlPath
            updateResponse(lesson: updatedLesson)
        }
    }
    
    //MARK: - Core Data methods
    
    func getLessonBy(id: Int) -> Lessons? {
        
        guard let result = getCDLesson(byIdentifier: id) else {
            return nil
        }
        return Lessons(id: Int(result.id),
                       name: result.name ?? "",
                       description: result.descriptions ?? "",
                       thumbnail: result.thumbnail ?? "",
                       video_url: result.video_url ?? "",
                       saved_video_url: result.saved_video_url ?? "")
         
    }
    func updateResponse(lesson: Lessons?) -> Bool {
        guard let result = getCDLesson(byIdentifier: lesson?.id ?? 0) else {
            return false
        }
        result.id = Int32(lesson?.id ?? 0)
        result.name = lesson?.name ?? ""
        result.descriptions = lesson?.description ?? ""
        result.thumbnail = lesson?.thumbnail ?? ""
        result.video_url = lesson?.video_url ?? ""
        result.saved_video_url = lesson?.saved_video_url ?? ""
        
        CoreDataManager.shared.saveContext()
        return true
    }
    
    
    //MARK: - Private Core data methods
    private func getCDLesson(byIdentifier: Int) -> CDLessons? {
        
        let fetchRequest = NSFetchRequest<CDLessons>(entityName: "CDLessons")
        let predicate = NSPredicate(format: "id == %i",byIdentifier)
        
        fetchRequest.predicate = predicate
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")

        do {
            let result = try CoreDataManager.shared.context.fetch(fetchRequest).first
            guard let obj = result else {return nil}
            return obj
            
        } catch let error {
            print(error.localizedDescription)
            return  nil
        }
        
    }
}
