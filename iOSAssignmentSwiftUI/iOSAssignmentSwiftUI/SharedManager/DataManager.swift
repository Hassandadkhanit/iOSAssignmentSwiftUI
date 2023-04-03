//
//  DataManager.swift
//  iOS Assignment
//
//  Created by Hassan dad khan on 31/03/2023.
//

import Foundation

class DataManager {
   static var shared = DataManager()
    private init(){}
    
    var lessons = LessonsModel()

}
