import SwiftUI
import AppGPTLang
import RxSwift
import RxCocoa

class ProjectEditorViewModel: ObservableObject {
    let disposeBag = DisposeBag()
    @Published var dropView: [ComponentType] = []
    @Published var text: String = ""
    @Published var code: String = ""
    @Published var color: Color = .blue
    @Published var scope: String = ""
    @Published var prompt: String = ""
    @Published var isLoading: Bool = true
    @Published var isGeneratorPresented: Bool = false
    @Published var selection: Int = 0
    @Published var isDelete: Bool = false
    let api = Service()
    func addBlock(_ block: String) {
        dropView.append(ComponentType.formString(block))
    }

    func removeBlock(_ index: Int) {
        dropView.remove(at: index)
    }

    func removeAll() {
        self.dropView = []
    }
    
    func getTypes(_ rawCode: String, isChatGpt: Bool = false) -> [ComponentType] {
        if isChatGpt {
            let codes: [ComponentType?] = rawCode.splitLines().dropFirst().map { line in
                let cmd = line.splitOpcode()
                guard let opcode = Component.ComponentType(rawValue: cmd.0) else { return nil }
                let operands = cmd.1.quoteAwareSplit().map { $0.trim() }
                switch opcode {
                case .button:
                    let action = operands[0].cut().components(separatedBy: ";")
                    var execute: ComponentType.Action = .open(url: "")
                    if !action[0].isEmpty {
                        let cmd = action[0].splitOpcode()
                        switch cmd.0 {
                        case "var":
                            let split = cmd.1.components(separatedBy: "=")
                            execute = .variable(key: split[0], value: split.last!)
                        case "open":
                            execute = .open(url: cmd.1)
                        default:
                            break
                        }
                    }
                    return ComponentType.button(action: execute, text: operands[1], color: operands[2].getColor())
                case .text:
                    var string: ComponentType.Text = .constant(value: "")
                    if operands[0].starts(with: "$") {
                        string = .variable(key: String(operands[0].dropFirst()))
                    } else {
                        string = .constant(value: String(operands[0]))
                    }
                    guard let temp = Float(operands[1]) else { return nil }
                    return ComponentType.text(text: string, size: CGFloat(temp), color: operands[2].getColor())
                case .image:
                    return ComponentType.image(url: operands[0])
                case .spacer:
                    return ComponentType.spacer
                }
            }
            return codes.compactMap {
                if let value = $0 {
                    return value
                } else {
                    return nil
                }
            }
        } else {
            let codes: [ComponentType?] = rawCode.splitLines().map { line in
                let cmd = line.splitOpcode()
                guard let opcode = Component.ComponentType(rawValue: cmd.0) else { return nil }
                let operands = cmd.1.quoteAwareSplit().map { $0.trim() }
                switch opcode {
                case .button:
                    let action = operands[0].cut().components(separatedBy: ";")
                    var execute: ComponentType.Action = .open(url: "")
                    if !action[0].isEmpty {
                        let cmd = action[0].splitOpcode()
                        switch cmd.0 {
                        case "var":
                            let split = cmd.1.components(separatedBy: "=")
                            execute = .variable(key: split[0], value: split.last!)
                        case "open":
                            execute = .open(url: cmd.1)
                        default:
                            break
                        }
                    }
                    return ComponentType.button(action: execute, text: operands[1], color: operands[2].getColor())
                case .text:
                    var string: ComponentType.Text = .constant(value: "")
                    if operands[0].starts(with: "$") {
                        string = .variable(key: String(operands[0].dropFirst()))
                    } else {
                        string = .constant(value: String(operands[0]))
                    }
                    guard let temp = Float(operands[1]) else { return nil }
                    return ComponentType.text(text: string, size: CGFloat(temp), color: operands[2].getColor())
                case .image:
                    return ComponentType.image(url: operands[0])
                case .spacer:
                    return ComponentType.spacer
                }
            }
            return codes.compactMap {
                if let value = $0 {
                    return value
                } else {
                    return nil
                }
            }
        }
    }
    
    func getDetailDidTap(id: Int) {
        api.getProjectDetail(id)
            .asObservable()
            .subscribe(onNext: { data, res in
                switch res {
                case .ok:
                    self.text = data!.title
                    self.dropView = self.getTypes(data!.code)
                    self.color = data!.color.getColor()
                    self.scope = data!.scope
                    self.isLoading = false
                default:
                    return
                }
            }).disposed(by: disposeBag)
    }

    func patchDetailDidTap(id: Int) {
        api.patchProjectDetail(id, "김희망", text, color.toKeyword, code, scope)
            .asObservable()
            .subscribe(onNext: { res in
                switch res {
                case .deleteOk:
                    print("업데이트 성공")
                default:
                    print(res)
                    return
                }
            }).disposed(by: disposeBag)
    }
    
    func generatePromptDidTap() {
        api.getGeneratedCode(prompt)
            .asObservable()
            .subscribe(onNext: { data, res in
                switch res {
                case .ok:
                    print(data!.response)
                    self.dropView = self.getTypes(data!.response, isChatGpt: true)
                    self.isGeneratorPresented = false
                default:
                    return
                }
            }).disposed(by: disposeBag)
    }
    func deleteProjectDidTap(id: Int) {
        api.deleteProject(id)
            .asObservable()
            .subscribe(onNext: { res in
                switch res {
                case .deleteOk:
                    print("delete")
                default:
                    return
                }
            }).disposed(by: disposeBag)
    }
}

