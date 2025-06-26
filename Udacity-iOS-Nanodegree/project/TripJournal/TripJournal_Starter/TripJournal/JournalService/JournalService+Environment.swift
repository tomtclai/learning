import SwiftUI

private struct JournalServiceKey: EnvironmentKey {
    static var defaultValue: JournalService = UnimplementedJournalService()
}

extension EnvironmentValues {
    /// A service that can used to interact with the trip journal API.
    var journalService: JournalService {
        get { self[JournalServiceKey.self] }
        set { self[JournalServiceKey.self] = newValue }
    }
}
