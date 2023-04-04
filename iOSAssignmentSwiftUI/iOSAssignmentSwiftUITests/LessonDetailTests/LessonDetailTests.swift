//
//  LessonDetailTests.swift
//  iOSAssignmentSwiftUITests
//
//  Created by Hassan dad khan on 04/04/2023.
//

import XCTest
import Combine
@testable import iOSAssignmentSwiftUI

final class LessonDetailTests: XCTestCase {
    var viewModel: LessonDetailViewModel?
    var subscription = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = LessonDetailViewModel(repository: MockLessonDetailRepository())
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testProgressWhenDownloading() {
        var isProgressUpdated = false
        let expectation = expectation(description: "Progress should update")
        let lessonMock = Lessons(id: 950,
                                 name: "The Key To Success In iPhone Photography",
                                 description: "TestingMock",
                                 thumbnail: "",
                                 video_url: "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4",
                                 saved_video_url: "")
        viewModel?.downloadVideoFrom(lesson: lessonMock)
        
        viewModel?.$progress
            .receive(on: RunLoop.main)
            .sink { progress in
                if progress > 0.0 {
                    if !isProgressUpdated {
                        isProgressUpdated = !isProgressUpdated
                        expectation.fulfill()
                    }
                }
            }
            .store(in: &subscription)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetLessonFromId() {
        XCTAssertNotNil(viewModel?.getLessonBy(id: 950))
    }
}
