//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Rodion Kim on 05/07/2024.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

private enum ApiUrlConstants {
    static let baseUrl = "https://tv-api.com/en/API/Top250Movies/"
    static let privateKey = "k_zcuw1ytf"
}

struct MoviesLoader: MoviesLoading {
    private let networkClient: NetworkRouting
    
    init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: (ApiUrlConstants.baseUrl + ApiUrlConstants.privateKey)) else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, any Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
                case .success(let data):
                    do {
                        let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                        handler(.success(mostPopularMovies))
                    } catch {
                        handler(.failure(error))
                    }
                case .failure(let error):
                    handler(.failure(error))
            }
        }
    }
}
