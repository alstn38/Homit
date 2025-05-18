//
//  LoadingOverlay.swift
//  Homit
//
//  Created by 강민수 on 5/18/25.
//

import SwiftUI

struct LoadingOverlay: ViewModifier {
    
    let isLoading: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.gray45.opacity(0.4))
                }
            }
    }
}

extension View {
    func loadingOverlay(_ isLoading: Bool) -> some View {
        self.modifier(LoadingOverlay(isLoading: isLoading))
    }
}
