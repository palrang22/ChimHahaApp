# Chimhaha iOS App

A learning project that reimplements chimhaha.net — the official fan community of Korean streamer "Chimchakman" — as a native iOS app using SwiftUI and TCA.

The developer has prior experience with UIKit, Clean Architecture, MVVM-C, and Swinject, and is using this project to learn SwiftUI, TCA, and Swift Concurrency.

---

## Developer Background

- Experienced with UIKit, Clean Architecture, MVVM-C, Swinject
- Learning SwiftUI, TCA (The Composable Architecture), and Swift Concurrency (async/await) through this project
- Wants to write unit tests alongside feature development

---

## Working With Claude Code

- **The developer types all code themselves.** Unless explicitly asked, Claude should only show code in chat — never write it to files directly.
- **At the start of every session**, read PLAN.md, identify the current step, and tell the developer what to work on next before doing anything else.
- **When starting a new step**, first give a brief overview of the entire step (goal + list of sub-steps). Then present sub-steps **one at a time** — wait for the developer to confirm they're done before moving to the next. Never dump all sub-steps at once.
- **After each sub-step**, briefly explain the SwiftUI or TCA concept that was just used.
- **When showing View code**, always include a `#Preview` block at the bottom.

---

## Tech Stack

| Layer | Choice | Notes |
|-------|--------|-------|
| UI | SwiftUI | No UIKit — SwiftUI only |
| Architecture | TCA (The Composable Architecture) | pointfreeco/swift-composable-architecture |
| Async | Swift Concurrency | async/await + Effect.run in TCA |
| Networking | URLSession + async/await | |
| DI | TCA `@Dependency` pattern | No Swinject |
| API | JSONPlaceholder | https://jsonplaceholder.typicode.com |
| Testing | Swift Testing + XCTest | Unit tests required for every Reducer |
| Web Editor | React + TypeScript (Vite) + CKEditor 5 v43.2.0 | Bundled into app via WKWebView |

---

## Project Structure

```
Chimhaha/
├── App/
│   ├── ChimhahaApp.swift          # @main entry point
│   └── AppReducer.swift           # Root reducer — tab + navigation state
│
├── Domain/
│   ├── Models/
│   │   ├── Post.swift
│   │   ├── Comment.swift
│   │   ├── Board.swift            # Board model with viewType enum
│   │   └── User.swift
│   └── Repositories/              # Protocol definitions only
│       ├── PostRepository.swift
│       └── CommentRepository.swift
│
├── Data/
│   ├── Network/
│   │   ├── APIClient.swift        # URLSession + async/await
│   │   ├── Endpoint.swift
│   │   └── NetworkError.swift
│   └── Repositories/              # Concrete implementations
│       ├── PostRepositoryImpl.swift
│       └── CommentRepositoryImpl.swift
│
├── Features/
│   ├── App/
│   │   └── AppView.swift          # Root TabView
│   ├── Home/
│   │   ├── HomeView.swift
│   │   ├── HomeReducer.swift
│   │   ├── BoardDrawer/
│   │   │   ├── BoardDrawerView.swift
│   │   │   └── BoardDrawerReducer.swift
│   │   └── Components/
│   │       ├── PostRowView.swift          # List cell (thumbnail if image exists)
│   │       ├── PostGridCellView.swift     # Grid cell for 알렉산드리아
│   │       └── BoardDescBannerView.swift  # Board description strip
│   ├── PostDetail/
│   │   ├── PostDetailView.swift
│   │   ├── PostDetailReducer.swift
│   │   └── Components/
│   │       └── CommentRowView.swift
│   ├── Search/
│   │   ├── SearchView.swift
│   │   └── SearchReducer.swift
│   ├── Write/
│   │   ├── WriteView.swift
│   │   └── WriteReducer.swift
│   ├── MyPage/
│   │   ├── MyPageView.swift
│   │   └── MyPageReducer.swift
│   └── WishingStone/
│       ├── WishingStoneView.swift   # Custom UI — not a post list
│       └── WishingStoneReducer.swift
│
├── Core/
│   ├── DesignSystem/
│   │   ├── Typography.swift
│   │   └── Components/
│   │       ├── Colors.xcassets    # Color assets — use Color("chimPrimary")
│   │       └── (shared UI components used 3+ times)
│   └── Extensions/
│
└── Resources/
    └── Assets.xcassets
```

