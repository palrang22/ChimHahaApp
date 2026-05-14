# Chimhaha App — Development Plan

Work through this plan step by step with Claude Code.
At the start of each step, say: **"Let's work on Step N from PLAN.md"**
Mark completed items with `- [x]`.
After finishing a step, Claude Code will check off items and summarize what was learned.

---

## Step 1 — Project Setup
> Goal: A clean, buildable project with the right folder structure and design tokens in place.

- [x] Create `Chimhaha` iOS App project in Xcode (SwiftUI, Swift, minimum iOS 17)
- [x] Add TCA via Swift Package Manager: `https://github.com/pointfreeco/swift-composable-architecture`
- [x] Create folder structure from CLAUDE.md
- [x] `Colors.xcassets` — chimPrimary, chimBG, chimSurface, chimSurface2, chimLabel/2/3, chimSeparator (`Color("chimPrimary")` 로 직접 참조)
- [x] `Typography.swift` — define font styles (title, body, caption, etc.)
- [x] `ChimhahaApp.swift` — set up `@main` with a placeholder root view
- [x] Confirm the project builds with no errors

**You'll learn:** Xcode project setup, Swift Package Manager, `@main`, `App` protocol, `WindowGroup`

---

## Step 2 — Domain Models + Network Layer
> Goal: A working URLSession + Combine API client that talks to JSONPlaceholder.

- [x] `Post.swift` — `Codable`, `Equatable`, `Identifiable`
- [x] `Comment.swift` — same (+ `parentId: String?` for 대댓글)
- [x] `User.swift` — same
- [x] `Board.swift` — board model with `viewType` enum + static board data
- [x] `NetworkError.swift` — custom error enum
- [x] `Endpoint.swift` — enum with cases for each API route
- [x] `APIClient.swift` — `URLSession.shared.data(for:)` + `async/await` + `decode`
- [x] `PostRepository.swift` — protocol (fetchPosts, fetchPost, fetchComments)
- [x] `PostRepositoryImpl.swift` — concrete implementation using `APIClient`
- [x] `APIClientTests.swift` — mock tests for network layer

**You'll learn:** `Codable`, `URLSession` async/await, `data(for:)`, `JSONDecoder`, protocol-based DI

---

## Step 3 — App Shell + Tab Bar
> Goal: The root tab bar is working and each tab shows a placeholder screen.

- [x] `AppReducer.swift` — root reducer with `selectedTab` state + tab `Action`
- [x] `AppView.swift` — `TabView` with 4 tabs: Home, Search, Write, My Page
- [x] Tab bar icons use SF Symbols: `house`, `magnifyingglass`, `pencil`, `person`
- [x] Active tab color: `chimPrimary`
- [x] Each tab shows a simple placeholder `Text("...")` view for now

**You'll learn:** `TabView`, `Tab(title:systemImage:value:content:)`, `.tint`, basic TCA store wiring in `@main`

---

## Step 4 — Home Feed (Post List)
> Goal: The Home tab shows a scrollable post list fetched from JSONPlaceholder.

- [x] `HomeReducer.swift`
  - State: `posts: [Post]`, `isLoading: Bool`, `selectedBoard: Board`, `filter: FeedFilter`
  - Action: `onAppear`, `postsResponse`, `postTapped`, `filterChanged`, `boardChanged`
- [x] `HomeView.swift`
  - Nav bar: board name button (→ opens drawer) + bell icon
  - Board description banner (conditional on `board.desc`)
  - Filter chips: 전체 | 인기 | 주간 | 월간
  - `List` of `PostRowView`
- [x] `PostRowView.swift`
  - Board tag chip (teal)
  - Title (2-line clamp)
  - Author · time · likes · comment count
  - Right-side 72×72 thumbnail if `post.imageURL != nil`
- [x] Loading state (ProgressView)
- [x] Empty/error state
- [x] `HomeReducerTests.swift`

