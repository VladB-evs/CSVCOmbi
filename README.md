# ## **CSV Combiner App**

## 📌 Overview

This macOS application is built using SwiftUI and AppKit. It allows users to select a folder containing CSV files and automatically combine them into a single CSV file, ensuring that the header appears only once.

## ✨ Features

📂 Select a folder containing multiple CSV files

📊 Combine all CSV files into a single file

🏷️ Maintain the header from the first CSV file

💾 Save the combined CSV file in the same folder

✅ Display progress and success/error messages


## ⚙️ Requirements

🖥 macOS 12.0 or later

🛠 Xcode with SwiftUI support


## 🚀 Installation

* Clone this repository: git clone https://github.com/VladB-evs/CSVCOmbi

* Open the project in Xcode.

* Build and run the app on macOS.

* Alternatively, use the CSVCombiAPP file. 


## 📝 Usage

Launch the application.

Click "Select Folder with CSV Files" and choose a directory containing CSV files.

Click "Combine CSVs" to start the merging process.

The application processes the files and creates CombinedCSV.csv in the same folder.

✅ A success message is displayed upon completion.


## 🏗 Code Explanation

1. File Selection

The `openFolderDialog()` function uses `NSOpenPanel` to allow users to choose a folder.

2. Combining CSV Files

The `combineCSVFiles()` function:

* Reads all CSV files in the selected folder.

* Extracts and retains the header from the first file.

* Appends data from subsequent files without duplicating headers.

* Saves the final merged file as CombinedCSV.csv in the same directory.


## ❌ Error Handling

Displays messages if:

* No folder is selected

* No CSV files are found

* A file fails to read


## 📜 License

This project is open-source and available under the MIT License.


## 🤝 Contributions

Feel free to submit issues or pull requests to improve the functionality.


## 👤 Author

Vlad B. - vladbacila5@gmail.com

