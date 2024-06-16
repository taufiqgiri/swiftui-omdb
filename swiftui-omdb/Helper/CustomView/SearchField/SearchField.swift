//
//  SearchField.swift
//  swiftui-omdb
//
//  Created by Taufiq Ichwanusofa on 16/06/24.
//

import SwiftUI

struct SearchField: View {
    @Binding var keyword: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.2))

            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                ZStack(alignment: .leading) {
                    if keyword.isEmpty {
                        Text("Search...")
                            .foregroundColor(Color.gray)
                            .padding(5)
                    }
                    TextField("", text: $keyword)
                        .foregroundColor(.white)
                        .padding(5)
                }
            }
            .padding(.horizontal, 10)
        }
    }
}

#Preview {
    SearchField(keyword: .constant(""))
}
