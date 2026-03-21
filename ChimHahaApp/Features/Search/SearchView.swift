//
//  SearchView.swift
//  ChimHahaApp
//
//  Created by 김승희 on 3/22/26.
//

import SwiftUI

import ComposableArchitecture


struct SearchView: View {
    @Bindable var store: StoreOf<SearchReducer>
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.chimLabel2)
                
                TextField("검색어를 입력하세요", text: Binding (
                    get: { store.query },
                    set: { store.send(.queryChanged($0)) }
                ))
                .foregroundStyle(.chimLabel)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                
                if !store.query.isEmpty {
                    Button {
                        store.send(.queryChanged(""))
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.chimLabel3)
                    }
                }
            }
            // 검색창 내부 여백
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color.chimSurface2)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            //검색창 가장자리 여백
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            Divider().overlay(.chimSeparator)
            
            if store.isSearching {
                Spacer()
                ProgressView().tint(.chimPrimary)
                Spacer()
            } else if store.query.isEmpty {
                Spacer()
                Text("검색어를 입력해주세요.")
                    .font(.chimBody)
                    .foregroundStyle(.chimLabel2)
                Spacer()
            } else if store.results.isEmpty {
                Spacer()
                Text("검색 결과가 없습니다.")
                    .font(.chimBody)
                    .foregroundStyle(.chimLabel2)
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(store.results) { post in
                            PostRowView(post: post)
                            Divider().overlay(.chimSeparator)
                        }
                    }
                }
            }
        }
        .background(Color.chimBG.ignoresSafeArea())
        .navigationTitle("검색")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    SearchView(store: Store(
        initialState: SearchReducer.State()
    ) {
        SearchReducer()
    })
}
