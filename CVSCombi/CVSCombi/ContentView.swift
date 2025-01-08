import SwiftUI
import AppKit
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var folderURL: URL?
    @State private var isProcessing = false
    @State private var successMessage = ""
    @State private var errorMessage = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Combine CSV Files")
                .font(.title)
                .padding()

            Button("Select Folder with CSV Files") {
                folderURL = openFolderDialog()
            }
            .padding()

            if let folderURL = folderURL {
                Text("Selected Folder: \(folderURL.path)")
                    .font(.footnote)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }

            Button("Combine CSVs") {
                combineCSVFiles()
            }
            .padding()
            .disabled(folderURL == nil || isProcessing)

            if isProcessing {
                ProgressView("Processing...")
            }

            if !successMessage.isEmpty {
                Text(successMessage)
                    .foregroundColor(.green)
            }

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }

    func openFolderDialog() -> URL? {
        let dialog = NSOpenPanel()
        dialog.canChooseDirectories = true
        dialog.canChooseFiles = false
        dialog.allowsMultipleSelection = false

        return dialog.runModal() == .OK ? dialog.url : nil
    }

    func combineCSVFiles() {
        guard let folderURL = folderURL else {
            DispatchQueue.main.async {
                self.errorMessage = "Please select a folder with CSV files."
            }
            return
        }

        isProcessing = true
        successMessage = ""
        errorMessage = ""

        DispatchQueue.global(qos: .background).async {
            do {
                let fileManager = FileManager.default
                let allFiles = try fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)
                let csvFiles = allFiles.filter { $0.pathExtension.lowercased() == "csv" }

                if csvFiles.isEmpty {
                    throw NSError(domain: "No CSV files found in the selected folder.", code: 1, userInfo: nil)
                }

                var combinedContent = ""
                var isFirstFile = true
                var header: String? = nil

                for csvFile in csvFiles {
                    do {
                        let content = try String(contentsOf: csvFile, encoding: .utf8)
                        let lines = content.split(separator: "\n", omittingEmptySubsequences: true)

                        if let firstLine = lines.first {
                            if isFirstFile {
                                header = String(firstLine)
                                combinedContent += header! + "\n"
                            }

                            let dataLines = lines.dropFirst()
                            combinedContent += dataLines.joined(separator: "\n") + "\n"
                        }
                        isFirstFile = false
                    } catch {
                        throw NSError(domain: "Failed to read file: \(csvFile.lastPathComponent)", code: 2, userInfo: nil)
                    }
                }

                let combinedFileName = "CombinedCSV.csv"
                let saveURL = folderURL.appendingPathComponent(combinedFileName)

                try combinedContent.write(to: saveURL, atomically: true, encoding: .utf8)

                DispatchQueue.main.async {
                    self.isProcessing = false
                    self.successMessage = "Successfully combined \(csvFiles.count) CSV files! Saved as '\(combinedFileName)'."
                }
            } catch {
                DispatchQueue.main.async {
                    self.isProcessing = false
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
