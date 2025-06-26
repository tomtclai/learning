import Combine
import Foundation
import SwiftUI

func ?? <T>(lhs: Binding<T?>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}

extension View {
    func alert(error: Binding<Error?>) -> some View {
        alert(isPresented: Binding<Bool>(
            get: { error.wrappedValue != nil },
            set: { if !$0 { error.wrappedValue = nil } }
        )) {
            Alert(
                title: Text("Error"),
                message: Text(error.wrappedValue?.localizedDescription ?? "An unknown error occurred."),
                dismissButton: .default(Text("Dismiss"))
            )
        }
    }
}

struct LoadingOverlayModifier: ViewModifier {
    var isLoading: Bool

    func body(content: Content) -> some View {
        content
            .overlay {
                if isLoading {
                    ProgressView("Loading…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea()
                        .background(Material.regular.opacity(0.85))
                }
            }
    }
}

extension View {
    func loadingOverlay(_ isLoading: Bool) -> some View {
        modifier(LoadingOverlayModifier(isLoading: isLoading))
    }
}

extension Collection {
    var nonEmpty: Self? {
        return isEmpty ? nil : self
    }
}
