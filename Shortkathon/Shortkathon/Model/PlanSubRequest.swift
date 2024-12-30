

import Foundation


struct PlanSubRequest1: Codable {
    let plansubtitle: String
    let startDate: String
    let endDate: String
}

struct PlanSubRequest2: Codable {
    let plansubtitle: String
    let startDate: String
    let endDate: String
    let deadline: String
}



struct PlanSubResponse: Codable {
    // 서버 응답에 맞게 필드 추가
    let check: Bool
}
