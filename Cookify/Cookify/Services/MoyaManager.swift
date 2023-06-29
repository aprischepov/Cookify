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
    func getRecipeInformationById(id: Int) async throws -> RecipeById
    func getRecipeRandom() async throws -> RecipeRandom
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
    
//    Get Recipe Info by Id
    func getRecipeInformationById(id: Int) async throws -> RecipeById {
        return try await withCheckedThrowingContinuation({ continuation in
            providerSpoonacular.request(.getRecipeInformationById(id: id)) { result in
                switch result {
                case .success(let response):
                    do {
                        let recipeInfo = try response.map(RecipeById.self)
                        continuation.resume(returning: recipeInfo)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        })
    }
    
//    Get Recipe Random
    func getRecipeRandom() async throws -> RecipeRandom {
        return try await withCheckedThrowingContinuation({ continuation in
            providerSpoonacular.request(.getRandomRecipe) { result in
                switch result {
                case .success(let response):
                    do {
                        let recipeRandom = try response.map(RecipeRandom.self)
                        continuation.resume(returning: recipeRandom)
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
