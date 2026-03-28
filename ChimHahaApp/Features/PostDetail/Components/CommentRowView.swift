//
//  CommentRowView.swift
//  ChimHahaApp
//
//  Created by 김승희 on 3/21/26.
//

import SwiftUI


struct CommentRowView: View {
    let comment: Comment
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            // Avatar
            Circle()
                .fill(Color.chimSurface2)
                .frame(width: 36, height: 36)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(.chimLabel3)
                )
            
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Text(comment.name)
                        .font(.chimBodySB)
                        .foregroundStyle(.chimLabel)
                    
                    if let createdAt = comment.createdAt {
                        Text(createdAt.relativeFormatted)
                            .font(.chimCaption)
                            .foregroundStyle(.chimLabel3)
                    }
                }
                
                Text(comment.body)
                    .font(.chimBody)
                    .foregroundStyle(.chimLabel)
                    .fixedSize(horizontal: false, vertical: true)
                
                HStack(spacing: 16) {
                    Button {
                        // TODO: like comment
                    } label: {
                        Label("침하하 \(comment.likeCount ?? 0)", systemImage: "heart")
                            .font(.chimCaption)
                            .foregroundStyle(.chimLabel3)
                    }
                    
                    Button {
                        // TODO: reply
                    } label: {
                        Text("답글")
                            .font(.chimCaption)
                            .foregroundStyle(.chimLabel3)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
    }
}


#Preview {
      VStack(spacing: 0) {
          CommentRowView(comment: Comment(
              id: "1",
              parentId: nil,
              postId: "1",
              userId: "1",
              name: "치마하하",
              body: "ㅋㅋㅋㅋ 진짜요?? 대박",
              likeCount: 12,
              createdAt: Calendar.current.date(byAdding: .hour, value: -1, to: Date())
          ))
          Divider()
              .background(Color("chimSeparator"))
          CommentRowView(comment: Comment(
              id: "2",
              parentId: nil,
              postId: "1",
              userId: "2",
              name: "옷월량",
              body: "오존님 주식부자 됐네요",
              likeCount: 8,
              createdAt: Calendar.current.date(byAdding: .hour, value: -1, to: Date())
          ))
          Divider()
              .background(Color("chimSeparator"))
          CommentRowView(comment: Comment(
              id: "3",
              parentId: nil,
              postId: "1",
              userId: "3",
              name: "라노llano",
              body: "침착맨 반응 너무 웃겼음 ㅋㅋㅋ",
              likeCount: 0,
              createdAt: Calendar.current.date(byAdding: .hour, value: -2, to: Date())
          ))
      }
      .background(Color("chimBG"))
      .preferredColorScheme(.dark)
  }
