//
//  PostRowView.swift
//  ChimHahaApp
//
//  Created by 김승희 on 3/3/26.
//

import SwiftUI


struct PostRowView: View {
    let post: Post
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(post.title)
                    .font(.chimBody)
                    .foregroundStyle(.chimLabel)
                    .lineLimit(2)
                
                HStack(spacing: 12) {
                    Text(post.name)
                        .font(.chimCaption)
                        .foregroundStyle(.chimLabel2)
                    
                    if let likeCount = post.likeCount {
                        Label("\(likeCount)", systemImage: "hand.thumbsup")
                            .font(.chimCaption)
                            .foregroundStyle(.chimLabel)
                    }
                    
                    if let commentCount = post.commentCount {
                        Label("\(commentCount)", systemImage: "bubble.right")
                            .font(.chimCaption)
                            .foregroundStyle(.chimPrimary)
                            .fontWeight(.bold)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if let imageURL = post.imageURL {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.chimSurface2
                }
                .frame(width: 72, height: 72)
                .clipped()
                .cornerRadius(8)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, post.imageURL == nil ? 20 : 10)
    }
}

#Preview {
    VStack(spacing: 0) {
        // 썸네일 있는 경우
        PostRowView(post: Post(
            id: "1",
            userId: "1",
            name: "Terry Medhurst",
            title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
            body: "quia et suscipit suscipit recusandae consequuntur expedita",
            imageURL: URL(string: "https://picsum.photos/seed/1/400/300"),
            tags: ["침착맨"],
            viewCount: 305,
            likeCount: 192,
            dislikeCount: 25,
            commentCount: 9,
            scrapCount: nil,
            createdAt: Calendar.current.date(byAdding: .hour, value: -3, to: Date())
        ))
        Divider()
        // 썸네일 없는 경우
        PostRowView(post: Post(
            id: "3",
            userId: "3",
            name: "김철수",
            title: "썸네일 없는 게시글 제목입니다",
            body: "본문 내용",
            imageURL: nil,
            tags: nil,
            viewCount: nil,
            likeCount: 36,
            dislikeCount: nil,
            commentCount: 10,
            scrapCount: nil,
            createdAt: Calendar.current.date(byAdding: .minute, value: -5, to: Date())
        ))
        Divider()
        // 썸네일 없는 2줄
        PostRowView(post: Post(
            id: "3",
            userId: "3",
            name: "김철수",
            title: "썸네일 없는 게시글 제목입니다 2줄짜리 우헤헤 썸네일 없는 게시글 제목입니다 2줄짜리 우헤헤 썸네일 없는 게시글 제목입니다 2줄짜리 우헤헤 썸네일 없는 게시글 제목입니다 2줄짜리 우헤헤",
            body: "본문 내용",
            imageURL: nil,
            tags: nil,
            viewCount: nil,
            likeCount: 0,
            dislikeCount: nil,
            commentCount: 0,
            scrapCount: nil,
            createdAt: Calendar.current.date(byAdding: .day, value: -10, to: Date())
        ))
    }
    .background(Color("chimBG"))
}
