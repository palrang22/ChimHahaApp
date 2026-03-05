//
//  HomeView.swift
//  ChimHahaApp
//
//  Created by 김승희 on 3/3/26.
//

import SwiftUI

import ComposableArchitecture


struct HomeView: View {
    @Bindable var store: StoreOf<HomeReducer>
    
    private let drawerWidth: CGFloat = 300
    
    var body: some View {
        ZStack(alignment: .leading) {
            NavigationStack {
                ZStack {
                    Color.chimBG.ignoresSafeArea()
                    
                    if store.isLoading {
                        ProgressView()
                            .tint(.chimPrimary)
                    } else if let error = store.errorMessage {
                        VStack(spacing: 12) {
                            Text("오류가 발생했어요.")
                                .font(.chimBody)
                                .foregroundStyle(.chimLabel)
                            Text(error)
                                .font(.chimCaption)
                                .foregroundStyle(.chimLabel2)
                                .multilineTextAlignment(.center)
                            Button("다시 시도") {
                                store.send(.onAppear)
                            }
                            .foregroundStyle(.chimPrimary)
                        }
                        .padding()
                    } else {
                        postList
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            store.send(.drawer(.open), animation: .easeInOut(duration: 0.3))
                        } label: {
                            HStack(spacing: 4) {
                                Text("\(store.selectedBoard.emoji) \(store.selectedBoard.name)")
                                    .font(.chimBodySB)
                                    .foregroundStyle(.chimLabel)
                                Image(systemName: "chevron.down")
                                    .font(.chimCaption)
                                    .foregroundStyle(.chimLabel2)
                            }
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            
                        } label: {
                            Image(systemName: "bell")
                                .foregroundStyle(.chimLabel)
                        }
                    }
                }
            }
            .onAppear {
                store.send(.onAppear)
            }
            
            Color.black
                .opacity(store.drawer.isOpen ? 0.5 : 0)
                .ignoresSafeArea()
                .onTapGesture {
                    store.send(.drawer(.close), animation: .easeInOut(duration: 0.3))
                }
                .allowsHitTesting(store.drawer.isOpen)
                .animation(.easeInOut(duration: 0.3), value: store.drawer.isOpen)
            
            BoardDrawerView(store: store.scope(state: \.drawer, action: \.drawer))
                .frame(width: drawerWidth)
                .offset(x: store.drawer.isOpen ? 0 : -drawerWidth)
                .animation(.easeInOut(duration: 0.3), value: store.drawer.isOpen)
        }
    }
    
    private var postList: some View {
        ScrollView {
            if let description = store.selectedBoard.description {
                BoardDescBannerView(text: description)
            }
            
            if store.selectedBoard.viewType == .list {
                filterChips
            }
            
            LazyVStack(spacing: 0) {
                ForEach(store.posts) { post in
                    PostRowView(post: post)
                    Divider()
                        .overlay(.chimSeparator)
                }
            }
        }
    }
    
    private var filterChips: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                ForEach(FeedFilter.allCases, id: \.self) { filter in
                    let isSelected = store.filter == filter
                    Button(filter.rawValue) {
                        store.send(.filterChanged(filter))
                    }
                    .font(.chimCaption)
                    .foregroundStyle(isSelected ? Color.chimPrimary : Color.chimLabel2)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(isSelected ? Color.chimPrimary.opacity(0.15) : Color.chimSurface).clipShape(Capsule())
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .scrollIndicators(.hidden)
    }
}


#Preview {
      HomeView(store: Store(
          initialState: HomeReducer.State()
      ) {
          HomeReducer()
      })
  }
