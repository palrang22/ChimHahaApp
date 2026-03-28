import XCTest
import ComposableArchitecture
@testable import ChimHahaApp

final class MyPageReducerTests: XCTestCase {

    let mockUser = User(
        id: "1",
        name: "침투부원",
        email: "test@chimhaha.net",
        imageURL: nil,
        point: 1200
    )

    // onAppear → 유저 fetch 성공 시 user에 저장
    func test_onAppear_success_storesUser() async {
        let store = await TestStore(initialState: MyPageReducer.State()) {
            MyPageReducer()
        } withDependencies: {
            $0.userRepository = MockUserRepository(user: mockUser)
        }

        await store.send(.onAppear) {
            $0.isLoading = true
        }
        await store.receive(\.userResponse) {
            $0.isLoading = false
            $0.user = self.mockUser
        }
    }

    // onAppear → 이미 user가 있으면 fetch 스킵
    func test_onAppear_skipsIfAlreadyLoaded() async {
        let store = await TestStore(
            initialState: MyPageReducer.State(user: mockUser)
        ) {
            MyPageReducer()
        } withDependencies: {
            $0.userRepository = MockUserRepository(user: mockUser)
        }

        await store.send(.onAppear)
    }

    // onAppear → fetch 실패 시 isLoading false로 복구
    func test_onAppear_failure_resetsIsLoading() async {
        let store = await TestStore(initialState: MyPageReducer.State()) {
            MyPageReducer()
        } withDependencies: {
            $0.userRepository = MockUserRepository(shouldFail: true)
        }

        await store.send(.onAppear) {
            $0.isLoading = true
        }
        await store.receive(\.userResponse) {
            $0.isLoading = false
        }
    }

    // logoutTapped → 로그아웃 확인 다이얼로그 표시
    func test_logoutTapped_presentsDialog() async {
        let store = await TestStore(initialState: MyPageReducer.State()) {
            MyPageReducer()
        }

        await store.send(.logoutTapped) {
            $0.isLogoutAlertPresented = true
        }
    }

    // logoutConfirmed → user nil, 다이얼로그 닫힘
    func test_logoutConfirmed_clearsUser() async {
        let store = await TestStore(
            initialState: MyPageReducer.State(
                user: mockUser,
                isLogoutAlertPresented: true
            )
        ) {
            MyPageReducer()
        }

        await store.send(.logoutConfirmed) {
            $0.isLogoutAlertPresented = false
            $0.user = nil
        }
    }

    // logoutCancelled → 다이얼로그만 닫힘, user 유지
    func test_logoutCancelled_keepsUser() async {
        let store = await TestStore(
            initialState: MyPageReducer.State(
                user: mockUser,
                isLogoutAlertPresented: true
            )
        ) {
            MyPageReducer()
        }

        await store.send(.logoutCancelled) {
            $0.isLogoutAlertPresented = false
        }
    }
}

// MARK: - Mocks

private struct MockUserRepository: UserRepository {
    var user: User? = nil
    var shouldFail = false

    func fetchUser(id: String) async throws -> User {
        if shouldFail { throw MockError.failed }
        guard let user else { throw MockError.failed }
        return user
    }
}

private enum MockError: Error {
    case failed
}
