import SwiftUI
import RxCocoa
import RxSwift

class MainViewModel: ObservableObject {
    let disposeBag = DisposeBag()
    @Published var projectList: [ProjectModel] = []
    @Published var isLoading: Bool = true
    let api = Service()
    func getProjectDidTap() {
        isLoading = true
        api.getProject("PUBLIC")
            .asObservable()
            .subscribe(onNext: { data, res in
                switch res {
                case .ok:
                    self.isLoading = false
                    self.projectList = data!.projects
                default:
                    return
                }
            }, onError: {
                print($0)
            }).disposed(by: disposeBag)
    }
}
