//
//  MyPageReducer.swift
//  ChimHahaApp
//
//  Created by 김승희 on 3/22/26.
//

import ComposableArchitecture


@Reducer
struct MyPageReducer {
    
    @ObservableState
    struct State: Equatable {
        var user: User? = nil
        var isLoading: Bool = false
        var isLogoutAlertPresented: Bool = false
        var isWishingStonePresented: Bool = false
    }
    
    enum Action {
        case onAppear
        case userResponse(Result<User, any Error>)
        case logoutTapped
        case logoutConfirmed
        case logoutCancelled
        case wishingStoneTapped
        case wishingStoneDismissed
    }
    
    @Dependency(\.userRepository) var userRepository
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard state.user == nil else { return .none }
                state.isLoading = true
                return .run { send in
                    do {
                        let user = try await userRepository.fetchUser(id: "1")
                        await send(.userResponse(.success(user)))
                    } catch {
                        await send(.userResponse(.failure(error)))
                    }
                }
                
            case let .userResponse(.success(user)):
                state.isLoading = false
                state.user = user
                return .none
                
            case .userResponse(.failure):
                state.isLoading = false
                return .none

            case .logoutTapped:
                state.isLogoutAlertPresented = true
                return .none
                
            case .logoutConfirmed:
                state.isLogoutAlertPresented = false
                state.user = nil
                return .none
                
            case .logoutCancelled:
                state.isLogoutAlertPresented = false
                return .none
                
            case .wishingStoneTapped:
                state.isWishingStonePresented = true
                return .none
                
            case .wishingStoneDismissed:
                state.isWishingStonePresented = false
                return .none
            }
            
        }
    }
    
}
