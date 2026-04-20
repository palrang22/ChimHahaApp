//
//  WishingStoneReducerTests.swift
//  ChimHahaApp
//

import XCTest
import ComposableArchitecture
@testable import ChimHahaApp

final class WishingStoneReducerTests: XCTestCase {

    // onAppear → isLoading true, 더미 wishes 로드
    func test_onAppear_loadsDummyWishes() async {
        let store = await TestStore(initialState: WishingStoneReducer.State()) {
            WishingStoneReducer()
        }

        await store.send(.onAppear) {
            $0.isLoading = true
        }
        await store.receive(\.wishesResponse) {
            $0.isLoading = false
            $0.wishes = Wish.dummies
        }
    }

    // inputChanged → inputText 업데이트
    func test_inputChanged_updatesInputText() async {
        let store = await TestStore(initialState: WishingStoneReducer.State()) {
            WishingStoneReducer()
        }

        await store.send(.inputChanged("취업하게 해주세요")) {
            $0.inputText = "취업하게 해주세요"
        }
    }

    // submitWish → 텍스트 있으면 todayPrayed true, inputText 초기화
    func test_submitWish_withText_setsTodayPrayed() async {
        let store = await TestStore(
            initialState: WishingStoneReducer.State(inputText: "건강하게 해주세요")
        ) {
            WishingStoneReducer()
        }

        await store.send(.submitWish) {
            $0.todayPrayed = true
            $0.inputText = ""
        }
    }

    // submitWish → 빈 텍스트면 아무것도 안 함
    func test_submitWish_withEmptyText_doesNothing() async {
        let store = await TestStore(
            initialState: WishingStoneReducer.State(inputText: "")
        ) {
            WishingStoneReducer()
        }

        await store.send(.submitWish)
    }

    // submitWish → 공백만 있으면 아무것도 안 함
    func test_submitWish_withWhitespaceOnly_doesNothing() async {
        let store = await TestStore(
            initialState: WishingStoneReducer.State(inputText: "   ")
        ) {
            WishingStoneReducer()
        }

        await store.send(.submitWish)
    }

    // wishesResponse 실패 → isLoading false, errorMessage 설정
    func test_wishesResponse_failure_setsErrorMessage() async {
        let store = await TestStore(
            initialState: WishingStoneReducer.State(isLoading: true)
        ) {
            WishingStoneReducer()
        }

        await store.send(.wishesResponse(.failure(MockError.failed))) {
            $0.isLoading = false
            $0.errorMessage = MockError.failed.localizedDescription
        }
    }
}

// MARK: - Mocks

private enum MockError: Error {
    case failed
}