---

## Design Reference

Screenshots of the UI prototype are in `/DesignRef/` folder at the project root.
Refer to these images when implementing any UI component.

---

## Design System

### Colors

`Core/DesignSystem/Components/Colors.xcassets`에 정의. `Color("chimPrimary")` 형태로 직접 참조.

| Asset | 값 | 용도 |
|---|---|---|
| `chimPrimary` | `#00BCD4` | Teal — main accent |
| `chimBG` | `#000000` | True black background |
| `chimSurface` | `#1C1C1E` | Cards, drawer bg |
| `chimSurface2` | `#2C2C2E` | Inputs, secondary surfaces |
| `chimLabel` | white 100% | Primary text |
| `chimLabel2` | white 55% | Secondary text |
| `chimLabel3` | white 28% | Tertiary text |
| `chimSeparator` | white 8% | Dividers |

### Tab Bar (4 tabs)

| Tab | Icon | Content |
|-----|------|---------|
| Home | house | Post feed + board drawer |
| Search | magnifyingglass | Search with board filter chips |
| Write | pencil | Compose new post |
| My Page | person | Profile + account settings |

### Home Screen Layout (top → bottom)

1. **Nav bar** — board name button (chevron.down) on left, bell on right
2. **Board description banner** — only shown when `board.description != nil`. Subtle teal-tinted strip.
3. **Filter chips** — only shown for `list` viewType: 전체 | 인기 | 주간 | 월간
4. **Content** — switches by `board.viewType` (see below)

### Board View Types

| `viewType` | Layout |
|------------|--------|
| `list` | `List` / `LazyVStack` — each row has title, board tag chip, author, time, likes, comment count. Right-side 72×72 thumbnail if post has image. |
| `grid` | `LazyVGrid` 3 columns — square thumbnails, title, likes, date below. Used only for 알렉산드리아 짤 도서관. |
| `wish` | Fully custom Wishing Stone screen. No post list. |

### Post Row (list viewType)

```
┌─────────────────────────────────────┬──────────┐
│ [board tag]                         │          │
│ Post title, up to 2 lines           │ 72×72    │
│ author  ·  time       ❤️ 36  💬 9   │ thumb    │
└─────────────────────────────────────┴──────────┘
  (thumbnail only shown if post.imageURL != nil)
```

- Board tag: teal text, teal-tinted background pill
- Comment count: teal color, bold — only shown if count > 0
- No thumbnail column when post has no image (text expands to full width)

### Board Drawer

Opens from the board name button (left side of nav bar). Slides in from left.

```
게시판                               ← large header
────────────────────────────────────
🔥  인기글                          ← top shortcuts (no section)
🏛️  알렉산드리아 짤 도서관  ← grid viewType
🖼️  침하하 박물관
📋  전체글
────────────────────────────────────
즐겨찾기                            ← section label
  [favorited boards — star filled]
────────────────────────────────────
침착맨                        ▼    ← collapsed by default
    👀  방송일정 및 공지          [★]
    😊  침착맨                   [★]
    🎃  침착맨 짤                 [★]
    🎨  침착맨 팬아트             [★]
    🚩  침겜카 게시판             [★]
    📣  방송 해줘요               [★]
    🍳  추천 침투부 & 찾아요        [★]
    🎪  침착맨의 그림              [★]
독립 게시판                    ▼
    😄  유머                     [★]
    😱  호들갑                   [★]
    📖  취미                     [★]
    💻  인터넷방송                [★]
    😎  일상                     [★]
구쭈                    ▼
    🎉  ㅊㅊㅁ 구쭈                 [★]
    🐸  얼렁뚱땅 상점                [★]
    📸  구쭈 후기                   [★]
행정실                    ▼
    🖼️  사진첩                     [★]
    🙏  침투부 지원하기              [★]
    🤡  침하하 두들                 [★]
    🚨  신고/건의                  [★]
────────────────────────────────────
👑  이벤트
🪨  소원의 돌                       ← pinned at bottom, special entry
```

