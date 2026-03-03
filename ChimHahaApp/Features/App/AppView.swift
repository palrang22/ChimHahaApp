//
//  AppView.swift
//  ChimHahaApp
//
//  Created by 김승희 on 2/27/26.
//

import SwiftUI

import ComposableArchitecture


struct AppView: View {
    @Bindable var store: StoreOf<AppReducer>
    
    var body: some View {
        TabView(selection: $store.selectedTab.sending(\.tabSelected)) {
            Tab("홈", systemImage: "house", value: AppReducer.Tab.home) {
                HomeView(store: store.scope(state: \.home, action: \.home))
            }
            
            Tab("검색", systemImage: "magnifyingglass", value: AppReducer.Tab.search) {
                Text("검색")
            }
            
            Tab("글쓰기", systemImage: "pencil", value: AppReducer.Tab.write) {
                Text("글쓰기")
            }
            
            Tab("마이페이지", systemImage: "person", value: AppReducer.Tab.myPage) {
                Text("마이페이지")
            }
        }
        .tint(Color.chimPrimary)
    }
}

#Preview {
      AppView(store: Store(initialState: AppReducer.State()) {
          AppReducer()
      })
  }
