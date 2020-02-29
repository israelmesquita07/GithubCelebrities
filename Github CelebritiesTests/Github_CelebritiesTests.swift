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

    var sut: GithubCelebritiesViewController?
    var usersCelebrities: UsersCelebrities?
    
    override func setUp() {
        let sboard = UIStoryboard(name: "Main", bundle: nil)
        sut = sboard.instantiateViewController(withIdentifier: "GithubCelebritiesViewController")
                as? GithubCelebritiesViewController
        usersCelebrities = getAPIUserData()
    }
    
    func testItensNotNil() {
        XCTAssertNotNil(usersCelebrities?.items)
    }
    
    func testIdGreaterThanZero() {
        XCTAssertGreaterThan((usersCelebrities!.items![0].id)!, 0)
    }

    func testGetUsers() {
        
        //Arranje
        guard sut != nil else { return }
        sut!.loadView()
        let request = GithubCelebrities.Users.Request()
        
        //ACT
        sut!.interactor?.getUsers(request: request)
        
        //Assert
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.sut!.users.count, 1)
        }
    }
    
    func testToggleViewLoading() {
        guard sut != nil else { return }
        sut!.loadView()
        sut!.toggleLoading(false)
        XCTAssertFalse(sut!.activityIndicator.isHidden)
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
