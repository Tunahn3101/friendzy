//
//  NetworkService.swift
//  friendzy
//
//  Created by Phạm Tuấn Anh on 27/4/26.
//

import Foundation

// MARK: - Network Service
class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    // MARK: - Generic API Call
    func fetch<T: Decodable>(from urlString: String, type: T.Type) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError
        }
        
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    // MARK: - POST Request
    func post<T: Encodable, R: Decodable>(
        to urlString: String,
        body: T,
        responseType: R.Type
    ) async throws -> R {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            throw NetworkError.encodingError
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError
        }
        
        do {
            let decoded = try JSONDecoder().decode(R.self, from: data)
            return decoded
        } catch {
            throw NetworkError.decodingError
        }
    }
}

// MARK: - Network Errors
enum NetworkError: LocalizedError {
    case invalidURL
    case serverError
    case decodingError
    case encodingError
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL không hợp lệ"
        case .serverError:
            return "Lỗi từ server"
        case .decodingError:
            return "Lỗi giải mã dữ liệu"
        case .encodingError:
            return "Lỗi mã hóa dữ liệu"
        case .noData:
            return "Không có dữ liệu"
        }
    }
}
