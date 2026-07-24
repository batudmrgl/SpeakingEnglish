import SwiftUI

struct TranscriptBubble: View {
    let message: ConversationMessage

    var body: some View {
        HStack {
            if message.role == .assistant {
                bubble
                Spacer(minLength: 44)
            } else {
                Spacer(minLength: 44)
                bubble
            }
        }
    }

    private var bubble: some View {
        Text(message.text)
            .font(.body)
            .padding(12)
            .background(background, in: RoundedRectangle(cornerRadius: 8))
            .foregroundStyle(message.role == .assistant ? .primary : .white)
    }

    private var background: Color {
        message.role == .assistant ? Color(.secondarySystemBackground) : Color.blue
    }
}