Star button (★) on each sub-board row toggles favorites.

### Wishing Stone (소원의 돌)

Custom screen — completely different from the post list. Accessible from:
- Board drawer → bottom pinned entry
- My Page → button next to points badge in profile header

Layout:
1. Large circular stone image (radial gradient, reflection highlight)
2. Stats row: prayer date / attendance score / prayer points — 3-column card
3. Prayer text input + "기도 올리기" button + "오늘 기도 완료" badge
4. Wavy teal SVG divider line
5. Ranked prayer list — each row has rank badge (triangle), username, streak days, prayer text

### Write Screen

- Board picker dropdown (shows full board list)
- Title text field
- Body text editor
- Poll section (optional — toggle to add/remove)
  - Poll title input
  - Option inputs (add/remove)
- Bottom toolbar: 사진 | 서식

**MVP: text + poll only.** Photo/video/formatting toolbar is UI-only for now.

### My Page

- Profile header with teal gradient background
  - Avatar (68pt circle)
  - Username
  - Points badge (teal)
  - **🪨 소원의 돌 button** — navigates to Wishing Stone
- Grouped list sections:
  - 회원정보 변경
  - 스크랩한 글 / 내가 쓴 글 / 내가 쓴 댓글 / 침하하 한 글 / 침하하 한 댓글
  - 차단한 사용자 / 푸시 알림 관리
  - 로그아웃 (red text)

---

## Domain Models

### Post
| Field | Type | Notes |
|---|---|---|
| `id` | `String` | |
| `userId` | `String` | |
| `name` | `String` | Author display name |
| `title` | `String` | |
| `body` | `String` | |
| `imageURL` | `URL?` | nil = no thumbnail |
| `tags` | `[String]?` | |
| `viewCount` | `Int?` | |
| `likeCount` | `Int?` | |
| `dislikeCount` | `Int?` | |
| `commentCount` | `Int?` | |
| `scrapCount` | `Int?` | |
| `createdAt` | `String?` | |

### Comment
| Field | Type | Notes |
|---|---|---|
| `id` | `String` | |
| `postId` | `String` | |
| `userId` | `String` | |
| `name` | `String` | Author display name |
| `body` | `String` | |
| `parentId` | `String?` | nil = top-level, non-nil = 대댓글 |
| `likeCount` | `Int?` | |
| `createdAt` | `String?` | |

### User
| Field | Type | Notes |
|---|---|---|
| `id` | `String` | |
| `name` | `String` | |
| `email` | `String` | |
| `imageURL` | `String?` | |
| `point` | `Int` | Prayer points (Wishing Stone) |

### Board
- `description: String?` — shown as banner strip when non-nil
- `viewType`: `.list` / `.grid` / `.wish`
- `section`: `.chimchakman` / `.independent` / `.guzzu` / `.administrative` / `nil` (shortcuts + special)
- `PostInteraction` (separate model) — `isLiked`, `isDisliked`, `isScrapped` per post; managed in Reducer State, not in Post

---

## API (JSONPlaceholder)

chimhaha.net has no public API. Using JSONPlaceholder as a stand-in for all post/comment/user data.

```
Base URL: https://jsonplaceholder.typicode.com

GET /posts                    → Post list
GET /posts/{id}               → Post detail
GET /posts/{id}/comments      → Comments for a post
GET /users                    → User list
GET /users/{id}               → User detail
```

### Dummy Data Mapping

- Most optional fields (`likeCount`, `imageURL`, etc.) will be `nil` from JSONPlaceholder — handle gracefully in UI
- `Comment` → use as-is (no `parentId` from JSONPlaceholder)

---

## Web Editor (Write Tab)

The Write tab uses a React + TypeScript web app (Vite) embedded via WKWebView instead of native SwiftUI, because rich text editing (CKEditor 5) is significantly easier to implement on the web.

### Project Structure
The React project lives at `ChimhahaEditor/` alongside the Xcode project (monorepo).
Built output is deployed to Vercel (auto-deployed on git push).
WKWebView loads the editor via remote URL, not a local bundle.
Vercel handles all deployment automatically — no Xcode Build Phase script needed.

