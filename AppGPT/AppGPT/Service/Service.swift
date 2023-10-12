import Foundation
import RxSwift
import RxCocoa
import RxMoya
import Moya

final class Service {
    let provider = MoyaProvider<API>(plugins: [MoyaLoggingPlugin()])
    
    func postProject(_ username: String, _ title: String, _ color: String, _ code: String, _ scope: String) -> Single<networkingResult> {
        return provider.rx.request(.postProject(userName: username, title: title, color: color, code: code, scope: scope))
            .filterSuccessfulStatusCodes()
            .map { _ -> networkingResult in
                return .createOk
            }
    }
    func getProject(_ scope: String) -> Single<(ProjectListModel?, networkingResult)> {
        return provider.rx.request(.getProjectList(scope: scope))
            .filterSuccessfulStatusCodes()
            .map(ProjectListModel.self)
            .map{return ($0, .ok)}
            .catch { error in
                print(error)
                return .just((nil, .fault))
            }
    }
    func getProjectDetail(_ id: Int) -> Single<(ProjectDetailModel?, networkingResult)> {
        return provider.rx.request(.getProjectDetail(id: id))
            .filterSuccessfulStatusCodes()
            .map(ProjectDetailModel.self)
            .map{return ($0, .ok)}
            .catch { error in
                print(error)
                return .just((nil, .fault))
            }
    }
    func patchProjectDetail(_ id: Int, _ username: String, _ title: String, _ color: String, _ code: String, _ scope: String) -> Single<networkingResult> {
        return provider.rx.request(.patchProjectDetail(id: id, username: username, title: title, color: color, code: code, scope: scope))
            .filterSuccessfulStatusCodes()
            .map { _ -> networkingResult in
                return .deleteOk
            }
            .catch { error in
                print(error)
                return .just(.fault)
            }
    }
    func getGeneratedCode(_ prompt: String) -> Single<(promptModel?, networkingResult)> {
        return provider.rx.request(.getGeneratedCode(prompt: prompt))
            .filterSuccessfulStatusCodes()
            .map(promptModel.self)
            .map{return ($0, .ok)}
            .catch { error in
                print(error)
                return .just((nil, .fault))
            }
    }
    func deleteProject(_ id: Int) -> Single<networkingResult> {
        return provider.rx.request(.deleteProject(id: id))
            .filterSuccessfulStatusCodes()
            .map { _ -> networkingResult in
                return .deleteOk
            }
    }
    func setNetworkError(_ error: Error) -> networkingResult {
        print(error)
        print(error.localizedDescription)
        guard let status = (error as? MoyaError)?.response?.statusCode else { return (.fault) }
        return (networkingResult(rawValue: status) ?? .fault)
    }
}
