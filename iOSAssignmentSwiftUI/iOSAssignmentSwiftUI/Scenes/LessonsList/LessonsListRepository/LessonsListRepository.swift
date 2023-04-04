//
//  LessonsListRepository.swift
//  iOS Assignment
//
//  Created by Hassan dad khan on 31/03/2023.
//

import Foundation
import Combine
import CoreData

protocol LessonsListRepositoryProtocol {
    func getLessonListFromAPI() -> Future<LessonsModel?,Error>
    func getLessonListFromDatabase() -> Future<LessonsModel?,Error>
    func getLessonBy(id: Int) -> Lessons?
}

class LessonsListRepository: LessonsListRepositoryProtocol {
    
    
    var subscription = Set<AnyCancellable>()
    
    //MARK: - API Calling
    func getLessonListFromAPI() -> Future<LessonsModel?,Error> {
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
                        self.saveResponse(lessons: lessonObj)
                    } catch (let error) {
                        promise(.failure(error))
                    }
                }.store(in: &self.subscription)

        }
    }
    
    // MARK: - CoreData Methods
    
    func getLessonListFromDatabase() -> Future<LessonsModel?,Error> {
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
    
    func saveResponse(lessons: LessonsModel) {
        for lessonObj in lessons.lessons ?? [] {
            if let result  = self.getLessonBy(id: lessonObj.id ?? 0) {
//               _ = self.updateResponse(lesson: lessonObj)
            } else {
                self.createResponse(lesson: lessonObj)
            }
        }
        
    }
    func getLessonBy(id: Int) -> Lessons? {
        
        guard let result = getCDLesson(byIdentifier: id) else {
            return nil
        }
        return Lessons(id: Int(result.id ?? 0),
                       name: result.name ?? "",
                       description: result.descriptions ?? "",
                       thumbnail: result.thumbnail ?? "",
                       video_url: result.video_url ?? "",
                       saved_video_url: result.saved_video_url ?? "")
         
    }
    
    
    
    func createResponse(lesson: Lessons) {
        let cdLesson = CDLessons(context: CoreDataManager.shared.context)
        cdLesson.id = Int32(lesson.id ?? 0)
        cdLesson.name = lesson.name ?? ""
        cdLesson.thumbnail = lesson.thumbnail ?? ""
        cdLesson.descriptions = lesson.description ?? ""
        cdLesson.video_url = lesson.video_url ?? ""
        
        CoreDataManager.shared.saveContext()
        
    }
    func updateResponse(lesson: Lessons) -> Bool {
        guard let result = getCDLesson(byIdentifier: lesson.id ?? 0) else {
            return false
        }
        result.id = Int32(lesson.id ?? 0)
        result.name = lesson.name ?? ""
        result.descriptions = lesson.description ?? ""
        result.thumbnail = lesson.thumbnail ?? ""
        result.video_url = lesson.video_url ?? ""
        result.saved_video_url = lesson.saved_video_url ?? ""
        
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
