import Foundation

struct ProjectListModel: Codable {
    let projects: [ProjectModel]
}

struct ProjectModel: Codable {
    let id: Int
    let title: String
    let color: String
    let username: String
}

struct ProjectDetailModel: Codable {
    let id: Int
    let title: String
    let color: String
    let code: String
    let username: String
    let scope: String
}

struct promptModel: Codable {
    let response: String
}
