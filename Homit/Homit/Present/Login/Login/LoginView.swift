//
//  LoginView.swift
//  Homit
//
//  Created by 강민수 on 5/12/25.
//

import SwiftUI
import AuthenticationServices

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
            .loadingOverlay(store.isLoading)
            .alert($store.scope(state: \.alert, action: \.alert))
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
            SignInWithAppleButton(
                onRequest: { request in
                    request.requestedScopes = [.fullName, .email]
                },
                onCompletion: { result in
                    switch result {
                    case .success(let authResults):
                        switch authResults.credential {
                        case let appleIDCredential as ASAuthorizationAppleIDCredential:
                            guard
                                let identityTokenData = appleIDCredential.identityToken,
                                let identityToken = String(data: identityTokenData, encoding: .utf8)
                            else { return }
                            
                            /// 닉네임 추출
                            let fullName = appleIDCredential.fullName
                            let nickName = (fullName?.familyName ?? "") + (fullName?.givenName ?? "")
                            let finalNickName = nickName.isEmpty
                            ? "AppleUser_" + UUID().uuidString.prefix(8)
                            : nickName
                            
                            store.send(.appleLogin(idToken: identityToken, nickName: finalNickName))
                            
                        default:
                            break
                        }
                    case .failure(let error):
                        print("Apple Login Error: \(error.localizedDescription)")
                    }
                }
            )
            .frame(height: 50)
            .cornerRadius(12)
            .signInWithAppleButtonStyle(.white)
            
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
