import Foundation
import VismaSignLibrary

// MARK: - Project

let apiService: APIServiceManager = APIServiceManagerImpl()
let request = FetchMockDataRequest()
apiService.perform(request: request) { result in
    if case let .failure(error) = result {
        print(error)
    }
}

