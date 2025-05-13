//
//  HomitTCAButton.swift
//  Homit
//
//  Created by 강민수 on 5/13/25.
//

import SwiftUI

struct HomitTCAButton: View {
    
    let title: String
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
            Text(title)
                .customTextStyle(font: PretendardFont.body1, color: .gray0)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(isEnabled ? Color.deepCream : Color.gray45)
                .cornerRadius(12)
        }
        .disabled(!isEnabled)
    }
}
