import XCTest
import ComposableArchitecture
@testable import ChimHahaApp

final class PostDetailReducerTests: XCTestCase {

    let mockPost = Post(
        id: "1",
        userId: "1",
        name: "침투부원",
        title: "테스트 게시글",
        body: "테스트 본문",
        imageURL: nil,
        tags: ["침착맨"],
        viewCount: 100,
        likeCount: 10,
        dislikeCount: nil,
        commentCount: 3,
        scrapCount: nil,
        createdAt: Date()
    )

    let mockComments = [
        Comment(id: "1", parentId: nil, postId: "1", userId: "1",
                name: "유저A", body: "댓글1", likeCount: 5, createdAt: Date()),
        Comment(id: "2", parentId: nil, postId: "1", userId: "2",
                name: "유저B", body: "댓글2", likeCount: 2, createdAt: Date())
    ]

    // onAppear → 댓글 fetch 성공 시 comments에 저장
    func test_onAppear_success_storesComments() async {
        let store = await TestStore(
            initialState: PostDetailReducer.State(post: mockPost)
        ) {
            PostDetailReducer()
        } withDependencies: {
            $0.commentRepository = MockCommentRepository(comments: mockComments)
        }

        await store.send(.onAppear) {
            $0.isLoading = true
        }
        await store.receive(\.commentsResponse) {
            $0.isLoading = false
            $0.comments = self.mockComments
        }
    }

    // onAppear → 댓글 fetch 실패 시 errorMessage 저장
    func test_onAppear_failure_storesErrorMessage() async {
        let store = await TestStore(
            initialState: PostDetailReducer.State(post: mockPost)
        ) {
            PostDetailReducer()
        } withDependencies: {
            $0.commentRepository = MockCommentRepository(shouldFail: true)
        }

        await store.send(.onAppear) {
            $0.isLoading = true
        }
        await store.receive(\.commentsResponse) {
            $0.isLoading = false
            $0.errorMessage = MockError.failed.localizedDescription
        }
    }

    // submitComment → commentInput 초기화
    func test_submitComment_clearsInput() async {
        var initialState = PostDetailReducer.State(post: mockPost)
        initialState.commentInput = "테스트 댓글"

        let store = await TestStore(initialState: initialState) {
            PostDetailReducer()
        } withDependencies: {
            $0.commentRepository = MockCommentRepository(comments: [])
        }

        await store.send(.submitComment) {
            $0.commentInput = ""
        }
    }
}

// MARK: - Mocks

private struct MockCommentRepository: CommentRepository {
    var comments: [Comment] = []
    var shouldFail = false

    func fetchComments(postId: String) async throws -> [Comment] {
        if shouldFail { throw MockError.failed }
        return comments
    }
}

private enum MockError: Error {
    case failed
}
