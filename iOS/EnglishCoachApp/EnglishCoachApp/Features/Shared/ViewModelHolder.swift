import Foundation

@MainActor
final class ViewModelHolder<Value>: ObservableObject {
    @Published var value: Value?
}

