import Foundation

public enum NFCError: Error {
    case unavailable
    case notSupported
    case readOnly
    case invalidPayloadSize
    case invalidated(errorDescription: String)
}
