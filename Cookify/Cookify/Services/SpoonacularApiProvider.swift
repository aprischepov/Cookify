//
//  SpoonacularApiProvider.swift
//  Cookify
//
//  Created by Artem Prishepov on 14.06.23.
//

import Foundation
import Moya

enum RecipeType: String, CaseIterable {
    case mainCourse = "main course"
    case sideDish = "side dish"
    case dessert = "dessert"
    case appetizer = "appetizer"
    case salad = "salad"
    case bread = "bread"
    case breakfast = "breakfast"
    case soup = "soup"
    case beverage = "beverage"
    case sauce = "sauce"
    case marinade = "marinade"
    case fingerfood = "fingerfood"
    case snack = "snack"
    case drink = "drink"
    
    var id: Int {
        switch self {
        case .mainCourse:
            return 0
        case .sideDish:
            return 1
        case .dessert:
            return 2
        case .appetizer:
            return 3
        case .salad:
            return 4
        case .bread:
            return 5
        case .breakfast:
            return 6
        case .soup:
            return 7
        case .beverage:
            return 8
        case .sauce:
            return 9
        case .marinade:
            return 10
        case .fingerfood:
            return 11
        case .snack:
            return 12
        case .drink:
            return 13
        }
    }
}

enum SpoonacularApiProvider {
    case getRecipesByType(type: RecipeType, count: Int, offset: Int)
//    case getRecipeInformationById
//    case searchByIngredients
}

extension SpoonacularApiProvider: TargetType {
    var baseURL: URL {
        switch self {
        default:
            return URL(string: Constants.spoonacularBaseUrl)!
        }
    }
    
    var path: String {
        switch self {
        case .getRecipesByType:
            return "recipes/complexSearch"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var parameters: [String : Any]? {
        var params = [String : Any]()
        if let spoonacularApiKey = Bundle.main.object(forInfoDictionaryKey: "SpoonacularApiKey") as? String {
            params["apiKey"] = spoonacularApiKey
        }
        switch self {
        case .getRecipesByType(type: let type, count: let count, offset: let offset):
            params["type"] = type.rawValue
            params["addRecipeInformation"] = true.description
            params["offset"] = offset
            params["number"] = count
        }
        return params
    }
    
    var parameterEncoding: ParameterEncoding {
        URLEncoding.default
    }
    
    var task: Moya.Task {
        guard let params = parameters else {
            return .requestPlain
        }
        return .requestParameters(parameters: params, encoding: parameterEncoding)
    }
    
    var headers: [String : String]? {
        nil
    }
}

struct Constants {
    static var spoonacularBaseUrl: String = "https://api.spoonacular.com/"
}
