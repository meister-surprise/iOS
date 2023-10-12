import SwiftUI
import RxSwift
import RxCocoa

class CreateViewModel: ObservableObject {
    let disposeBag = DisposeBag()
    @Published var title: String = ""
    @Published var selection: Int = 0
    @Published var color: Color = .blue
    func createProjectDidTap() {
        let api = Service()
        api.postProject("김희망", title, color.toKeyword, "", selection == 0 ? "PUBLIC" : "PRIVATE")
            .asObservable()
            .subscribe(onNext: { res in
                switch res {
                case .createOk:
                    print("asdf")
                default:
                    return
                }
            }).disposed(by: disposeBag)
    }
    
    func changeProjectDidTap(id: Int, code: String) {
        let api = Service()
        api.patchProjectDetail(id, "김희망", title, color.toKeyword, code, selection == 0 ? "PUBLIC" : "PRIVATE")
            .asObservable()
            .subscribe(onNext: { res in
                switch res {
                case .deleteOk:
                    print("Sdf")
                default:
                    return
                }
            }).disposed(by: disposeBag)
        
    }
    
    func deleteProjectDidTap() {
        
    }
}

