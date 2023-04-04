//
//  Utilities.swift
//  iOSAssignmentSwiftUI
//
//  Created by Hassan dad khan on 04/04/2023.
//

import Foundation
import UIKit

enum FileType: String {
    case mp4
    case mp3
    case jpeg
}

class Utilities {
     class var documentsUrl: URL {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        } catch {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        }
    }
    static func save(url: URL,fileName: String,fileType: FileType) -> String? {
        let destinationURL = documentsUrl.appendingPathComponent(fileName + "." + fileType.rawValue)
        if FileManager().fileExists(atPath: destinationURL.path) {
            print("The file already exists at path")
            
            } else {
                
                let data = NSData(contentsOf: url)
                if data!.write(to: destinationURL, atomically: true)  {
                    print("saved")
                    return destinationURL.path
                } else {
                    print("error saving file")
                }

            }
        return ""
    }
}
