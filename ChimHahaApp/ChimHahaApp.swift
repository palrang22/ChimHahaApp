//
//  ChimHahaApp.swift
//  ChimHahaApp
//
//  Created by 김승희 on 2/26/26.
//

import SwiftUI

import ComposableArchitecture

@main
struct ChimhahaApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(store: Store(initialState: AppReducer.State()) {
                AppReducer()
            })
            .preferredColorScheme(.dark)
        }
    }
}
