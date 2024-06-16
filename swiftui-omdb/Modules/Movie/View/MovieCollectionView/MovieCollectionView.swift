//
//  MovieCollectionView.swift
//  swiftui-omdb
//
//  Created by Taufiq Ichwanusofa on 16/06/24.
//

import SwiftUI

struct MovieCollectionView: View {
    @ObservedObject var viewModel: MovieViewModel
    
    var body: some View {
        GeometryReader { geometry in
            let itemWidth = (geometry.size.width / 2) - 10
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: itemWidth))], spacing: 20) {
                    ForEach(viewModel.movies) { movie in
                        MovieCard(movie: movie)
                            .frame(width: itemWidth, height: 300)
                    }
                    
                    if !viewModel.isEndOfPage {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .foregroundColor(.black)
                            .foregroundColor(.red)
                            .onAppear {
                                if !viewModel.isFetchingData {
                                    viewModel.getMovieList(keyword: viewModel.latestKeyword)
                                }
                            }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    MovieCollectionView(viewModel: MovieViewModel())
}