**You'll learn:** `List`, `LazyVStack`, `.listStyle`, `AsyncImage`, TCA `Effect.run`, `@ObservableState`

---

## Step 4.5 — DummyJSON 마이그레이션
> Goal: JSONPlaceholder → DummyJSON으로 교체해 좋아요·조회수·태그·유저명·이미지(fake)·날짜(fake) 데이터를 채운다.

- [x] `Endpoint.swift` — base URL을 `dummyjson.com`으로 변경, 응답 구조에 맞게 경로 수정
- [x] `Post.swift` — `likeCount`, `dislikeCount`, `viewCount`, `tags` 실제 데이터로 연결. `imageURL`은 picsum fake URL, `createdAt`은 fake 날짜 생성
- [x] `Comment.swift` — `name` 필드를 `user.fullName`으로 매핑, `likeCount` 연결
- [x] `PostRepositoryImpl.swift` — 페이지네이션 응답 wrapper(`posts: []`, `total:`) 처리
- [x] `CommentRepository.swift` + `CommentRepositoryImpl.swift` — 신규 작성 (댓글 fetch)
- [x] `PostRepositoryDependency.swift` — `commentRepository` dependency 추가
- [x] 기존 테스트 Mock 업데이트

**You'll learn:** 중첩 JSON 디코딩, 커스텀 `CodingKeys`, API 래퍼 타입 처리

---

## Step 5 — Board Drawer
> Goal: Tapping the board name slides in a drawer with the full board hierarchy.

- [x] `BoardDrawerReducer.swift`
  - State: `isOpen: Bool`, `expandedSections: Set<String>`, `favorites: [Board.ID]`
  - Action: `open`, `close`, `toggleSection`, `toggleFavorite`, `boardSelected`
- [x] `BoardDrawerView.swift`
  - Slides in from left with `.offset` + `withAnimation`
  - Dim overlay behind drawer (tap to close)
  - Top shortcuts: 🔥 인기글, 🏛️ 알렉산드리아, 🖼️ 박물관, 📋 전체글
  - Favorites section
  - Collapsible sections: 침착맨 / 독립 게시판 / 침하하 게임
  - Star (★) button per row to toggle favorites
  - 🪨 소원의 돌 pinned at bottom
- [x] Selecting a board updates `HomeReducer.selectedBoard` and closes drawer

**You'll learn:** `.offset`, `DragGesture`, `withAnimation`, `ZStack` layering, Parent–Child TCA Reducer

---

## Step 6 — Post Detail + Comments
> Goal: Tapping a post navigates to a detail screen with full content and comments.

- [x] `PostDetailReducer.swift`
  - State: `post: Post`, `comments: [Comment]`, `isLoading: Bool`, `commentInput: String`
  - Action: `onAppear`, `commentsResponse`, `commentInputChanged`, `submitComment`, `likeTapped`
- [x] `PostDetailView.swift`
  - Back button nav bar
  - Post title + author avatar + time + view count
  - Post body text
  - Image (full-width, if available)
  - Reaction buttons (침하하/침흑흑) + scrap + post navigation
  - `LazyVStack` comment list
  - Comment input bar pinned to bottom (`.safeAreaInset`)
- [x] `CommentRowView.swift`
- [x] `PostDetailReducerTests.swift`
- [x] `HomeView` → `PostDetailView` 네비게이션 연결

**You'll learn:** `NavigationStack`, `navigationDestination`, `LazyVStack`, `.safeAreaInset`, `ScrollViewReader`

---

## Step 7 — Grid View (알렉산드리아 짤 도서관)
> Goal: Selecting 알렉산드리아 switches the home feed to a 3-column image grid.

- [x] `PostGridCellView.swift` — square image + title + likes + date
- [x] `HomeView` conditionally renders `LazyVGrid` when `selectedBoard.viewType == .grid`
- [x] `LazyVGrid` with 3 `GridItem(.flexible())` columns, 2pt gap
- [x] `AsyncImage` with placeholder shimmer/color
- [x] Tapping a grid cell navigates to `PostDetailView`

