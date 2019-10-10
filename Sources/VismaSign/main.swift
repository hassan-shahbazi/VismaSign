import Foundation
import VismaSignClient

func fetchAccessToken() {
    let apiService: VismaSignClientPartner = VismaSignClientImpl()
    do {
        try apiService.fetchAccessToken(clientID: "57b22247-2bce-4dec-9e5f-3b5d895c1687", clientSecret: "XkhbP8UpK7vUy5zLwEU1yfswHTyIt1SR") { result in
            switch result {
                case .success(let accessToken):
                    print("Service call respons: \(accessToken.accessToken)")
                case .failure(let error):
                    print("Service call error: \(error)")
            }
        }
    } catch {
        print("Service initalization error: \(error)")
    }
}
