import SwiftUI

struct AuthView: View {
    /// Describes validation errors that might occur locally in the form.
    struct ValidationError: LocalizedError {
        var errorDescription: String?

        static let emptyUsername = Self(errorDescription: "Username is required.")
        static let emptyPassword = Self(errorDescription: "Password is required.")
    }

    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoading = false
    @State private var error: Error?

    @Environment(\.journalService) private var journalService

    // MARK: - Body

    var body: some View {
        Form {
            Section(
                content: inputs,
                header: header,
                footer: buttons
            )
        }
        .loadingOverlay(isLoading)
        .alert(error: $error)
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
        TextField("Username", text: $username)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .textContentType(.username)
        SecureField("Password", text: $password)
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
                        await register()
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

    private func validateForm() throws {
        if username.nonEmpty == nil {
            throw ValidationError.emptyUsername
        }
        if password.nonEmpty == nil {
            throw ValidationError.emptyPassword
        }
    }

    private func logIn() async {
        isLoading = true
        do {
            try validateForm()
            try await journalService.logIn(username: username, password: password)
        } catch {
            self.error = error
        }
        isLoading = false
    }

    private func register() async {
        isLoading = true
        do {
            try validateForm()
            try await journalService.register(username: username, password: password)
        } catch {
            self.error = error
        }
        isLoading = false
    }
}
