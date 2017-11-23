public enum Color {
    case black
    case red
}

extension Color {
    public var symbol: String {
        switch self {
        case .black: return "■"
        case .red:   return "□"
        }
    }
}
