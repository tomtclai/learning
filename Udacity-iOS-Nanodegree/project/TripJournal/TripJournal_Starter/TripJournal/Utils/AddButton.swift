import SwiftUI

struct AddButton: View {
    let action: () -> Void

    var body: some View {
        Button(
            action: action,
            label: {
                Image(systemName: "plus")
                    .resizable()
                    .bold()
                    .padding(10)
                    .frame(width: 35, height: 35)
            }
        )
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.circle)
        .shadow(radius: 25)
    }
}
