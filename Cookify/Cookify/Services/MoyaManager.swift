//
//  MoyaManager.swift
//  Cookify
//
//  Created by Artem Prishepov on 14.06.23.
//

import Foundation
import Moya

protocol MoyaManagerProtocol {
    func getRecipesByType(type: RecipeType, count: Int) async throws -> RecipesByTypeData
}

final class MoyaManager: MoyaManagerProtocol {
//    MARK: - Properties
    private let providerSpoonacular: MoyaProvider<SpoonacularApiProvider>
    
    init() {
        providerSpoonacular = MoyaProvider<SpoonacularApiProvider>()
    }
    
//    MARK: - Methods
//    Get Recipes By Type
    func getRecipesByType(type: RecipeType, count: Int) async throws -> RecipesByTypeData {
        return try await withCheckedThrowingContinuation({ continuation in
            providerSpoonacular.request(.getRecipesByType(type: type, count: count)) { result in
                switch result {
                case .success(let response):
                    do {
                        let recipes = try response.map(RecipesByTypeData.self)
                        continuation.resume(with: .success(recipes))
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(with: .failure(error))
                }
            }
        })
    }
    
}
