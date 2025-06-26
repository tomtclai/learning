import MapKit
import SwiftUI

struct LocationSearchView: View {
    let service: LocationService

    @Binding var query: String
    @Binding var items: [MKMapItem]

    // MARK: - Body

    var body: some View {
        VStack {
            searchTextField
            List(service.results, id: \.self, rowContent: row)
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
        }
        .onChange(of: query) {
            service.search(for: query)
        }
        .padding()
        .interactiveDismissDisabled()
        .presentationDetents([.height(200), .large])
        .presentationBackground(.regularMaterial)
        .presentationBackgroundInteraction(.enabled(upThrough: .large))
    }

    // MARK: - Views

    private var searchTextField: some View {
        TextField("Search", text: $query)
            .textFieldStyle(SearchTextFieldStyle())
            .onSubmit {
                service.search(for: query)
            }
    }

    private func row(for result: MKLocalSearchCompletion) -> some View {
        Button(action: { handleSelection(for: result) }) {
            VStack(alignment: .leading, spacing: 4) {
                Text(result.title)
                    .font(.headline)
                Text(result.subtitle)
                    .font(.subheadline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .listRowBackground(Color.clear)
    }

    // MARK: - Helpers

    private func handleSelection(for result: MKLocalSearchCompletion) {
        Task {
            items = await service.items(for: result)
        }
    }
}

private struct SearchTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        HStack {
            Image(systemName: "magnifyingglass")
            configuration
                .autocorrectionDisabled()
        }
        .padding(12)
        .background(.gray.opacity(0.2))
        .cornerRadius(8)
        .foregroundColor(.primary)
    }
}
