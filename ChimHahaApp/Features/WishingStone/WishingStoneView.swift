//
//  WishingStoneView.swift
//  ChimHahaApp
//
//  Created by 김승희 on 3/28/26.
//

import SwiftUI

import ComposableArchitecture


struct WishingStoneView: View {
    @Bindable var store: StoreOf<WishingStoneReducer>
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                StoneView()
                StatsCardView()
                PrayerInputSection(store: store)
                WaveDivider()
                WishListSection(wishes: store.wishes)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 24)
        }
        .background(Color(.chimBG))
        .navigationTitle("소원의 돌")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { store.send(.onAppear) }
    }
}

private struct StoneView: View {
    var body: some View {
        ZStack{
            Image(.wishingStone)
                .resizable()
                .scaledToFill()
                .frame(width: 220, height: 220)
                .clipShape(Circle())
        }
    }
}

private struct StatsCardView: View {
    var body: some View {
        HStack(spacing: 0) {
            StatItemView(title: "기도일", value: "2026-03-29")
            Divider().background(.white)
            StatItemView(title: "개근점수", value: "없음")
            Divider().background(.white)
            StatItemView(title: "기도점수", value: "5")
        }
        .padding(.vertical, 16)
        .background(.chimSurface)
        .cornerRadius(12)
    }
}

private struct StatItemView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.chimLabel2)
            Text(value)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(.chimLabel)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct PrayerInputSection: View {
    @Bindable var store: StoreOf<WishingStoneReducer>
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 12) {
                TextField("기도 올리기",
                          text: $store.inputText.sending(\.inputChanged))
                .foregroundStyle(store.todayPrayed ? .chimLabel3 : .chimLabel)
                .padding(.horizontal, 10)
                .padding(.vertical, 14)
                .background(.chimSurface)
                .cornerRadius(10)
                .focused($isFocused)
                .disabled(store.todayPrayed)
                .onChange(of: store.todayPrayed) {
                    if store.todayPrayed { isFocused = false }
                }
                
                Button {
                    store.send(.submitWish)
                } label: {
                    HStack(spacing: 6) {
                        Image(.iconBtnInsense)
                            .resizable()
                            .frame(width: 20, height: 20)
                        if store.todayPrayed {
                            Text("오늘 기도 완료!")
                        } else {
                            Text("기도 올리기")
                        }
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.chimLabel)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 14)
                    .background(.white.opacity(0.15))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.chimPrimary, lineWidth: 1.5)
                    )
                }
                .disabled(store.todayPrayed)
            }
        }
    }
}

private struct WaveDivider: View {
    var body: some View {
        Canvas { context, size in
            let midY = size.height / 2
            let waveHeight: CGFloat = 5
            let waveLength: CGFloat = 30
            let half = waveLength / 2
            
            var path = Path()
            path.move(to: CGPoint(x: 0, y: midY))
            
            var x: CGFloat = 0
            while x <= size.width {
                path.addCurve(
                    to: CGPoint(x: x + half, y: midY),
                    control1: CGPoint(x: x + half * 0.25, y: midY - waveHeight),
                    control2: CGPoint(x: x + half * 0.75, y: midY - waveHeight)
                )
                path.addCurve(
                    to: CGPoint(x: x + waveLength, y: midY),
                    control1: CGPoint(x: x + half + half * 0.25, y: midY + waveHeight),
                    control2: CGPoint(x: x + half + half * 0.75, y: midY + waveHeight)
                )
                x += waveLength
            }
            
            context.stroke(path, with: .color(.chimPrimary), lineWidth: 1)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 20)
        .padding(.horizontal, -20)
    }
}

private struct WishListSection: View {
    let wishes: [Wish]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("기도 목록")
                .font(.headline)
                .foregroundStyle(.chimLabel2)
            
            ForEach(wishes) { wish in
                WishRowView(wish: wish)
            }
            
            Button {
                //TODO: 더 보기 페이지네이션
            } label: {
                Text("더 보기")
                    .font(.subheadline)
                    .foregroundStyle(.chimLabel2)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
            
        }
    }
}

private struct WishRowView: View {
    let wish: Wish
    
    var body: some View {
        HStack() {
            ZStack {
                Image(.prayNote)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                
                Text("\(wish.rank) 등")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(Color("chimPrimary"))
                    .padding(.horizontal, 4)
                    .padding(.vertical, 4)
                    .background(.chimBG)
                    .cornerRadius(3)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(wish.username)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.chimLabel)
                    Text("\(wish.streakDays)일째, 총 \(wish.days)일")
                        .font(.caption)
                        .foregroundStyle(.chimLabel2)
                        .lineLimit(2)
                }
                
                Text(wish.body)
                    .font(.chimBody)
                    .foregroundStyle(.chimLabel2)
                    .lineLimit(2)
            }
            .padding(.horizontal,16)
            .padding(.vertical, 12)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 10)
        .padding(.vertical, 12)
        .background(.chimSurface)
        .cornerRadius(10)
    }
}


#Preview {
    NavigationStack {
        WishingStoneView(
            store: Store(initialState: WishingStoneReducer.State()) {
                WishingStoneReducer()
            }
        )
    }
}
