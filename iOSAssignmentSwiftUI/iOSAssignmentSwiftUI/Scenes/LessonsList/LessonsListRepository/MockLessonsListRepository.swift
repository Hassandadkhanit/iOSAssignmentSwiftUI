//
//  MockLessonsListRepository.swift
//  iOSAssignmentSwiftUI
//
//  Created by Hassan dad khan on 04/04/2023.
//

import Foundation
import CoreData

import Combine


class MockLessonsListRepository: LessonsListRepositoryProtocol {

    
    var subscription = Set<AnyCancellable>()

    //MARK: - API Calling
    func getLessonListFromAPI() -> Future<LessonsModel?, Error> {
        return Future<LessonsModel?,Error> { promise in
            APIClientHandler.shared.sendRequest(urlString: RouteUrls.getRouteUrlWith(route: RouteUrls.lessons), parameters: [:], method: .get)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        promise(.failure(error))
                    case .finished:
                        print("Finished")
                    }
                } receiveValue: { data in
                    do {
                       let lessonObj = try JSONDecoder().decode(LessonsModel.self, from: data)
                        promise(.success(lessonObj))
                    } catch (let error) {
                        promise(.failure(error))
                    }
                }.store(in: &self.subscription)
        }
    }
    
    //MARK: Database methods
    func getLessonListFromDatabase() -> Future<LessonsModel?, Error> {
        return Future<LessonsModel?,Error> { promise in
            do {
               guard let result = try CoreDataManager.shared.context.fetch(CDLessons.fetchRequest()) as? [CDLessons] else {
                   return
                }
                let lessons: [Lessons] = result.map { CdLesson in
                    Lessons.init(id: Int(CdLesson.id),
                                 name: CdLesson.name ?? "",
                                 description: CdLesson.descriptions ?? "",
                                 thumbnail: CdLesson.thumbnail ?? "",
                                 video_url: CdLesson.video_url ?? "",
                                 saved_video_url: CdLesson.saved_video_url ?? "")
                }
                
                promise(.success(LessonsModel.init(lessons: lessons)))
                
            } catch let error {
                promise(.failure(error))
            }
        }
    }
    
    func getLessonBy(id: Int) -> Lessons? {
        guard let result = getCDLesson(byIdentifier: id) else {
            return nil
        }
        return Lessons(id: Int(result.id ),
                       name: result.name ?? "",
                       description: result.descriptions ?? "",
                       thumbnail: result.thumbnail ?? "",
                       video_url: result.video_url ?? "",
                       saved_video_url: result.saved_video_url ?? "")
    }
    
    func updateResponse(lesson: Lessons) -> Bool {
        return false
    }
    
    func createResponse(lesson: Lessons) {
        //
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
