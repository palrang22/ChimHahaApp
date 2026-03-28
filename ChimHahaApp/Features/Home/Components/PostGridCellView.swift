//
//  PostGridCellView.swift
//  ChimHahaApp
//
//  Created by 김승희 on 3/21/26.
//

import SwiftUI


struct PostGridCellView: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Color.clear
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    AsyncImage(url: post.imageURL) { phase in
                        switch phase {
                        case .empty:
                            Color(.chimSurface2)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        case .failure:
                            Color(.chimSurface2)
                                .overlay {
                                    Image(systemName: "photo")
                                        .foregroundStyle(Color(.chimLabel3))
                                }
                        @unknown default:
                            Color(.chimSurface2)
                        }
                    }
                }
            .aspectRatio(1, contentMode: .fit)
            .clipped()
            .cornerRadius(4)
            
            Text(post.title)
                .font(.caption)
                .foregroundStyle(Color(.chimLabel))
                .lineLimit(2)
            
            HStack(spacing: 6) {
                if let likes = post.likeCount {
                    Label("\(likes)", systemImage: "heart.fill")
                        .font(.caption2)
                        .foregroundStyle(.chimLabel2)
                }
                Spacer()
                if let date = post.createdAt {
                    Text(date.relativeFormatted)
                        .font(.caption2)
                        .foregroundStyle(.chimLabel2)
                }
            }
        }
    }
}


#Preview {
    let mockPost = Post(
        id: "1",
        userId: "1",
        name: "오공삼무선생",
        title: "침덩이 레전드",
        body: "본문 내용",
        imageURL: URL(string: "https://picsum.photos/200"),
        tags: nil,
        viewCount: 100,
        likeCount: 42,
        dislikeCount: nil,
        commentCount: 9,
        scrapCount: nil,
        createdAt: Date()
    )

    PostGridCellView(post: mockPost)
        .frame(width: 120)
        .padding()
        .background(Color(.chimBG))
}
