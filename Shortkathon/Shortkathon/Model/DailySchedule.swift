import Foundation


struct DailySchedule: Codable {
    let date: String
    let totalCount: Int
    let completedCount: Int
    let plans: [Plan]
    let details: [Detail]
}

struct Plan: Codable {
    let planId: Int
    let title: String
    let startTime: String?
    let endTime: String?
    let completed: Bool
}

struct Detail: Codable {
    let detailId: Int
    let title: String
    let content: String
    let startTime: String
    let endTime: String
    let completed: Bool
}
