//
//  RealmStorageError.swift
//  Homit
//
//  Created by 강민수 on 6/1/25.
//

import Foundation

enum RealmStorageError: LocalizedError {
    case realmSaveFailed
    case realmLoadFailed
    case realmDeleteFailed
    case realmUpdateFailed
    
    var errorDescription: String? {
        switch self {
        case .realmSaveFailed:
            return "데이터 저장에 실패했습니다."
        case .realmLoadFailed:
            return "데이터 불러오기에 실패했습니다."
        case .realmDeleteFailed:
            return "데이터 삭제에 실패했습니다."
        case .realmUpdateFailed:
            return "데이터 업데이트에 실패했습니다."
        }
    }
}
