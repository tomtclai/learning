if CommandLine.arguments.count != 2 {
	print("Usage: swift Hello.swift NAME")
} else {
	print("Hello \(CommandLine.arguments[1])")
}