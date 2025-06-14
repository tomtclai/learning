import SwiftUI

struct IngredientForm: View {
  @Environment(\.modelContext) var modelContext
  enum Mode: Hashable {
    case add
    case edit(Ingredient)
  }
  
  var mode: Mode
  
  init(mode: Mode) {
    self.mode = mode
    switch mode {
    case .add:
      _name = .init(initialValue: "")
      title = "Add Ingredient"
    case .edit(let ingredient):
      _name = .init(initialValue: ingredient.name)
      title = "Edit \(ingredient.name)"
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
      if case .edit(let ingredient) = mode {
        Button(
          role: .destructive,
          action: {
            delete(ingredient: ingredient)
          },
          label: {
            Text("Delete Ingredient")
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
  
  private func delete(ingredient: Ingredient) {
    modelContext.delete(ingredient)
    dismiss()
  }
  
  private func save() {
    switch mode {
    case .add:
      modelContext.insert(Ingredient(name: name))
    case .edit(let ingredient):
      ingredient.name = name
    }
    dismiss()
  }
}