**You'll learn:** `LazyVGrid`, `GridItem`, `AsyncImage`, `.aspectRatio`, conditional view switching in SwiftUI

---

## Step 8 — Search
> Goal: A functional search screen with board filter chips and real-time results.

- [x] `SearchReducer.swift`
  - State: `query: String`, `results: [Post]`, `selectedBoard: Board?`, `isSearching: Bool`
  - Action: `queryChanged`, `boardFilterChanged`, `resultsResponse`
- [x] `SearchView.swift`
  - Search text field (custom styled, not `searchable`)
  - Board filter chips (horizontal scroll)
  - Results list using `PostRowView`
  - Empty state and no-results state
- [x] `.debounce(id:for:clock:)` in TCA Effect to throttle search requests
- [x] `SearchReducerTests.swift`

**You'll learn:** TCA `.debounce`, `Effect.run`, TCA search patterns, `FocusState`

---

## Step 9 — My Page
> Goal: My Page screen with profile header and all menu items.

- [x] `MyPageReducer.swift`
  - State: `user: User?`, `isLoggedIn: Bool`
  - Action: `onAppear`, `userResponse`, `logoutTapped`, `wishingstoneTapped`
- [x] `MyPageView.swift`
  - Profile header: avatar + username + points + 🪨 wishing stone button
  - Grouped `List` sections (use `.listStyle(.insetGrouped)`)
  - Navigation to sub-pages (stubs for now)
  - Logout button (red, confirmation alert)
- [x] `MyPageReducerTests.swift`

**You'll learn:** `.listStyle(.insetGrouped)`, `.confirmationDialog`, navigation from My Page into other features

---

## Step 10 — Wishing Stone (소원의 돌)
> Goal: Implement the fully custom Wishing Stone screen.

- [x] `WishingStoneReducer.swift`
  - State: `wishes: [Wish]`, `inputText: String`, `todayPrayed: Bool`
  - Action: `onAppear`, `inputChanged`, `submitWish`, `wishesResponse`
- [x] `WishingStoneView.swift`
  - Circular stone with radial gradient + reflection
  - Stats row (prayer date, attendance, points) — 3-column card
  - Input field + submit button + "오늘 기도 완료" badge
  - Wavy SVG divider (drawn with `Path` or `Shape`)
  - Ranked wish list with triangle rank badge
- [x] Accessible from both board drawer (bottom) and My Page profile header
- [x] `WishingStoneReducerTests.swift`

**You'll learn:** `Path`, custom `Shape`, `Canvas`, radial `LinearGradient`, TCA navigation from multiple entry points

---

## Step 11 — Write Screen (WKWebView + React + CKEditor 5)
> Goal: A native Write tab that hosts a React+TS web editor built with CKEditor 5, communicating with Swift via WKWebView message bridge.

### Phase A — React + CKEditor 5 Setup
- [ ] Scaffold `ChimhahaEditor/` with Vite (react-ts template) at the repo root alongside the Xcode project
- [ ] Install CKEditor 5 v43.2.0 (`ckeditor5` npm package)
- [ ] `Editor.tsx` — wrap CKEditor 5 ClassicEditor with full toolbar config matching chimhaha.net (bold, italic, underline, strikethrough, font family with Korean fonts, font size, color, alignment, lists, indent, blockquote, hr, link, image, media embed, source editing, undo/redo)
- [ ] `PollEditor.tsx` — poll toggle section (poll title input + dynamic option list with add/remove)
- [ ] `TitleInput.tsx` — styled title text input above the editor
- [ ] `bridge.ts` — JS side of Swift↔JS bridge (`postMessage` helpers + `window.editor` API for Swift to call in)
- [ ] `App.tsx` — composes TitleInput + Editor + PollEditor, wires up bridge
- [ ] Korean custom fonts loaded via `@font-face` in CSS (나눔고딕, 나눔명조, 메이플스토리, etc.)
- [ ] Dark theme CSS matching chimBG (`#000000`) and chimSurface (`#1C1C1E`) design tokens
- [ ] Deploy to Vercel — connect GitHub repo to Vercel project, confirm auto-deploy on push works

