//
//  TopicEntity.swift
//  Homit
//
//  Created by 강민수 on 5/31/25.
//

import Foundation

struct TopicEntity {
    let title: String    /// 제목
    let content: String  /// 내용
    let date: String     /// 날짜 (ex: "25. 4. 4")
    let link: URL?       /// 외부 링크
}
