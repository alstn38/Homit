//
//  LoginView.swift
//  Homit
//
//  Created by 강민수 on 5/12/25.
//

import SwiftUI

import ComposableArchitecture

struct LoginView: View {
    
    let store: StoreOf<LoginFeature>
    
    var body: some View {
        NavigationStackStore(
            store.scope(state: \.path, action: LoginFeature.Action.path)
        ) {
            WithViewStore(store, observe: { $0 }) { viewStore in
                VStack {
                    Spacer()
                    topView()
                    Spacer()
                    Spacer()
                    buttonView(viewStore: viewStore)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background {
                    Image("loginImage")
                        .resizable()
                        .ignoresSafeArea()
                        .scaledToFill()
                }
            }
        } destination: { state in
            switch state {
            case .emailLogin:
                CaseLet(
                    /LoginFeature.Path.State.emailLogin,
                     action: LoginFeature.Path.Action.emailLogin,
                     then: EmailLoginView.init
                )
            }
        }
    }
    
    func topView() -> some View {
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
    
    func buttonView(viewStore: ViewStoreOf<LoginFeature>) -> some View {
        VStack(spacing: 16) {
            LoginButton(
                iconImage: Image(systemName: "apple.logo"),
                title: "Apple로 시작하기",
                backgroundColor: .white
            ) {
                viewStore.send(.appleLoginDidTap)
            }
            
            LoginButton(
                iconImage: Image("kakaoLogo"),
                title: "카카오로 시작하기",
                backgroundColor: Color.yellow
            ) {
                viewStore.send(.kakaoLoginDidTap)
            }
            
            LoginButton(
                iconImage: Image(systemName: "envelope"),
                title: "이메일로 시작하기",
                backgroundColor: Color.blue
            ) {
                viewStore.send(.emailLoginDidTap)
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 40)
    }
}
