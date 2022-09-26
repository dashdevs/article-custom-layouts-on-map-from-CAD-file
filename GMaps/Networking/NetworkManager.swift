//
//  NetworkManager.swift
//  GMaps
//
//  Created by yurii on 28.07.2022.
//

import Foundation
import Combine

//MARK: -  Errors
enum NetworkError: Error {
    case error(err: String)
    case invalidResponse(response: String)
    case invalidData
    case decodingError(err: String)
    case statusCode(HTTPURLResponse)
    case unknown
}

class NetworkManager<T: Decodable>: ObservableObject { 
    var storage = Set<AnyCancellable>()
    let result = PassthroughSubject<T, Never>()
    let error = PassthroughSubject<NetworkError, Never>()
    
    private let decoder: JSONDecoder = { // date decoding strategy
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
    
    //MARK: -  Methods
    
    func decodeResponse<T: Decodable>(data: Data, response: URLResponse) throws -> T {
        print("------ response received: \(String(describing: String(data: data, encoding: .utf8)))")
        if let response = response as? HTTPURLResponse,
           (200..<300).contains(response.statusCode) == false {
            throw NetworkError.statusCode(response)
        }
        
        return try decoder.decode(T.self, from: data)
    }
    
    func mapResponseError(_ error: Error) -> NetworkError {
        switch error {
        case is URLError:
            return .error(err: error.localizedDescription)
        case is DecodingError:
            print("Decoding error is \(error).")
            return .decodingError(err: error.localizedDescription)
        default:
            return .unknown
        }
    }
    
    func call<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Never> { // error type erased to never by catching error and sending to error subject
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap(decodeResponse)
            .mapError(mapResponseError)
            .receive(on: RunLoop.main)
            .catch { [weak self] error -> Empty in
                self?.error.send(error)
                return Empty(completeImmediately: true)
            }
            .eraseToAnyPublisher()
    }
    
    func call(_ request: URLRequest) { // call for common use with one request
        call(request)
            .sink { [weak self] in
                self?.result.send($0)
            }
            .store(in: &storage)
    }
}
