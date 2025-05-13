//
//  SignUpView.swift
//  Homit
//
//  Created by 강민수 on 5/12/25.
//

import SwiftUI

import ComposableArchitecture

struct SignUpView: View {
    
    @Perception.Bindable
    var store: StoreOf<SignUpFeature>
    
    @FocusState
    private var isTextFieldFocused: Bool
    
    var body: some View {
        WithPerceptionTracking {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header()
                    nameField()
                    emailField()
                    passwordFields()
                    Spacer()
                    HomitTCAButton(title: "가입하기", isEnabled: store.isValidButton) {
                        store.send(.signUpButtonDidTap)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
            .background(Color.gray15)
            .onTapGesture {
                isTextFieldFocused = false
            }
        }
    }
    
    private func header() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("회원가입")
                .customTextStyle(font: HaeparangFont.title1, color: .gray100)
                .padding(.top, 16)
            
            Text("나만의 집을 찾는 여정을 시작해보세요")
                .customTextStyle(font: PretendardFont.body2, color: .gray60)
        }
    }
    
    private func nameField() -> some View {
        LoginTextField(
            text: $store.nickName,
            title: "닉네임",
            placeholder: "닉네임을 입력해주세요"
        )
        .focused($isTextFieldFocused)
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
    
    private func passwordFields() -> some View {
        VStack(spacing: 24) {
            LoginSecureField(
                text: $store.password,
                title: "비밀번호",
                placeholder: "영문, 숫자 포함 8자 이상 입력해주세요"
            )
            .focused($isTextFieldFocused)
            
            LoginSecureField(
                text: $store.confirmPassword,
                title: "비밀번호 확인",
                placeholder: "비밀번호를 한 번 더 입력해주세요"
            )
            .focused($isTextFieldFocused)
        }
    }
}
