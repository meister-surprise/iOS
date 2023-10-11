import SwiftUI

class ProjectEditorViewModel: ObservableObject {
    @Published var dropView: [ComponentType] = []
    @Published var complementText: String = "State"

    @Published var canvasEditing: Bool = true

    @Published var showHint: Bool = false

    func addBlock(_ block: String) {
        dropView.append(ComponentType.formString(block))
    }

    func removeBlock(_ index: Int) {
        dropView.remove(at: index)
    }

    func removeAll() {
        self.dropView = []
    }
}

