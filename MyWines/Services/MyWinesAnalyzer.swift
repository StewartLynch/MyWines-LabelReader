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


import FoundationModels
import UIKit
import Vision

struct MyWinesAnalyzer {
    static var isAvailable: Bool {
        let model = SystemLanguageModel.default
        guard case .available = model.availability else { return false }
        return model.capabilities.contains(.vision)
    }
    
    enum AnalyseError: LocalizedError {
        case unreadableImage
        case noTextFound
        case deviceNotEligible
        case notReady
        case cannotReadImages
        
        var errorDescription: String? {
            switch self {
                case .unreadableImage: "The image could not be read."
                case .noTextFound: "No text was found on the label. Try a sharper, better-lit photo."
                case .deviceNotEligible: "Label scanning needs a device that supports Apple Intelligence."
                case .notReady: "Apple Intelligence isn't ready yet. Try again in a moment."
                case .cannotReadImages: "The on-device model can't read images here."
            }
        }
    }
    
    private func recognizeText(in image: CGImage) async throws -> [String] {
        var request = RecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        let observations = try await request.perform(on: image)
        return observations.compactMap({$0.topCandidates(1).first?.string})
    }
    
    func extractWithModel(
        _ model:SystemLanguageModel,
        cgImage: CGImage,
        lines: [String]
    ) async throws -> ExtractedWineInfo {
        let session = LanguageModelSession(model: model, instructions: """
            You read wine bottle labels. Extract the winery, the named wine or bottling line (if any),grape variety, vintage year, alcohol percentage, country and region. Use only what is printed on the label. Never invent values; leave optional fields empty when they are absent.
            """)
        let ocrText = lines.joined(separator: "\n")
        let response = try await session.respond(generating: ExtractedWineInfo.self) {
            "Here is a photo of the wine label:"
            Attachment(cgImage)
            "Text recognition on the label, top to bottom: \n\(ocrText)"
        }
        return response.content
    }
    
    func analyze(_ image: UIImage) async throws -> ExtractedWineInfo {
        guard let cgImage = image.prepareForAnalysis() else {
            throw AnalyseError.unreadableImage
        }
        let lines = try await recognizeText(in: cgImage)
        guard !lines.isEmpty else { throw AnalyseError.noTextFound }
        let model = SystemLanguageModel.default
        switch model.availability {
        case .available:
            break
        case .unavailable(.deviceNotEligible):
            throw AnalyseError.deviceNotEligible
        case .unavailable:
            throw AnalyseError.notReady
        }
        guard model.capabilities.contains(.vision) else {
            throw AnalyseError.cannotReadImages
        }
        return try await extractWithModel(
            model,
            cgImage: cgImage,
            lines:  lines
        ).sanitized()
    }
}

extension UIImage {
    func prepareForAnalysis(maximumDimension: CGFloat = 2048) -> CGImage? {
        let scale = min(1, maximumDimension / max(size.width, size.height))
        let size = CGSize(width: size.width * scale, height: size.height * scale)
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        let newImage = UIGraphicsImageRenderer(size: size, format: format)
            .image { _ in
                draw(in: CGRect(origin: .zero, size: size))
            }
            .cgImage
        return newImage
    }
}

extension ExtractedWineInfo {
    func sanitized() -> ExtractedWineInfo {
        var copy = self
        let currentYear = Calendar.current.component(.year, from: .now)
        if let vintage, !(1900...currentYear).contains(vintage) { copy.vintage = nil }
        if let alcoholPercentage, !(0.5...30).contains(alcoholPercentage) { copy.alcoholPercentage = nil}
        return copy
    }
}
