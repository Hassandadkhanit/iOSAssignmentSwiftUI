//
//  Lessons.swift
//  iOS Assignment
//
//  Created by Hassan dad khan on 31/03/2023.
//

import Foundation

struct LessonsModel : Codable {
    var lessons : [Lessons]?

    enum CodingKeys: String, CodingKey {

        case lessons = "lessons"
    }
    init(lessons: [Lessons] = []) {
        self.lessons = lessons
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lessons = try values.decodeIfPresent([Lessons].self, forKey: .lessons)
    }

}
struct Lessons : Codable {
    let id : Int?
    let name : String?
    let description : String?
    let thumbnail : String?
    let video_url : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case description = "description"
        case thumbnail = "thumbnail"
        case video_url = "video_url"
    }

    init(id: Int,name: String,description: String,thumbnail: String,video_url: String ) {
        self.id = id
        self.name = name
        self.description = description
        self.thumbnail = thumbnail
        self.video_url = video_url
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        thumbnail = try values.decodeIfPresent(String.self, forKey: .thumbnail)
        video_url = try values.decodeIfPresent(String.self, forKey: .video_url)
    }

}
