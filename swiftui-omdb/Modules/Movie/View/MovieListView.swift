//
//  MovieListView.swift
//  swiftui-omdb
//
//  Created by Taufiq Ichwanusofa on 16/06/24.
//

import SwiftUI
import RealmSwift

struct MovieListView: View {
    @ObservedObject var viewModel: MovieViewModel = MovieViewModel()
    @State var keyword: String = ""
    @State var typingTimer: Timer?
    
    internal let realm = try! Realm()
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                Text("Welcome 👋")
                    .modifier(TextModifier.Regular_17())
                    .foregroundStyle(Color.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 1)
                
                Text("Let's relax and watch a movie!")
                    .modifier(TextModifier.SemiBold_20())
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                SearchField(keyword: $keyword)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .padding(.bottom, 5)
                
                MovieCollectionView(viewModel: viewModel)
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
            
            if viewModel.isLoading {
                LoadingView(isAnimating: $viewModel.isLoading)
                    .frame(width: 100, height: 100)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
            }
        }
        .onAppear {
            loadMovieCache()
            viewModel.getMovieList(keyword: "movie", isInitialLoad: true)
        }
        .onChange(of: keyword) { newValue in
            if newValue.count >= 3 {
                startTimer()
            }
        }
        .alert(isPresented: $viewModel.isShowErrorAlert) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? ""),
                dismissButton: .default(Text("Retry")) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        viewModel.getMovieList(keyword: viewModel.latestKeyword)
                    }
                }
            )
        }
    }
    
    private func startTimer() {
        typingTimer?.invalidate()
        typingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            userStoppedTyping()
        }
    }
    
    private func userStoppedTyping() {
        viewModel.getMovieList(keyword: keyword)
    }
    
    private func loadMovieCache() {
        var newMovies: [MovieModel] = []
        let movies = realm.objects(MovieCacheModel.self)
        
        movies.forEach {
            viewModel.movieCaches.append($0)
            
            var movie = MovieModel(dict: [:])
            movie?.Title = $0.Title
            movie?.Poster = $0.Poster
            movie?.imdbID = $0.imdbID
            movie?.Year = $0.Year
            
            newMovies.append(movie!)
        }
        
        viewModel.movies = newMovies
    }
}

#Preview {
    MovieListView()
}
