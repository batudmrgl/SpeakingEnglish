import Foundation

enum AppError: LocalizedError, Equatable {
    case microphonePermissionDenied
    case speechPermissionDenied
    case speechRecognitionUnavailable
    case emptyInput
    case invalidServerResponse
    case networkUnavailable
    case backend(String)
    case unknown

    var errorDescription: String? {
        switch self {
        case .microphonePermissionDenied:
            return "Mikrofon izni verilmedi. Sesli pratik icin Ayarlar'dan mikrofon iznini acmalisin."
        case .speechPermissionDenied:
            return "Konusma tanima izni verilmedi. Sesini metne cevirebilmem icin izin gerekiyor."
        case .speechRecognitionUnavailable:
            return "Konusma tanima su anda kullanilamiyor. Lutfen daha sonra tekrar dene."
        case .emptyInput:
            return "Cevabini anlayamadim. Kisa bir cumleyle tekrar deneyebilirsin."
        case .invalidServerResponse:
            return "Ogretmen cevabi beklenen formatta gelmedi."
        case .networkUnavailable:
            return "Internet baglantisi yok gibi gorunuyor."
        case .backend(let message):
            return message
        case .unknown:
            return "Beklenmeyen bir hata olustu."
        }
    }
}

