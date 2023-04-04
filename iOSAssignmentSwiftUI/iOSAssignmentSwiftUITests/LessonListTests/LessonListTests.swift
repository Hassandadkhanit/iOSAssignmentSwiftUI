//
//  LessonListTests.swift
//  iOSAssignmentSwiftUITests
//
//  Created by Hassan dad khan on 04/04/2023.
//

import XCTest
import Combine
@testable import iOSAssignmentSwiftUI


final class LessonListTests: XCTestCase {
    var viewModel: LessonsListViewModel?
    var subscription = Set<AnyCancellable>()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = LessonsListViewModel(repository: MockLessonsListRepository())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetLessonList() {
        viewModel?.getLessonsList()
        
        let expectation =  expectation(description: "getLessonListFromApi")

        viewModel?.$lessons
            .sink(receiveValue: { results in
                expectation.fulfill()
            })
            .store(in: &subscription)
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testGetLessonFromId() {
       XCTAssertNotNil(viewModel?.getLessonFromId(id: 950))
    }


}
