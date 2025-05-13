//
//  EmailLoginView.swift
//  Homit
//
//  Created by 강민수 on 5/12/25.
//

import SwiftUI

import ComposableArchitecture

struct EmailLoginView: View {
    
    @Perception.Bindable
    var store: StoreOf<EmailLoginFeature>
    
    @FocusState
    private var isTextFieldFocused: Bool
    
    var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading, spacing: 24) {
                header()
                emailField()
                passwordField()
                Spacer()
                HomitTCAButton(title: "로그인", isEnabled: store.isValidButton) {
                    store.send(.loginButtonDidTap)
                }
                signUpButton()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
            .background(Color.gray15)
            .onTapGesture {
                isTextFieldFocused = false
            }
        }
    }
    
    private func header() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("로그인")
                .customTextStyle(font: HaeparangFont.title1, color: .gray100)
                .padding(.top, 16)
            
            Text("집을 찾는 따뜻한 여정, Homit")
                .customTextStyle(font: PretendardFont.body2, color: .gray60)
        }
    }
    
    private func emailField() -> some View {
        LoginTextField(
            text: $store.email,
            title: "이메일",
            placeholder: "이메일을 입력해주세요",
            keyboardType: .emailAddress
        )
        .focused($isTextFieldFocused)
    }
    
    private func passwordField() -> some View {
        LoginSecureField(
            text: $store.password,
            title: "비밀번호",
            placeholder: "비밀번호를 입력해주세요"
        )
        .focused($isTextFieldFocused)
    }
    
    private func signUpButton() -> some View {
        Button {
            store.send(.signUpButtonDidTap)
        } label: {
            Text("계정이 없으신가요? 회원가입")
                .customTextStyle(font: PretendardFont.body3, color: .deepCoast)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 16)
        }
    }
}
