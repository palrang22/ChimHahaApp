import XCTest
import ComposableArchitecture
@testable import ChimHahaApp

final class SearchReducerTests: XCTestCase {

    let mockPosts = [
        Post(id: "1", userId: "1", name: "유저1", title: "침착맨 짤", body: "본문1",
             imageURL: nil, tags: nil, viewCount: nil, likeCount: nil,
             dislikeCount: nil, commentCount: nil, scrapCount: nil, createdAt: nil),
        Post(id: "2", userId: "2", name: "유저2", title: "유머 게시글", body: "본문2",
             imageURL: nil, tags: nil, viewCount: nil, likeCount: nil,
             dislikeCount: nil, commentCount: nil, scrapCount: nil, createdAt: nil)
    ]

    // onAppear → 포스트 fetch 성공 시 allPosts에 저장
    func test_onAppear_success_storesAllPosts() async {
        let store = await TestStore(initialState: SearchReducer.State()) {
            SearchReducer()
        } withDependencies: {
            $0.postRepository = MockPostRepository(posts: mockPosts)
        }

        await store.send(.onAppear) {
            $0.isSearching = true
        }
        await store.receive(\.postsResponse) {
            $0.isSearching = false
            $0.allPosts = self.mockPosts
        }
    }

    // onAppear → allPosts가 이미 있으면 fetch 안 함
    func test_onAppear_skipsIfAlreadyLoaded() async {
        let store = await TestStore(
            initialState: SearchReducer.State(allPosts: mockPosts)
        ) {
            SearchReducer()
        } withDependencies: {
            $0.postRepository = MockPostRepository(posts: mockPosts)
        }

        await store.send(.onAppear)  // 아무 State 변화 없어야 함
    }

    // onAppear → fetch 실패 시 isSearching false로 복구
    func test_onAppear_failure_resetsIsSearching() async {
        let store = await TestStore(initialState: SearchReducer.State()) {
            SearchReducer()
        } withDependencies: {
            $0.postRepository = MockPostRepository(shouldFail: true)
        }

        await store.send(.onAppear) {
            $0.isSearching = true
        }
        await store.receive(\.postsResponse) {
            $0.isSearching = false
        }
    }

    // queryChanged → 제목 포함 여부로 필터링
    func test_queryChanged_filtersByTitle() async {
        let store = await TestStore(
            initialState: SearchReducer.State(allPosts: mockPosts)
        ) {
            SearchReducer()
        } withDependencies: {
            $0.postRepository = MockPostRepository(posts: mockPosts)
        }

        await store.send(.queryChanged("침착맨")) {
            $0.query = "침착맨"
        }
        await store.receive(\.resultsResponse) {
            $0.results = [self.mockPosts[0]]
        }
    }

    // queryChanged → 빈 쿼리면 전체 반환
    func test_queryChanged_emptyQuery_returnsAll() async {
        let store = await TestStore(
            initialState: SearchReducer.State(allPosts: mockPosts)
        ) {
            SearchReducer()
        } withDependencies: {
            $0.postRepository = MockPostRepository(posts: mockPosts)
        }

        await store.send(.queryChanged(""))
        await store.receive(\.resultsResponse) {
            $0.results = self.mockPosts
        }
    }
}

// MARK: - Mocks

private struct MockPostRepository: PostRepository {
    var posts: [Post] = []
    var shouldFail = false

    func fetchPosts() async throws -> [Post] {
        if shouldFail { throw MockError.failed }
        return posts
    }

    func fetchPost(id: String) async throws -> Post {
        guard let post = posts.first(where: { $0.id == id }) else {
            throw MockError.failed
        }
        return post
    }

    func fetchComments(postId: String) async throws -> [Comment] { [] }
}

private enum MockError: Error {
    case failed
}
