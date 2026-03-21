//
//  PostDetailView.swift
//  ChimHahaApp
//
//  Created by 김승희 on 3/19/26.
//

import SwiftUI

import ComposableArchitecture


struct PostDetailView: View {
    @Bindable var store: StoreOf<PostDetailReducer>
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                
                // MARK: - Post Header
                VStack(alignment: .leading, spacing: 12) {
                    Text(store.post.title)
                        .font(.chimTitle1)
                        .foregroundStyle(.chimLabel)
                    
                    HStack(spacing: 10) {
                        Circle()
                            .fill(Color.chimSurface2)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(.profile)
                                    .resizable()
                                    .scaledToFit()
                            )
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(store.post.name)
                                .font(.chimBodySB)
                                .foregroundStyle(.chimLabel)
                            
                            HStack(spacing: 4) {
                                if let likeCount = store.post.likeCount {
                                    Label("\(likeCount)", systemImage: "hand.thumbsup")
                                        .font(.chimCaption)
                                        .foregroundStyle(.chimLabel)
                                }
                                
                                if let createdAt = store.post.createdAt {
                                    Text("·")
                                        .foregroundStyle(.chimLabel2)
                                    Text(createdAt.relativeFormatted)
                                        .font(.chimCaption)
                                        .foregroundStyle(.chimLabel2)
                                }
                                
                                if let viewCount = store.post.viewCount {
                                    Text("·")
                                        .foregroundStyle(.chimLabel2)
                                    Text("조회 \(viewCount)")
                                        .font(.chimCaption)
                                        .foregroundStyle(.chimLabel2)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            // TODO: more options
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundStyle(.chimLabel2)
                                .padding(8)
                        }
                    }
                }
                .padding()
                
                Divider()
                    .background(.chimSeparator)
                
                // MARK: - Post Body
                Text(store.post.body)
                    .font(.chimBody)
                    .foregroundStyle(.chimLabel)
                    .padding()
                    .lineSpacing(2)
                    .tracking(0.2)
                
                // MARK: - Post Image
                if let imageURL = store.post.imageURL {
                    AsyncImage(url: imageURL) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        Color.chimSurface2.frame(height: 200)
                    }
                    .padding(.horizontal)
                }
                
                Divider()
                    .background(.chimSeparator)
                    .padding(.top)
                
                // MARK: - Reaction Buttons
                HStack(spacing: 32) {
                    Spacer()
                    reactionButton(emoji: "👍", label: "침하하")
                    reactionButton(emoji: "👎", label: "침흑흑")
                    Spacer()
                }
                .padding(.vertical, 32)
                
                // MARK: - Scrap Button
                Button {
                    // TODO: scrap action
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "bookmark.fill")
                        Text("스크랩 추가")
                            .font(.chimBody)
                    }
                    .foregroundStyle(.chimLabel)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 12)
                    .background(Color.chimSurface)
                    .clipShape(Capsule())
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 32)
                
                Divider()
                    .background(.chimSeparator)
                
                // MARK: - Post Navigation
                HStack(spacing: 8) {
                    postNavButton(title: "← 이전글")
                    postNavButton(title: "≡ 목록")
                    postNavButton(title: "다음글 →")
                }
                .padding()
                
                Divider()
                    .background(.chimSeparator)
                
                // MARK: - Comments
                if store.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    ForEach(store.comments) { comment in
                        // TODO: CommentRowView
                        Divider()
                            .background(.chimSeparator)
                    }
                }
            }
        }
        .background(.chimBG)
        .navigationBarTitleDisplayMode(.inline).toolbar(.hidden, for: .tabBar)
        .safeAreaInset(edge: .bottom) {
            // MARK: - Comment Input Bar
            HStack(spacing: 12) {
                // Avatar
                Circle()
                    .fill(Color.chimSurface2)
                    .frame(width: 32, height: 32)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(.chimLabel3)
                    )
                
                TextField("댓글을 입력하세요", text: $store.commentInput)
                    .padding(10)
                    .background(.chimSurface2)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .foregroundStyle(.chimLabel)
                
                Button {
                    store.send(.submitComment)
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(.chimPrimary)
                }
                .disabled(store.commentInput.isEmpty)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.chimSurface.ignoresSafeArea(edges: .bottom))
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
    
    private func reactionButton(emoji: String, label: String) -> some View {
        Button {
            store.send(.likeTapped)
        } label: {
            VStack(spacing: 8) {
                Text(emoji)
                    .font(.system(size: 30))
                Text(label)
                    .font(.chimCaption)
                    .foregroundStyle(.chimLabel)
                    .bold()
            }
            .frame(width: 80, height: 80)
            .background(Color.chimSurface)
            .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
    
    private func postNavButton(title: String) -> some View {
        Button {
            // TODO: navigation action
        } label: {
            Text(title)
                .font(.chimBody)
                .foregroundStyle(.chimLabel2)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.chimSurface)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

#if DEBUG
  private struct PreviewCommentRepository: CommentRepository {
      func fetchComments(postId: String) async throws ->
  [Comment] {
          return []
      }
  }
  #endif

#Preview {
     PostDetailView(
         store: Store(
             initialState: PostDetailReducer.State(
                 post: Post(
                     id: "1",
                     userId: "1",
                     name: "침투부원",
                     title: "오늘 침착맨 방송",
                     body: "오늘 방송에서 오늘 방송에서 오늘 방송에서 오늘 방송에서 오늘 방송에서 오늘 방송에서 오늘 방송에서 오늘 방송에서 오늘 방송에서 오늘 방송에서 오늘 방송에서 오늘 방송에서 오늘 방송에서 오늘 방송에서 오늘 방송에서 오늘 방송에서 오늘 방송에서 오늘 방송에서 오늘 방송에서 오늘 방송에서 오늘 방송에서 오늘 방송에서 오늘 방송에서 오늘 방송에서 오늘 방송에서 오늘 방송에서 오늘 방송에서 오늘 방송에서 오늘 방송에서 오늘 방송에서 오늘 방송에서 오늘 방송에서 오늘 방송에서 오늘 방송에서 오늘 방송에서 오늘 방송에서 오늘 방송에서 오늘 방송에서 ",
                     imageURL: URL(string: "https://picsum.photos/600/400"),
                     tags: ["침착맨"],
                     viewCount: 1234,
                     likeCount: 36,
                     dislikeCount: nil,
                     commentCount: 9,
                     scrapCount: nil,
                     createdAt: Calendar.current.date(byAdding: .hour, value: -3, to: Date())
                 )
             )
         ) {
             PostDetailReducer()
         } withDependencies: {
             $0.commentRepository = PreviewCommentRepository()
         }
     )
     .preferredColorScheme(.dark)
 }
