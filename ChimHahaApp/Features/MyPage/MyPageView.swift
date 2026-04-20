//
//  MyPageView.swift
//  ChimHahaApp
//
//  Created by 김승희 on 3/22/26.
//

import SwiftUI

import ComposableArchitecture


struct MyPageView: View {
    @Bindable var store: StoreOf<MyPageReducer>

    var body: some View {
        NavigationStack {
            List {
                profileHeader
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                
                Section {
                    menuRow(title: "스크랩한 글", icon: "bookmark")
                    menuRow(title: "내가 쓴 글", icon: "square.and.pencil")
                    menuRow(title: "내가 쓴 댓글", icon: "bubble.left")
                    menuRow(title: "침하하 한 글", icon: "heart")
                    menuRow(title: "침하하 한 댓글", icon: "heart.bubble")
                }

                Section {
                    menuRow(title: "차단한 사용자", icon: "person.slash")
                    menuRow(title: "푸시 알림 관리", icon: "bell")
                }

                Section {
                    Button {
                        store.send(.logoutTapped)
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundStyle(.red.opacity(0.8))
                                .frame(width: 20)
                            Text("로그아웃")
                                .font(.chimBody)
                                .foregroundStyle(.red)
                            Spacer()
                        }
                        .padding(.vertical, 6)
                    }
                    .listRowBackground(Color.chimSurface)
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color.chimBG)
            .navigationDestination(
                isPresented: Binding(
                    get: { store.isWishingStonePresented },
                    set: { if !$0 { store.send(.wishingStoneDismissed) } }
                ),
            ) {
                WishingStoneView(
                    store: Store(initialState: WishingStoneReducer.State()) {
                        WishingStoneReducer()
                    }
                )
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
        .confirmationDialog(
            "로그아웃 하시겠어요?",
            isPresented: Binding(
                get: { store.isLogoutAlertPresented },
                set: { if !$0 { store.send(.logoutCancelled) } }
            ),
            titleVisibility: .visible
        ) {
            Button("로그아웃", role: .destructive) {
                store.send(.logoutConfirmed)
            }
            Button("취소", role: .cancel) {
                store.send(.logoutCancelled)
            }
        }
    }

    private var profileHeader: some View {
        ZStack(alignment: .bottomLeading) {
            HStack(alignment: .center, spacing: 16) {
                profileAvatar
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(store.user?.name ?? "침바오")
                        .font(.chimBodySB)
                        .foregroundStyle(.chimLabel)
                    
                    HStack(spacing: 8) {
                        pointBadge
                        wishingStoneBadge
                    }
                }
                
                Spacer()
                Button {
                    //TODO: 정보수정으로 이동
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.chimLabel3)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
            .background(Color(.chimPrimary).opacity(0.35))
        }
    }

    private var profileAvatar: some View {
        AsyncImage(url: URL(string: store.user?.imageURL ?? "")) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            default:
                Image(.profile)
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(width: 56, height: 56)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(Color.chimPrimary.opacity(0.4), lineWidth: 2)
        )
    }

    private var pointBadge: some View {
        Text("\(store.user?.point ?? 0) P")
            .font(.chimCaption)
            .foregroundStyle(.chimPrimary)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.chimPrimary.opacity(0.12))
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.chimPrimary.opacity(0.25), lineWidth: 1)
            )
    }

    private var wishingStoneBadge: some View {
        Button {
            store.send(.wishingStoneTapped)
        } label: {
            HStack(spacing: 4) {
                Image(.wishingStoneIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
                Text("소원의 돌")
                    .font(.chimCaption)
                    .foregroundStyle(.chimPrimary)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.chimPrimary.opacity(0.12))
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.chimPrimary.opacity(0.25), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - 메뉴

    private func menuRow(title: String, icon: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .foregroundStyle(.chimLabel2)
                .frame(width: 22, height: 22)
            Text(title)
                .font(.chimBody)
                .foregroundStyle(.chimLabel)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.chimLabel3)
        }
        .padding(.vertical, 6)   // ← row 높이 증가
        .listRowBackground(Color.chimSurface)
    }
}

#Preview {
    MyPageView(store: Store(
        initialState: MyPageReducer.State()
    ) {
        MyPageReducer()
    })
}
