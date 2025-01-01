import Foundation

struct CalendarResponse: Codable {
    let plans: [SimplePlan]
    let planSubs: [DetailedPlan]
}

struct SimplePlan: Codable {
    let planId: Int
    let plantitle: String
    let startDate: String
    let endDate: String
}

struct DetailedPlan: Codable {
    let plansubId: Int
    let plansubtitle: String
    let startDate: String
    let endDate: String
    let deadline: String?
}