import XCTest
@testable import ChimHahaApp

final class APIClientTests: XCTestCase {

    override func tearDown() {
        URLProtocolStub.reset()
    }

    func test_fetch_success_decodesPosts() async throws {
        let json = """
        [{"id": "1", "userId": "1", "name": "테스터", "title": "Hello", "body": "World"}]
        """.data(using: .utf8)!

        URLProtocolStub.stub(data: json, statusCode: 200)
        let client = APIClient(session: .stubbed)

        let posts: [Post] = try await client.fetch(.posts)

        XCTAssertEqual(posts.count, 1)
        XCTAssertEqual(posts.first?.title, "Hello")
    }

    func test_fetch_requestFailed_throws404Error() async {
        URLProtocolStub.stub(data: Data(), statusCode: 404)
        let client = APIClient(session: .stubbed)

        do {
            let _: [Post] = try await client.fetch(.posts)
            XCTFail("에러가 발생해야 합니다")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .requestFailed(statusCode: 404))
        } catch {
            XCTFail("예상치 못한 에러: \(error)")
        }
    }

    func test_fetch_invalidJSON_throwsDecodingFailed() async {
        URLProtocolStub.stub(data: "not json".data(using: .utf8)!, statusCode: 200)
        let client = APIClient(session: .stubbed)

        do {
            let _: [Post] = try await client.fetch(.posts)
            XCTFail("에러가 발생해야 합니다")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .decodingFailed)
        } catch {
            XCTFail("예상치 못한 에러: \(error)")
        }
    }
}

// MARK: - URLProtocol Stub

final class URLProtocolStub: URLProtocol {
    private static var stubbedData: Data = Data()
    private static var stubbedStatusCode: Int = 200

    static func stub(data: Data, statusCode: Int) {
        stubbedData = data
        stubbedStatusCode = statusCode
    }

    static func reset() {
        stubbedData = Data()
        stubbedStatusCode = 200
    }

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        let response = HTTPURLResponse(
            url: request.url!,
            statusCode: URLProtocolStub.stubbedStatusCode,
            httpVersion: nil,
            headerFields: nil
        )!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: URLProtocolStub.stubbedData)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

extension URLSession {
    static var stubbed: URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolStub.self]
        return URLSession(configuration: config)
    }
}
