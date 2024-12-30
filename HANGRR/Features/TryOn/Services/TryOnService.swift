import Foundation

actor TryOnService {
    func captureImage(session: TryOnSession) async throws -> TryOnResult {
        // Implementation for camera capture and image processing would go here
        return TryOnResult(session: session)
    }
} 