### Environments
- Production: `https://chimhaha-editor.vercel.app` (auto-deployed on git push)
- Local dev: `http://localhost:5173` (Vite dev server — simulator only, not physical device)

Use a Swift compile-time flag (`DEBUG`) to switch between URLs.

### Swift ↔ JS Bridge
- JS → Swift: `window.webkit.messageHandlers.chimEditor.postMessage({ type, payload })`
- Swift → JS: `webView.evaluateJavaScript("window.editor.someMethod()")`

### Key message types (JS → Swift)
- `ready` — editor has loaded, Swift can inject initial data
- `submit` — user tapped 등록; payload contains `{ title, body, poll? }`
- `requestImagePicker` — user tapped image button; Swift opens native photo picker

### CKEditor 5 Feature Set
Bold, italic, underline, strikethrough, font family (including Korean custom fonts: 나눔고딕, 나눔명조, 메이플스토리, etc.), font size, font/background color, text alignment, lists, indentation, blockquote, horizontal line, link, image upload, media embed, table, find & replace, undo/redo, source editing.

---

## TCA Pattern

Every feature follows this exact structure:

```swift
@Reducer
struct PostListReducer {

    @ObservableState
    struct State: Equatable {
        var posts: [Post] = []
        var isLoading = false
        var errorMessage: String? = nil
    }

    enum Action {
        case onAppear
        case postsResponse(Result<[Post], any Error>)
        case postTapped(Post)
    }

    @Dependency(\.postRepository) var postRepository

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    do {
                        let posts = try await postRepository.fetchPosts()
                        await send(.postsResponse(.success(posts)))
                    } catch {
                        await send(.postsResponse(.failure(error)))
                    }
                }

            case let .postsResponse(.success(posts)):
                state.isLoading = false
                state.posts = posts
                return .none

            case let .postsResponse(.failure(error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none

            case .postTapped:
                return .none
            }
        }
    }
}
```

Key rules:
- `State` must conform to `Equatable`
- All async work goes through `Effect.run { send in ... }` — TCA 1.0+ 방식
- Repository는 `async throws` 시그니처 사용
- No side effects outside of `Effect`
- Every Reducer has a corresponding test file using `TestStore`

---

## Development Rules

1. **SwiftUI only** — no UIKit, no `UIViewRepresentable` unless absolutely necessary. Known justified exception: `EditorWebView.swift` wraps `WKWebView` (no SwiftUI equivalent exists)
2. **Swift Concurrency** — Repository는 `async throws`, Reducer 비동기는 `Effect.run`
3. **Unidirectional data flow** — Store drives View, View sends Actions only
4. **Layer isolation** — Domain layer must not import Data or Features
5. **Test every Reducer** — create the test file at the same time as the feature
6. **Extract shared components** — if a UI piece is used 3+ times, move it to `Core/DesignSystem/Components`
7. **Naming**:
   - Views: `PostListView`, `BoardDrawerView`
   - Reducers: `PostListReducer`, `BoardDrawerReducer`
   - Protocols: `PostRepository`
   - Implementations: `PostRepositoryImpl`
8. **One feature at a time** — finish each step completely before moving to the next
9. **Explain as you go** — after writing each file, briefly explain the SwiftUI/TCA concept used (this is a learning project)
10. **Design for change** — Prefer protocols over concrete types. Avoid magic numbers and hardcoded strings. When a simpler but inflexible solution is chosen, leave a `// TODO:` comment explaining the tradeoff. Always ask: "if requirements changed tomorrow, how painful would this be?"

---

## Learning Goals (priority order)

1. SwiftUI layout — `List`, `LazyVGrid`, `ScrollView`, `HStack/VStack/ZStack`, `overlay`
2. `NavigationStack` + `navigationDestination` for push navigation
3. TCA fundamentals — `State`, `Action`, `Reducer`, `Store`, `@Dependency`
4. Swift Concurrency networking — `async/await`, `URLSession.data(for:)`, `Task`, `throwing functions`, structured concurrency
5. Custom reusable SwiftUI components
6. TCA unit testing with `TestStore`
7. Parent–Child Reducer composition + TCA navigation stack patterns
8. React + TypeScript fundamentals — components, hooks (useState, useEffect, useRef), props, event handling, Vite build tooling
