import MapKit
import SwiftUI

struct EventCell: View {
    let event: Event
    let edit: () -> Void
    let mediaUploadHandler: (Data) -> Void
    let mediaDeletionHandler: (Media.ID) -> Void

    // MARK: - Body

    var body: some View {
        Section(content: content, header: header)
            .scrollTransition { content, phase in
                content
                    .opacity(phase == .bottomTrailing ? 0.5 : 1)
            }
    }

    // MARK: - Header

    func header() -> some View {
        VStack(alignment: .center, spacing: 20) {
            transitionFromPrevious
            title
        }
        .padding(.bottom, 20)
    }

    @ViewBuilder
    var transitionFromPrevious: some View {
        let color = Color.secondary.opacity(0.5)

        VStack(alignment: .center, spacing: 0) {
            if let transition = event.transitionFromPrevious {
                color.frame(width: 2, height: 50)
                Text(transition)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(color.opacity(0.25))
                    .clipShape(Capsule())
                    .font(.caption2)
                    .padding(.vertical, 5)
            }

            color.frame(width: 2, height: 50)

            Image(systemName: "arrowtriangle.down.fill")
                .resizable()
                .frame(width: 15, height: 15)
                .foregroundStyle(color)
        }
    }

    var title: some View {
        VStack(alignment: .center, spacing: 5) {
            Text(event.date, style: .date)
                .font(.caption)
                .fontWidth(.condensed)

            Text(event.name)
                .font(.title2)
                .bold()

            if let note = event.note {
                Text("〝\(note)〞")
                    .fontWeight(.ultraLight)
                    .fontWidth(.compressed)
                    .fontDesign(.serif)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .lineLimit(5)
            }

            Button("Edit", systemImage: "pencil", action: edit)
                .buttonBorderShape(.circle)
                .buttonStyle(.bordered)
                .font(.callout)
                .padding(.top, 10)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, 20)
    }

    // MARK: - Content

    func content() -> some View {
        VStack(alignment: .center, spacing: 10) {
            if let location = event.location {
                map(for: location)
                MediaCarousel(
                    medias: event.medias,
                    placement: .footer,
                    additionHandler: mediaUploadHandler,
                    deletionHandler: mediaDeletionHandler
                )
            } else {
                MediaCarousel(
                    medias: event.medias,
                    placement: .hero,
                    additionHandler: mediaUploadHandler,
                    deletionHandler: mediaDeletionHandler
                )
            }
        }
    }

    @ViewBuilder
    func map(for location: Location) -> some View {
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 0, longitudinalMeters: 0)
        let bounds = MapCameraBounds(centerCoordinateBounds: region, minimumDistance: 250, maximumDistance: .infinity)

        Map(bounds: bounds) {
            Marker(location.address ?? "", coordinate: location.coordinate)
        }
        .mapStyle(.standard(elevation: .realistic))
        .frame(height: 150)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 20)
    }
}
