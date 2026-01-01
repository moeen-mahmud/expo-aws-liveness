import ExpoModulesCore
import SwiftUI
import FaceLiveness

struct ExpoAwsLivenessView: View {
    let sessionId: String
    let region: String
    let onCompletion: (Result<Void, FaceLivenessDetectionError>) -> Void

    @State private var isPresented = true

    var body: some View {
        FaceLivenessDetectorView(
            sessionID: sessionId,
            region: region,
            isPresented: $isPresented,
            onCompletion: { result in
                onCompletion(result)
            }
        )
    }
}
