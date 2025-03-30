import Foundation


// NOTE: if url has http parameters when passed in, they will be removed and replaces by (parameters: Optional<[String: String]>)
func betterWayToRetrieve(url: String, parameters: Optional<[String: String]>) async -> Result<Data, Error> {
    guard var urlComponents = URLComponents(string: url) else {
        return .failure(URLError(.badURL))
    }
    
    urlComponents.queryItems = parameters?.map { URLQueryItem(name: $0.key, value: $0.value) }
    
    guard let url = urlComponents.url else {
        return .failure(URLError(.badURL))
    }
    
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        return .success(data)
    }
    catch {
        return .failure(error)
    }
}





