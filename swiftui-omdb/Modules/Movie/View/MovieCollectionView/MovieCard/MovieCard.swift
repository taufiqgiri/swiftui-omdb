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
            let imageHeight = geometry.size.height - 50
            let imageWidth = geometry.size.width
            
            VStack {
                KFImage(URL(string: movie.Poster ?? ""))
                    .placeholder {
                        Image(systemName: "movieclapper.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: imageWidth, height: imageHeight)
                            .foregroundColor(.gray)
                    }
                    .cancelOnDisappear(true)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: imageWidth, height: imageHeight)
                    .clipped()
                    .cornerRadius(10)
                Spacer()
                VStack {
                    Text("\(movie.Title ?? "")")
                        .foregroundStyle(Color.white)
                    Text("(\(movie.Year ?? ""))")
                        .foregroundStyle(Color.white)
                }
            }
        }
    }
}

#Preview {
    MovieCard(movie: MovieModel())
}
