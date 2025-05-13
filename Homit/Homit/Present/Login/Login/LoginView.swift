//
//  LoginView.swift
//  Homit
//
//  Created by 강민수 on 5/12/25.
//

import SwiftUI

import ComposableArchitecture

struct LoginView: View {
    
    @Perception.Bindable
    var store: StoreOf<LoginFeature>
    
    var body: some View {
        WithPerceptionTracking {
            NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
                VStack {
                    Spacer()
                    topView()
                    Spacer()
                    Spacer()
                    buttonView()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background {
                    Image("loginImage")
                        .resizable()
                        .ignoresSafeArea()
                        .scaledToFill()
                }
            } destination: { store in
                WithPerceptionTracking {
                    switch store.case {
                    case .emailLogin(let store):
                        EmailLoginView(store: store)
                    case .signUp(let store):
                        SignUpView(store: store)
                    }
                }
            }
        }
    }
    
    private func topView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("집을 찾는 따뜻한 여정")
            Text("Homit")
        }
        .customTextStyle(font: HaeparangFont.title1, color: .white)
        .frame(maxWidth: .infinity, alignment: .leading)
        .shadow(radius: 3)
        .padding(.leading, 24)
        .padding(.top, 40)
    }
    
    private func buttonView() -> some View {
        VStack(spacing: 16) {
            LoginButton(
                iconImage: Image(systemName: "apple.logo"),
                title: "Apple로 시작하기",
                backgroundColor: .white
            ) {
                store.send(.appleLoginDidTap)
            }
            
            LoginButton(
                iconImage: Image("kakaoLogo"),
                title: "카카오로 시작하기",
                backgroundColor: Color.yellow
            ) {
                store.send(.kakaoLoginDidTap)
            }
            
            LoginButton(
                iconImage: Image(systemName: "envelope"),
                title: "이메일로 시작하기",
                backgroundColor: Color.blue
            ) {
                store.send(.emailLoginDidTap)
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 40)
    }
}
