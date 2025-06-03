//
//  EstateImageView.swift
//  Homit
//
//  Created by 강민수 on 6/3/25.
//

import SwiftUI

import Kingfisher

struct EstateImageView: View {
    let imageURL: URL?
    let width: CGFloat?
    let height: CGFloat?
    
    var body: some View {
        Group {
            if let imageURL = imageURL {
                KFImage(imageURL)
                    .requestModifier(AuthRequestModifier())
                    .placeholder {
                        Rectangle()
                            .fill(Color.gray30)
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Rectangle()
                    .fill(Color.gray30)
            }
        }
        .frame(width: width, height: height)
        .clipped()
    }
}
