//
//  LoginTextField.swift
//  Homit
//
//  Created by 강민수 on 5/13/25.
//

import SwiftUI

struct LoginTextField: View {
    
    @Binding
    var text: String
    let title: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .customTextStyle(font: PretendardFont.body1, color: .black)
            
            TextField(placeholder, text: $text)
                .customTextStyle(font: PretendardFont.body2, color: .black)
                .padding()
                .background(Color.gray30)
                .cornerRadius(12)
                .keyboardType(keyboardType)
                .autocapitalization(.none)
                .autocorrectionDisabled()
        }
    }
}
