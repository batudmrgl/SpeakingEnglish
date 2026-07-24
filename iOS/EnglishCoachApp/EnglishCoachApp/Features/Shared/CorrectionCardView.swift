import SwiftUI

struct CorrectionCardView: View {
    let correction: Correction

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Kisa duzeltme", systemImage: "checkmark.seal")
                .font(.headline)
                .foregroundStyle(.blue)

            VStack(alignment: .leading, spacing: 6) {
                Text("Söylediğin")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(correction.original)
                    .font(.body)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Doğru kullanım")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(correction.corrected)
                    .font(.body.weight(.semibold))
            }

            Text(correction.explanationTR)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if let naturalAlternative = correction.naturalAlternative {
                Text("Daha doğal: \(naturalAlternative)")
                    .font(.subheadline)
            }
        }
        .padding()
        .background(.blue.opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
    }
}

