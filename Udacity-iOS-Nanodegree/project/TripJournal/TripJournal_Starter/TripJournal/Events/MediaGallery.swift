import SwiftUI

struct MediaGallery: View {
    let medias: [Media]
    let selected: Media.ID?

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach(medias, content: cell)
                }
            }
            .ignoresSafeArea()
            .scrollTargetBehavior(.paging)
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
            .onAppear {
                // Solves a bug where scroll view needs a delay to scroll to selected id.
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if let selectedId = selected {
                        proxy.scrollTo(selectedId, anchor: .center)
                    }
                }
            }
        }
    }

    // MARK: - Views

    private func cell(for media: Media) -> some View {
        AsyncImage(
            url: media.url,
            content: { imageView in
                imageView
                    .resizable()
                    .scaledToFit()
            },
            placeholder: {
                ProgressView()
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding()
        .containerRelativeFrame([.horizontal, .vertical])
        .ignoresSafeArea()
        .id(media.id)
    }
}
