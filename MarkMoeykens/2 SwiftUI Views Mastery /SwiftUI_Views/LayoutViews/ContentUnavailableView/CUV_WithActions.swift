// Copyright © 2023 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct CUV_WithActions: View {
    var body: some View {
        ContentUnavailableView(label: {
            Label("Are you sure?", systemImage: "questionmark.circle.fill")
        }, description: {
            Text("This action will permanently delete the item.")
        }, actions: {
            HStack(spacing: 24) {
                Button("Cancel", role: .cancel, action: {})
                Button("Delete", role: .destructive, action: {})
                    .buttonStyle(.borderedProminent)
            }
            .fixedSize()
            .controlSize(.regular)
        })
    }
}

#Preview {
    CUV_WithActions()
}
