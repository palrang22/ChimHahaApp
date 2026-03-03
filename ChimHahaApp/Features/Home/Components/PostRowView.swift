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
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(post.title)
                    .font(.chimBody)
                    .foregroundStyle(.chimLabel)
                    .lineLimit(2)
                
                HStack(spacing: 6) {
                    Text(post.name)
                        .font(.chimCaption)
                        .foregroundStyle(.chimLabel2)
                    
                    if let likeCount = post.likeCount {
                        Label("\(likeCount)", systemImage: "heart")
                            .font(.chimCaption)
                            .foregroundStyle(.chimLabel2)
                    }
                    
                    if let commentCount = post.commentCount, commentCount > 0 {
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
        .padding(.vertical, 12)
    }
}
