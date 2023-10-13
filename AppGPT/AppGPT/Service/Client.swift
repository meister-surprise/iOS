import Foundation
import Moya

enum API {
    case postProject(userName: String, title: String, color: String, code: String, scope: String)
    case getProjectList(scope: String)
    case getProjectDetail(id: Int)
    case patchProjectDetail(id: Int, username: String, title: String, color: String, code: String, scope: String)
    case getGeneratedCode(prompt: String)
    case deleteProject(id: Int)
}

extension API: TargetType {
    var baseURL: URL {
        return URL(string: "https://5066-211-180-159-197.ngrok-free.app")!
    }
    
    var path: String {
        switch self {
        case .postProject, .getProjectList:
            return "/project"
        case .getProjectDetail(let id), .patchProjectDetail(let id, _, _, _, _, _), .deleteProject(let id):
            return "/project/\(id)"
        case .getGeneratedCode:
            return "/gpt/chat"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postProject, .getGeneratedCode:
            return .post
        case .getProjectList, .getProjectDetail:
            return .get
        case .patchProjectDetail:
            return .patch
        case .deleteProject:
            return .delete
        }
        
    }
    
    var task: Task {
        switch self {
        default:
            switch self {
            case .postProject(let userName, let title, let color, let code, let scope):
                return .requestParameters(parameters:
                                            [
                                                "username": userName,
                                                "title": title,
                                                "color": color,
                                                "code": code,
                                                "scope": scope
                                            ], encoding: JSONEncoding.default )
            case .getProjectList(let scope):
                return .requestParameters(parameters:
                                            [
                                                "scope": scope
                                            ], encoding: URLEncoding.queryString)
            case .patchProjectDetail(_ , let username, let title, let color, let code, let scope):
                return .requestParameters(parameters:
                                            [
                                                "username": username,
                                                "title": title,
                                                "color": color,
                                                "code": code,
                                                "scope": scope
                                            ], encoding: JSONEncoding.default)
            case .getGeneratedCode(let prompt):
                return .requestParameters(parameters:
                                            [
                                                "prompt": prompt
                                            ], encoding: JSONEncoding.default)
            default:
                return .requestPlain
            }
        }
    }
    
    var headers: [String : String]? {
        return ["Contect-Type" : "application/json"]
    }
}
