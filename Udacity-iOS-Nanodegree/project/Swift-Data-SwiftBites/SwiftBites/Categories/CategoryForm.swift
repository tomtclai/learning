import SwiftUI

struct CategoryForm: View {
  @Environment(\.modelContext) var modelContext
  enum Mode: Hashable {
    case add
    case edit(Category)
  }
  
  var mode: Mode
  
  init(mode: Mode) {
    self.mode = mode
    switch mode {
    case .add:
      _name = .init(initialValue: "")
      title = "Add Category"
    case .edit(let category):
      _name = .init(initialValue: category.name)
      title = "Edit \(category.name)"
    }
  }
  
  private let title: String
  @State private var name: String
  @State private var error: Error?
  @Environment(\.dismiss) private var dismiss
  @FocusState private var isNameFocused: Bool
  
  // MARK: - Body
  
  var body: some View {
    Form {
      Section {
        TextField("Name", text: $name)
          .focused($isNameFocused)
      }
      if case .edit(let category) = mode {
        Button(
          role: .destructive,
          action: {
            delete(category: category)
          },
          label: {
            Text("Delete Category")
              .frame(maxWidth: .infinity, alignment: .center)
          }
        )
      }
    }
    .onAppear {
      isNameFocused = true
    }
    .onSubmit {
      save()
    }
    .alert(error: $error)
    .navigationTitle(title)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button("Save", action: save)
          .disabled(name.isEmpty)
      }
    }
  }
  
  // MARK: - Data
  
  private func delete(category: Category) {
    modelContext.delete(category)
    dismiss()
  }
  
  private func save() {
    switch mode {
    case .add:
      modelContext.insert(Category(name: name))
    case .edit(let category):
      category.name = name
    }
    dismiss()
    
  }
}
