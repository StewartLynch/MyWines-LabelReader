//
//----------------------------------------------
// Original project: MyWines
//
// Follow me on Mastodon: https://iosdev.space/@StewartLynch
// Follow me on Threads: https://www.threads.net/@stewartlynch
// Follow me on Bluesky: https://bsky.app/profile/stewartlynch.bsky.social
// Follow me on X: https://x.com/StewartLynch
// Follow me on LinkedIn: https://linkedin.com/in/StewartLynch
// Email: slynch@createchsol.com
// Subscribe on YouTube: https://youTube.com/@StewartLynch
// Buy me a ko-fi:  https://ko-fi.com/StewartLynch
//----------------------------------------------
// Copyright © 2026 CreaTECH Solutions (Stewart Lynch). All rights reserved.


import PhotosUI
import SwiftData
import SwiftUI

/// Add a new wine or review/edit an existing one. Attach an optional label photo
/// from the camera or Photos and enter the wine details manually.
struct WineDetailView: View {
    @Bindable var wine: Wine
    var isNew = false

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var photoItem: PhotosPickerItem?
    @State private var showingPhotoPicker = false
    @State private var showingCamera = false
    @State private var showingFullScreenImage = false
    @State private var isAnalyzing = false
    @State private var errorMessage: String?
    @FocusState private var focusedField: WineField?

    private var labelImage: UIImage? {
        wine.labelImageData.flatMap(UIImage.init(data:))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Group {
                        if let labelImage {
                            Image(uiImage: labelImage)
                                .resizable()
                                .scaledToFit()
                                .contentShape(.rect)
                                .onTapGesture { showingFullScreenImage = true }
                        } else {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.15))
                                Image(systemName: "wineglass")
                                    .font(.system(size: 48))
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)

                    HStack(spacing: 12) {
                        if CameraPicker.isAvailable {
                            Button("Take Photo", systemImage: "camera") { showingCamera = true }
                                .labelStyle(.iconOnly)
                                .frame(maxWidth: .infinity)
                        }
                        Button("Choose from Photos", systemImage: "photo") { showingPhotoPicker = true }
                            .labelStyle(.iconOnly)
                            .frame(maxWidth: .infinity)
                        if let labelImage, MyWinesAnalyzer.isAvailable {
                            Button {
                                Task { await scan(labelImage)}
                            } label: {
                                if isAnalyzing {
                                    ProgressView()
                                } else {
                                    Label("Scan Label", systemImage: "text.viewfinder")
                                }
                            }
                            .labelStyle(.iconOnly)
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .buttonStyle(.bordered)
                    if !MyWinesAnalyzer.isAvailable {
                        Text("Label scanning needs a device that supports Apple Intelligence.  You can still enter the details manually.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
                .listRowBackground(Color.clear)
                .disabled(isAnalyzing)
                WineFieldsSection(wine: wine, focusedField: $focusedField)
                    .disabled(isAnalyzing)
                if let errorMessage {
                    Section { Label(errorMessage, systemImage: "exclamationmark.triangle") }
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle(isNew ? "Add Wine" : (wine.winery.isEmpty ? "Wine" : wine.winery))
            .navigationBarTitleDisplayMode(.inline)
            .horizontalToolbarsOnly(always: isNew)
            .toolbar {
                // Attached here, not inside the form's rows, so it appears once. The number
                // and decimal pads have no Return key, so give every field a way out.
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") { focusedField = nil }
                }
                if isNew {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { dismiss() }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save", action: save)
                            .disabled(isAnalyzing || wine.winery.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
            }
            .photosPicker(isPresented: $showingPhotoPicker, selection: $photoItem, matching: .images)
            .fullScreenCover(isPresented: $showingCamera) {
                CameraPicker { image in wine.labelImageData = image.jpegData(compressionQuality: 0.8) }
                    .ignoresSafeArea()
            }
            .fullScreenCover(isPresented: $showingFullScreenImage) {
                if let labelImage {
                    LabelImageViewer(image: labelImage)
                }
            }
            .onChange(of: photoItem) { _, item in
                guard let item else { return }
                Task {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        wine.labelImageData = image.jpegData(compressionQuality: 0.8)
                    }
                    photoItem = nil
                }
            }
        }
    }

    private func save() {
        wine.winery = wine.winery.trimmingCharacters(in: .whitespaces)
        wine.wineName = wine.wineName.trimmingCharacters(in: .whitespaces)
        wine.variety = wine.variety.trimmingCharacters(in: .whitespaces)
        wine.country = wine.country.trimmingCharacters(in: .whitespaces)
        wine.region = wine.region.trimmingCharacters(in: .whitespaces)
        if (wine.vintage ?? 0) <= 0 { wine.vintage = nil }
        if (wine.alcoholPercentage ?? 0) <= 0 { wine.alcoholPercentage = nil }
        modelContext.insert(wine)
        dismiss()
    }
    
    func scan(_ image: UIImage) async {
        isAnalyzing = true
        errorMessage = nil
        defer { isAnalyzing = false }
        do {
            let label = try await MyWinesAnalyzer().analyze(image)
            wine.winery = label.winery
            wine.wineName = label.wineName
            wine.variety = label.variety
            wine.country = label.country
            wine.region = label.region
            wine.vintage = label.vintage
            wine.alcoholPercentage = label.alcoholPercentage
        } catch {
            errorMessage = error.localizedDescription + " You can enter the details manually"
        }
    }
}

#Preview("Edit existing wine") {
    WineDetailView(wine: Wine(winery: "Chateau Example", variety: "Cabernet Sauvignon"))
        .modelContainer(for: Wine.self, inMemory: true)
}

#Preview("Add new wine") {
    WineDetailView(wine: Wine(winery: "", variety: ""), isNew: true)
        .modelContainer(for: Wine.self, inMemory: true)
}
