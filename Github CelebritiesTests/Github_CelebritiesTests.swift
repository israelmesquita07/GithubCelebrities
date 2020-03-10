//
//  Github_CelebritiesTests.swift
//  Github CelebritiesTests
//
//  Created by Israel on 18/02/20.
//  Copyright © 2020 israel3D. All rights reserved.
//

import XCTest
@testable import Github_Celebrities

class Github_CelebritiesTests: XCTestCase {

    var sut: Github_Celebrities.GithubCelebritiesViewController!
    var usersCelebrities: UsersCelebrities!
    
    override func setUp() {
        usersCelebrities = getAPIUserData()
    }
    
    func testItensNotNil() {
        //Assert
        XCTAssertNotNil(usersCelebrities?.items)
    }
    
    func testIdGreaterThanZero() {
        //Assert
        XCTAssertGreaterThan((usersCelebrities!.items![0].id)!, 0)
    }

    func testGetUsers() {
        
        //Arranje
        let request = Github_Celebrities.GithubCelebrities.Users.Request()
        
        //ACT
        let expectation = XCTestExpectation(description: "retornoAPI")
        Github_Celebrities.API.getUsers(request) { (result) in
            switch result {
            case .success(let usersCelebrities):
                //Assert
                let arrUsers = [usersCelebrities]
                XCTAssertEqual(arrUsers.count, 1)
                break
            case .failure(let error):
                XCTFail(error.localizedDescription)
                break
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testToggleViewLoading() {
        
        //Arranje
        let sboard = UIStoryboard(name: "Main", bundle: nil)
        sut = (sboard.instantiateViewController(withIdentifier: "GithubCelebritiesViewController")
            as! Github_Celebrities.GithubCelebritiesViewController)
        sut!.loadView()
        
        //ACT
        sut!.toggleLoading(false)
        
        //Assert
        XCTAssertTrue(sut!.activityIndicator.isHidden)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    private func getAPIUserData() -> UsersCelebrities? {
        if let path = Bundle.main.path(forResource: "UsersCelebrities", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let result = try? decoder.decode(UsersCelebrities.self, from: data) {
                    return result
                }
            } catch let error {
                print("Test Error: \(error)")
                return nil
            }
        }
        return nil
    }
}
