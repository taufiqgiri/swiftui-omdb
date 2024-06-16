//
//  MovieViewModelTests.swift
//  swiftui-omdbTests
//
//  Created by Taufiq Ichwanusofa on 17/06/24.
//

import XCTest
@testable import swiftui_omdb

class MovieViewModelTests: XCTestCase {
    var service: MovieService = MovieService()
    
    func testFetchMovieListFromAPI() {
        let expectation = XCTestExpectation(description: "Data fetched successfully")
        var responseData: [MovieModel]?
        
        service.getMovieList(keyword: "movie", page: 1) { [weak self] result in
            guard let self else { return }
            
            if result.Response == "True" {
                responseData = result.Search
                expectation.fulfill()
            }
        } onFailure: { [weak self] error in
            guard let self else { return }
            
        }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(responseData, "Response data should not be nil")
    }
}
