//
//  ChimHahaApp.swift
//  ChimHahaApp
//
//  Created by 김승희 on 2/26/26.
//

import SwiftUI

@main
struct ChimhahaApp: App {
    var body: some Scene {
        WindowGroup {
            Text("침하하")
                .font(.chimTitle1)
                .foregroundStyle(Color("chimPrimary"))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("chimBG"))
                .ignoresSafeArea()
        }
    }
}
