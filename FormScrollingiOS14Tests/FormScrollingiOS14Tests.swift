//
//  FormScrollingiOS14Tests.swift
//  FormScrollingiOS14Tests
//
//  Created by AT on 10/13/20.
//

import Combine
import XCTest
@testable import FormScrollingiOS14

class FormScrollingiOS14Tests: XCTestCase {
    
    private let subject = PassthroughSubject<DoubleViewBuilder.ViewType, Never>()
    private var tasks = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMainViewControllerOnSave() throws {
        var fulfilled = false
        let subject = PassthroughSubject<DoubleViewBuilder.ViewType, Never>()
        let viewController =
            MainViewController(builder: DoubleViewBuilder.viewTypeSubjecMock(subject: subject))
        
        subject.sink { viewType in
            if viewType == .hello {
                fulfilled = true
            }
        }.store(in: &tasks)
        
        viewController.debugPanel.tapOnSave()

        wait(fulfilled)
    }
    
    func testWaitForCondition() throws {
        var fulfilled = false
        messageAfterDelay(message: "Hello", time: 5.0) { message in
            XCTAssertEqual(message, "Hello")
            fulfilled = true
        }
        
        wait(fulfilled)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    private func messageAfterDelay(message: String, time: Double,
                                   completion: @escaping (String)->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            completion(message)
       }
    }
}
