//
//  MoyaManager.swift
//  Cookify
//
//  Created by Artem Prishepov on 14.06.23.
//

import Foundation
import Moya

protocol MoyaManagerProtocol {
    func getRecipesByType(type: RecipeType, count: Int, offset: Int) async throws -> RecipesByTypeData
    func getRecipeByQuery(query: String) async throws -> [RecipesByQuery]
}

final class MoyaManager: MoyaManagerProtocol {
//    MARK: - Properties
    private let providerSpoonacular: MoyaProvider<SpoonacularApiProvider>
    
    init() {
        providerSpoonacular = MoyaProvider<SpoonacularApiProvider>()
    }
    
//    MARK: - Methods
//    Get Recipes by Type
    func getRecipesByType(type: RecipeType, count: Int, offset: Int) async throws -> RecipesByTypeData {
        return try await withCheckedThrowingContinuation({ continuation in
            providerSpoonacular.request(.getRecipesByType(type: type, count: count, offset: offset)) { result in
                switch result {
                case .success(let response):
                    do {
                        let recipes = try response.map(RecipesByTypeData.self)
                        continuation.resume(returning: recipes)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        })
    }
    
//    Get Recipes by Query
    func getRecipeByQuery(query: String) async throws -> [RecipesByQuery] {
        return try await withCheckedThrowingContinuation({ continuation in
            providerSpoonacular.request(.getRecipeByQuery(query: query)) { result in
                switch result {
                case .success(let response):
                    do {
                        let recipes = try response.map([RecipesByQuery].self)
                        continuation.resume(returning: recipes)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        })
    }
}
