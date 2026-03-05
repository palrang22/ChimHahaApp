//
//  BoardDrawerView.swift
//  ChimHahaApp
//
//  Created by 김승희 on 3/4/26.
//

import SwiftUI

import ComposableArchitecture


struct BoardDrawerView: View {
    @Bindable var store: StoreOf<BoardDrawerReducer>
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                drawerHeader
                
                Divider().overlay(.chimSeparator)
                
                ForEach(Board.shortcuts) { board in
                    shortcutRow(board: board)
                }
                
                Divider().overlay(.chimSeparator)
                
                let favoriteBoards = Board.allBoards.filter { store.favorites.contains($0.id) }
                if !favoriteBoards.isEmpty {
                    sectionLabel(text: "즐겨찾기")
                    ForEach(favoriteBoards) { board in
                        boardRow(board: board, showStar: true)
                    }
                    Divider().overlay(.chimSeparator)
                }
                
                ForEach(Board.Section.allCases, id: \.self) { section in
                    collapsibleSection(section: section)
                }
                
                Divider().overlay(.chimSeparator)
                
                shortcutRow(board: .event)
                shortcutRow(board: .wishStone)
            }
        }
        .scrollIndicators(.hidden)
        .background(Color.chimSurface.ignoresSafeArea())
    }
    
    private var drawerHeader: some View {
        Text("게시판")
            .font(.chimTitle1)
            .foregroundStyle(.chimLabel)
            .padding(.horizontal, 20)
            .padding(.top, 60)
            .padding(.bottom, 16)
    }
    
    private func shortcutRow(board: Board)-> some View {
        Button {
            store.send(.boardSelected(board))
        } label: {
            HStack(spacing: 12) {
                Text(board.emoji)
                    .font(.system(size: 22))
                Text(board.name)
                    .font(.chimBodySB)
                    .foregroundStyle(.chimLabel)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
    
    private func sectionLabel(text: String) -> some View {
        Text(text)
            .font(.chimTitle2)
            .foregroundStyle(.chimLabel)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
    }
    
    private func boardRow(board: Board, showStar: Bool = false) -> some View {
        HStack(spacing: 0) {
            Button {
                store.send(.boardSelected(board))
            } label: {
                HStack(spacing: 12) {
                    Text(board.emoji)
                        .font(.system(size: 22))
                    Text(board.name)
                        .font(.chimBody)
                        .foregroundStyle(.chimLabel)
                    Spacer()
                }
                .padding(.leading, 20)
                .padding(.vertical, 16)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            
            if showStar {
                Button {
                    store.send(.toggleFavorite(board.id))
                } label: {
                    Image(systemName: store.favorites.contains(board.id) ? "star.fill" : "star")
                        .foregroundStyle(store.favorites.contains(board.id) ? Color.chimPrimary : Color.chimLabel3)
                        .font(.system(size: 14))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private func collapsibleSection(section: Board.Section) -> some View {
        let isExpanded = store.expandedSections.contains(section)
        let boards = Board.boards(for: section)
        
        return VStack(alignment: .leading, spacing: 0) {
            Button {
                store.send(.toggleSection(section), animation: .easeInOut)
            } label: {
                HStack {
                    Text(section.displayName)
                        .font(.chimTitle2)
                        .foregroundStyle(.chimLabel)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.chimCaption)
                        .foregroundStyle(.chimLabel2)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                ForEach(boards) { board in
                    boardRow(board: board, showStar: true)
                }
            }
            
            Divider().overlay(.chimSeparator)
        }
    }
}



#Preview {
      BoardDrawerView(store: Store(
          initialState: BoardDrawerReducer.State()
      ) {
          BoardDrawerReducer()
      })
  }
