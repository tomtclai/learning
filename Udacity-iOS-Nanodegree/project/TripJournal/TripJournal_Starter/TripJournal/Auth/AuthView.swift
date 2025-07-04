import SwiftUI
struct ValidationError: LocalizedError {
    var errorDescription: String?

    static let emptyUsername = Self(errorDescription: "Username is required.")
    static let emptyPassword = Self(errorDescription: "Password is required.")
    static let signedOut = Self(errorDescription: "Authorization is required.")
}

struct AuthView: View {
    @State private var vm: AuthViewModel
    let onAuth: (Bool) -> Void
    @EnvironmentObject private var service: LiveJournalService

    init(onAuth: @escaping (Bool) -> Void) {
        self.onAuth = onAuth
        self.vm = AuthViewModel()
    }
    // MARK: - Body

    var body: some View {
        Form {
            Section(
                content: inputs,
                header: header,
                footer: buttons
            )
        }
        .loadingOverlay(vm.isLoading)
        .alert(error: $vm.error)
        .onAppear {
            vm.journalService = service
        }
    }

    // MARK: - Views

    private func header() -> some View {
        Image(.authHeader)
            .resizable()
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 30)
            .padding(.bottom, 70)
    }

    @ViewBuilder
    private func inputs() -> some View {
        TextField("Username", text: $vm.username)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .textContentType(.username)
        SecureField("Password", text: $vm.password)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .textContentType(.password)
    }

    private func buttons() -> some View {
        VStack(alignment: .center, spacing: 10) {
            Button(
                action: {
                    Task {
                        await logIn()
                        
                    }
                },
                label: {
                    Text("Log In")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            )
            .buttonBorderShape(.capsule)
            .buttonStyle(.borderedProminent)

            Button(
                action: {
                    Task {
                        await vm.register()
                    }
                },
                label: {
                    Text("Create Account")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            )
            .buttonBorderShape(.capsule)
            .buttonStyle(.bordered)
        }
        .padding()
    }

    // MARK: - Networking
    private func logIn() async {
        Task {
            await self.vm.logIn()
        }
    }

}


class AuthViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoading = false
    @Published var error: Error?
    @Published var isAuthenticated = false
    var journalService: JournalService?


    private func validate() throws {
        if username.nonEmpty == nil {
            throw ValidationError.emptyUsername
        }
        if password.nonEmpty == nil {
            throw ValidationError.emptyPassword
        }
    }

    func logIn() async -> Bool {
        isLoading = true
        do {
            try validate()
            try await journalService?.logIn(username: username, password: password)
            isLoading = false
            return true
        } catch {
            self.error = error
            isLoading = false
            return false
        }
        
    }

    
    func register() async {
        isLoading = true
        do {
            try validate()
            try await journalService?.register(username: username, password: password)
        } catch {
            self.error = error
        }
        isLoading = false
    }
}
