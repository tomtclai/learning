import PhotosUI
import SwiftUI

struct MediaCarousel: View {
    /// Describes options the carousel is placed within its superview.
    enum Placement {
        case hero
        case footer

        fileprivate var height: CGFloat {
            switch self {
            case .hero:
                return 150
            case .footer:
                return 100
            }
        }

        fileprivate var span: Int {
            switch self {
            case .hero:
                return 8
            case .footer:
                return 5
            }
        }
    }

    init(
        medias: [Media],
        placement: Placement,
        additionHandler: @escaping (Data) -> Void,
        deletionHandler: @escaping (Media.ID) -> Void
    ) {
        self.medias = medias
        self.placement = placement
        self.additionHandler = additionHandler
        self.deletionHandler = deletionHandler
    }

    private let medias: [Media]
    private let placement: Placement
    private let additionHandler: (Data) -> Void
    private let deletionHandler: (Media.ID) -> Void

    @State private var selected: Media?
    @State private var imageItem: PhotosPickerItem?

    @Environment(\.dismiss) private var dismiss
    @Environment(\.journalService) private var journalService

    // MARK: - Body

    var body: some View {
        content
            .padding(.bottom, 10)
            .onChange(of: imageItem) { _, _ in
                Task {
                    guard let imageData = try? await imageItem?.loadTransferable(type: Data.self) else {
                        return
                    }
                    additionHandler(imageData)
                    imageItem = nil
                }
            }
            .sheet(item: $selected) { selectedMedia in
                MediaGallery(medias: medias, selected: selectedMedia.id)
            }
    }

    // MARK: - Views

    private var scrollView: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 8) {
                ForEach(medias) { media in
                    Button(
                        action: { selected = media },
                        label: {
                            cell(for: media)
                        }
                    )
                    .buttonStyle(.plain)
                }
                imagePickerCell
            }
            .scrollTargetLayout()
            .safeAreaPadding(.horizontal, 20)
        }
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicators(.hidden)
    }

    @ViewBuilder
    private var content: some View {
        if medias.isEmpty && placement == .hero {
            imagePicker
                .padding(.horizontal, 20)
        } else {
            scrollView
        }
    }

    private func cell(for media: Media) -> some View {
        AsyncImage(
            url: media.url,
            content: { image in
                image
                    .resizable()
                    .scaledToFill()
                    .containerRelativeFrame(.horizontal, count: 12, span: placement.span, spacing: 0)
            },
            placeholder: {
                Color.gray.opacity(0.25)
                    .overlay(alignment: .center) {
                        ProgressView()
                    }
                    .containerRelativeFrame(.horizontal, count: 12, span: placement.span, spacing: 0)
            }
        )
        .contextMenu {
            Button("Delete media", systemImage: "trash", role: .destructive) {
                deletionHandler(media.id)
            }
        }
        .frame(height: placement.height)
        .clipShape(RoundedRectangle(cornerRadius: 10.0))
    }

    private var imagePicker: some View {
        PhotosPicker(selection: $imageItem, matching: .images, preferredItemEncoding: .compatible) {
            Color.secondary.opacity(0.2)
                .overlay(alignment: .center) {
                    Label("Add Image", systemImage: "photo.badge.plus")
                        .font(.title)
                        .labelStyle(.iconOnly)
                        .foregroundStyle(Color.accentColor)
                }
        }
        .frame(height: placement.height)
        .clipShape(RoundedRectangle(cornerRadius: 10.0))
    }

    private var imagePickerCell: some View {
        imagePicker
            .containerRelativeFrame(.horizontal, count: 12, span: placement.span, spacing: 0)
    }
}
