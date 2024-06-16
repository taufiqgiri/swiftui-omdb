//
//  MovieCard.swift
//  swiftui-omdb
//
//  Created by Taufiq Ichwanusofa on 16/06/24.
//

import SwiftUI
import Kingfisher

struct MovieCard: View {
    @State var movie: MovieModel
    
    var body: some View {
        GeometryReader { geometry in
            let imageHeight = geometry.size.height - 30
            let imageWidth = geometry.size.width
            
            VStack {
                KFImage(URL(string: movie.Poster ?? ""))
                    .cancelOnDisappear(true)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: imageWidth, height: imageHeight)
                    .clipped()
                    .cornerRadius(10)
                Spacer()
                Text(movie.Title ?? "")
                    .foregroundStyle(Color.white)
            }
        }
    }
}

#Preview {
    MovieCard(movie: MovieModel())
}