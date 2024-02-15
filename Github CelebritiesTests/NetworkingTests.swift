//
//  NetworkingTests.swift
//  Github CelebritiesTests
//
//  Created by israel.mesquita on 14/02/24.
//  Copyright © 2024 israel3D. All rights reserved.
//

import XCTest
@testable import Github_Celebrities

final class NetworkingTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSuccessNetworking() throws {
        let mockURLSession = MockURLSession()
        mockURLSession.data = getAPIUserData()
        let networking = NetworkingAPI(urlString: Endpoints.urlPage, session: mockURLSession)
        networking.fetchData(.init(page: 1)) { (result: Result<UsersCelebrities, NetworkingError>) in
            if case .success(let success) = result {
                XCTAssertNotNil(success)
            } else {
                XCTFail("the test should return an error")
            }
        }
    }

    func testParseErrorNetworking() throws {
        let mockURLSession = MockURLSession()
        mockURLSession.data = Data([0x68])
        let networking = NetworkingAPI(urlString: Endpoints.urlPage, session: mockURLSession)
        networking.fetchData(.init(page: 1)) { (result: Result<UsersCelebrities, NetworkingError>) in
            if case .failure(let failure) = result {
                XCTAssertNotNil(failure)
                XCTAssertEqual(failure, .parseData)
            } else {
                XCTFail("this test should return success")
            }
        }
    }
    
    func testNoDataErrorNetworking() throws {
        let mockURLSession = MockURLSession()
        let networking = NetworkingAPI(urlString: Endpoints.urlPage, session: mockURLSession)
        networking.fetchData(.init(page: 1)) { (result: Result<UsersCelebrities, NetworkingError>) in
            if case .failure(let failure) = result {
                XCTAssertNotNil(failure)
                XCTAssertEqual(failure, .noData)
            } else {
                XCTFail("this test should return success")
            }
        }
    }
    
    func testNetworkingSuccessAsync() {
        let expectation = XCTestExpectation(description: "expectation")
        NetworkingAPI(urlString: Endpoints.urlPage).fetchData(.init(page: 1)) { (result: Result<UsersCelebrities, NetworkingError>) in
            switch result {
            case .success(let success):
                XCTAssertNotNil(success)
            case .failure(let failure):
                XCTFail("this test should return success")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testNetworkingInvalidURLFailureAsync() {
        let expectation = XCTestExpectation(description: "expectation")
        NetworkingAPI(urlString: "ixra4737826fgh324325ˆ%ˆ&#%@&ˆ#%@").fetchData(.init(page: -1)) { (result: Result<UsersCelebrities, NetworkingError>) in
            switch result {
            case .success(let success):
                XCTFail("this test should return an error")
            case .failure(let failure):
                XCTAssertNotNil(failure)
                XCTAssertEqual(failure, .invalidURL)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
}

class MockURLSession: URLSession {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        MockURLSessionDataTask {
            completionHandler(self.data, self.response, self.error)
        }
    }
}

class MockURLSessionDataTask: URLSessionDataTask {
    let closure: () -> Void
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    override func resume() {
        closure()
    }
}

private func getAPIUserData() -> Data? {
    if let path = Bundle.main.path(forResource: "UsersCelebrities", ofType: "json") {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped) else {
            return nil
        }
        return data
    }
    return nil
}