**You'll learn:** React functional components, useState, useEffect, useRef, TypeScript props/interfaces, Vite build config, CKEditor 5 React integration

### Phase B — WKWebView Integration (Swift)
- [ ] `WriteReducer.swift` — State: `selectedBoard`, `isEditorReady`, `isSubmitting`; Action: `editorReady`, `webViewMessage(EditorMessage)`, `cancelTapped`, `boardSelected`
- [ ] `EditorMessage.swift` — Codable struct for bridge message types (`ready`, `submit`, `requestImagePicker`)
- [ ] `WriteView.swift` — hosts `EditorWebView` (WKWebView wrapper), nav bar with Cancel / 등록 buttons (등록 disabled until `isEditorReady`), board picker sheet
- [ ] `EditorWebView.swift` — `UIViewRepresentable` wrapping `WKWebView`; sets up `WKScriptMessageHandler` for `chimEditor` message channel
- [ ] `EditorWebView.swift` loads the editor from a remote URL:
      Production → `https://chimhaha-editor.vercel.app`
      Debug → `http://localhost:5173`
      Controlled via a Swift compile-time DEBUG flag.
- [ ] Add `NSAppTransportSecurity` exception for the Vercel domain in `Info.plist`
- [ ] `WriteReducerTests.swift`

**You'll learn:** WKWebView, UIViewRepresentable, WKScriptMessageHandler, remote URL loading, environment-based URL switching, bridging web↔native

---

## Step 11.5 — Vercel Deployment
> Goal: ChimhahaEditor is live on Vercel and WKWebView loads it successfully.

- [ ] Push `ChimhahaEditor/` to GitHub
- [ ] Connect the repo to Vercel — set root directory to `ChimhahaEditor/`
- [ ] Confirm auto-deploy triggers on `git push`
- [ ] Verify the deployed URL loads correctly in Safari
- [ ] Point `EditorWebView.swift` production URL to the live Vercel URL
- [ ] Test on simulator: editor loads, bridge messages fire correctly

**You'll learn:** Vercel deployment, CI/CD basics, environment-based URL switching in Swift

---

## Step 12 — Polish + Testing
> Goal: Everything works end-to-end, errors are handled gracefully, tests pass.

- [ ] Unified empty state view component (reusable across all screens)
- [ ] Unified error state view component with retry button
- [ ] Unified loading skeleton / `ProgressView` pattern
- [ ] Review all `Reducer` test coverage — aim for all `Action` cases covered
- [ ] Basic accessibility: `.accessibilityLabel`, `.accessibilityHint` on interactive elements
- [ ] `README.md` — what was built, what was learned, known limitations

---

## How to Use This Plan with Claude Code

Note: Step 11 has two phases (A = React/web, B = Swift). Work on Phase A in the ChimhahaEditor/ folder using VS Code or your preferred editor. Switch back to Xcode for Phase B.

Start each step by saying:
```
Let's work on Step N from PLAN.md.
Check off items as we complete them.
After each file, explain the SwiftUI or TCA concept we just used so I can learn from it.
```

If you get stuck on a concept, switch to Claude.ai (web) and ask:
```
I'm working on [concept] in my SwiftUI + TCA project. Can you explain how [X] works
and why we're using it this way?
```

Then come back to Claude Code to continue building.

---

## Notes
- Step 11 Phase A can be worked on in VS Code inside `ChimhahaEditor/`. Switch to Xcode for Phase B.
- Feel free to add new steps, sub-steps, or new .md files as the project evolves.
  New markdown files (e.g. `EDITOR.md`, `BRIDGE.md`) are welcome if a topic needs
  more detailed documentation than fits in PLAN.md.
