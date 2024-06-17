//
//  MovieViewModel.swift
//  swiftui-omdb
//
//  Created by Taufiq Ichwanusofa on 16/06/24.
//

import Foundation
import RealmSwift

class MovieViewModel: ObservableObject {
    internal let realm = try! Realm()
    private let service: MovieServiceProtocol
    
    init(service: MovieServiceProtocol = MovieService()) {
        self.service = service
    }
    
    @Published var page = 1
    @Published var movies: [MovieModel] = []
    @Published var errorMessage: String?
    @Published var latestKeyword: String = ""
    @Published var isFetchingData = false
    @Published var isEndOfPage = false
    @Published var movieCaches: [MovieCacheModel] = []
    @Published var isLoading = false
    @Published var isShowErrorAlert = false
    
    private func saveMovieCache() {
        if movieCaches.isEmpty {
            var movieList: [MovieCacheModel] = []
            
            movies.enumerated().forEach { index, movie in
                let newMovie = MovieCacheModel()
                newMovie.Title = movie.Title ?? ""
                newMovie.Poster = movie.Poster ?? ""
                newMovie.imdbID = movie.imdbID ?? ""
                newMovie.Year = movie.Year ?? ""
                
                movieList.append(newMovie)
            }
            
            try! realm.write {
                realm.add(movieList)
            }
        }
    }
    
    func getMovieList(keyword: String, isInitialLoad: Bool = false, completion: (() -> Void)? = nil) {
        isFetchingData = true
        if keyword != latestKeyword {
            page = 1
            isEndOfPage = false
        }
        
        errorMessage = nil
        service.getMovieList(keyword: keyword, page: page) { [weak self] result in
            guard let self else { return }
            
            if result.Response == "True" {
                if isInitialLoad {
                    isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.isLoading = false
                        self.isFetchingData = false
                        
                        if self.page == 1 {
                            self.movies = result.Search ?? []
                        } else {
                            self.movies.append(contentsOf: result.Search ?? [])
                        }
                        
                        self.page += 1
                        self.latestKeyword = keyword
                        
                        self.saveMovieCache()
                    }
                } else {
                    self.isFetchingData = false
                    
                    if self.page == 1 {
                        self.movies = result.Search ?? []
                    } else {
                        self.movies.append(contentsOf: result.Search ?? [])
                    }
                    
                    self.page += 1
                    self.latestKeyword = keyword
                    self.saveMovieCache()
                }
            } else {
                isFetchingData = false
                self.errorMessage = result.Error
                if latestKeyword == keyword && result.Error?.lowercased().contains("movie not found") == true {
                    isEndOfPage = true
                } else {
                    isShowErrorAlert = true
                }
                latestKeyword = keyword
            }
        } onFailure: { [weak self] error in
            guard let self else { return }
            isFetchingData = false
            if error.localizedDescription.contains("InternetConnection") == true {
                if movieCaches.isEmpty {
                    self.errorMessage = "Data is not available\nPlease check your Internet Connnection and try again"
                } else {
                    self.errorMessage = "Please check your Internet Connnection"
                }
            } else {
                self.errorMessage = error.localizedDescription
            }
            
            latestKeyword = keyword
            isShowErrorAlert = true
        }
    }
}
