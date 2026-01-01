import ExpoModulesCore
import SwiftUI
import FaceLiveness
import ExpoAwsLivenessView

public class ExpoAwsLivenessModule: Module {
    // Store the configured region for liveness sessions
    private var configuredRegion: String?

    public func definition() -> ModuleDefinition {
        Name("ExpoAwsLiveness")

        Events("onFaceLivenessResult")

        // Configure AWS credentials
        AsyncFunction("configure") { (config: [String: String]) -> Void in
            guard let region = config["region"],
                  let identityPoolId = config["identityPoolId"] else {
                throw ExpoAwsLivenessError.invalidConfiguration
            }

            // Store region and identity pool ID for later use
            self.configuredRegion = region
            // Note: FaceLivenessDetectorView handles Cognito auth automatically
            // when provided with region - it uses the identity pool from Amplify configuration

            print("AWS FaceLiveness configured with region: \(region), identityPool: \(identityPoolId)")
        }

        // Start face liveness detection session
        AsyncFunction("startLivenessSession") { (sessionId: String, promise: Promise) in
            guard let region = self.configuredRegion else {
                promise.reject(ExpoAwsLivenessError.notConfigured)
                return
            }

            DispatchQueue.main.async {
                self.presentFaceLivenessView(sessionId: sessionId, region: region, promise: promise)
            }
        }
    }

    private func presentFaceLivenessView(sessionId: String, region: String, promise: Promise) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            promise.reject(ExpoAwsLivenessError.noRootViewController)
            return
        }

        // Find the topmost presented view controller
        var topController = rootViewController
        while let presentedController = topController.presentedViewController {
            topController = presentedController
        }

        // Create the SwiftUI view with FaceLiveness
        let livenessView = ExpoAwsLivenessView(
            sessionId: sessionId,
            region: region
        ) { result in
            // Dismiss the view controller
            DispatchQueue.main.async {
                topController.dismiss(animated: true)
            }

            // Resolve the promise
            switch result {
            case .success:
                promise.resolve([
                    "isLive": true,
                    "sessionId": sessionId
                ])
            case .failure(let error):
                let (errorCode, errorMessage) = self.mapFaceLivenessError(error)
                promise.resolve([
                    "isLive": false,
                    "sessionId": sessionId,
                    "errorCode": errorCode,
                    "errorMessage": errorMessage
                ])
            }
        }

        // Create hosting controller and present
        let hostingController = UIHostingController(rootView: livenessView)
        hostingController.modalPresentationStyle = .fullScreen
        hostingController.modalTransitionStyle = .coverVertical

        topController.present(hostingController, animated: true)
    }

    private func mapFaceLivenessError(_ error: FaceLivenessDetectionError) -> (String, String) {
        switch error {
        case .sessionNotFound:
            return ("SESSION_NOT_FOUND", "The liveness session was not found")
        case .accessDenied:
            return ("CAMERA_PERMISSION_DENIED", "Camera access was denied")
        case .cameraPermissionDenied:
            return ("CAMERA_PERMISSION_DENIED", "Camera permission was denied")
        case .userCancelled:
            return ("USER_CANCELLED", "User cancelled the liveness check")
        case .sessionTimedOut:
            return ("SESSION_EXPIRED", "The liveness session timed out")
        case .validation(let message):
            return ("VALIDATION_FAILED", message)
        case .unknown(let message):
            return ("UNKNOWN_ERROR", message)
        case .socketClosed:
            return ("NETWORK_ERROR", "Connection to server was lost")
        case .invalidSignature:
            return ("VALIDATION_FAILED", "Invalid request signature")
        case .faceInOvalMatchExceededTimeLimitError:
            return ("FACE_NOT_DETECTED", "Face was not detected in time")
        case .multipleFaces:
            return ("MULTIPLE_FACES_DETECTED", "Multiple faces were detected")
        case .cameraNotAvailable:
            return ("CAMERA_NOT_AVAILABLE", "Camera is not available")
        case .invalidRegion:
            return ("INVALID_REGION", "The region provided is invalid")
        case .internalServer:
            return ("SERVER_ERROR", "Internal server error")
        case .throttling:
            return ("THROTTLED", "Request was throttled")
        case .serviceQuotaExceeded:
            return ("QUOTA_EXCEEDED", "Service quota exceeded")
        case .serviceUnavailable:
            return ("SERVICE_UNAVAILABLE", "Service is unavailable")
        @unknown default:
            return ("UNKNOWN_ERROR", "An unknown error occurred")
        }
    }


    private func mapError(_ error: Error) -> (String, String) {
        // Placeholder error mapping - implement based on your actual error types
        return ("UNKNOWN_ERROR", error.localizedDescription)
    }
}

// MARK: - Custom Errors

enum ExpoAwsLivenessError: Error, LocalizedError {
    case invalidConfiguration
    case configurationFailed(String)
    case notConfigured
    case noRootViewController
    
    var errorDescription: String? {
        switch self {
        case .invalidConfiguration:
            return "Invalid configuration: region and identityPoolId are required"
        case .configurationFailed(let message):
            return "Amplify configuration failed: \(message)"
        case .notConfigured:
            return "Module not configured. Call configure() first"
        case .noRootViewController:
            return "Could not find root view controller"
        }
    }
}

