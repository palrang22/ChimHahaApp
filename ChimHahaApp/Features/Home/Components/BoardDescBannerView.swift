//
//  BoardDescBannerView.swift
//  ChimHahaApp
//
//  Created by 김승희 on 3/3/26.
//

import SwiftUI


struct BoardDescBannerView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.chimCaption)
            .foregroundStyle(.chimPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(.chimPrimary.opacity(0.08))
    }
}
