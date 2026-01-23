//
//  ImageLoader.swift
//  PepeWorld
//
//  Created by 정재성 on 1/22/26.
//

import Foundation

struct ImageLoader: Sendable {
  private let headers = [
    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Referer": "https://duckduckgo.com/"
  ]

  private func fetchVQD(query: String) async throws -> some StringProtocol {
    var components = URLComponents(string: "https://duckduckgo.com/")!
    components.queryItems = [URLQueryItem(name: "q", value: query)]

    var request = URLRequest(url: components.url!)
    request.allHTTPHeaderFields = headers

    let (data, _) = try await URLSession.shared.data(for: request)
    let html = String(data: data, encoding: .utf8) ?? ""
    guard let match = html.firstMatch(of: /vqd=['"]?(?<token>[\d-]+)['"]?/) else {
      throw NSError(domain: "VQDNotFound", code: 404)
    }
    return match.token
  }

  func images() async throws -> [ImageItem] {
    let query = "Pepe the frog"
    let vqd = try await fetchVQD(query: query)
    var components = URLComponents(string: "https://duckduckgo.com/i.js")!
    components.queryItems = [
      URLQueryItem(name: "q", value: query),
      URLQueryItem(name: "o", value: "json"),
      URLQueryItem(name: "vqd", value: "\(vqd)"),
      URLQueryItem(name: "f", value: ",,,,,"),
      URLQueryItem(name: "p", value: "1")
    ]

    var request = URLRequest(url: components.url!)
    request.allHTTPHeaderFields = headers

    let (data, _) = try await URLSession.shared.data(for: request)
    let resultData = try JSONDecoder().decode(DDGResponse.self, from: data)
    return resultData.results
  }
}

extension ImageLoader {
  private struct DDGResponse: Decodable {
    let results: [ImageItem]
  }
}

extension ImageLoader {
  struct ImageItem: Decodable, Hashable {
    let image: URL
    let thumbnail: URL
    let title: String
  }
}
