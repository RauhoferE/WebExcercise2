//
//  Country.swift
//  Excericse2
//
//  Created by emre on 22.09.26.
//

import Foundation
nonisolated struct Country: Decodable {
    var ID: String
    var name: String
    var currency: String
    var capital: String
    var native: String
    var continent: String
    var phone: String
    var createTime: Date
    var updateTime: Date
    var languages: [String]
    
    init(from decoder: Decoder) throws {
                let rootContainer = try decoder.container(keyedBy: RootCodingKeys.self)
                ID = (try rootContainer.decode(String.self, forKey: .ID) as NSString).lastPathComponent
        
        // Dive into "fields"
        let fieldsContainer = try rootContainer.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .fields)
        
        // Each simple field is: { "stringValue": "..." }
        name = try Self.decodeStringValue(from: fieldsContainer, forKey: .name)
        currency = try Self.decodeStringValue(from: fieldsContainer, forKey: .currency)
        capital = try Self.decodeStringValue(from: fieldsContainer, forKey: .capital)
        native = try Self.decodeStringValue(from: fieldsContainer, forKey: .native)
        continent = try Self.decodeStringValue(from: fieldsContainer, forKey: .continent)
        phone = try Self.decodeStringValue(from: fieldsContainer, forKey: .phone)
        
        // "languages": { "arrayValue": { "values": [ { "stringValue": "de" }, ... ] } }
        let languagesArrayValueContainer = try fieldsContainer.nestedContainer(keyedBy: ArrayValueCodingKeys.self, forKey: .languages)
        let languagesNestedContainer = try languagesArrayValueContainer.nestedContainer(keyedBy: ArrayValueNestedCodingKeys.self, forKey: .arrayValue)
        
        var valuesContainer = try languagesNestedContainer.nestedUnkeyedContainer(forKey: .values)
        var decodedLanguages: [String] = []
        
        while !valuesContainer.isAtEnd {
            let stringValueContainer = try valuesContainer.nestedContainer(keyedBy: StringValueCodingKeys.self)
            let language = try stringValueContainer.decode(String.self, forKey: .stringValue)
            decodedLanguages.append(language)
        }
        languages = decodedLanguages
        let createTimeString = try rootContainer.decode(String.self, forKey: .createTime)
            guard let createTime = DateFormatter.iso8601Full.date(from: createTimeString) else {
                throw DecodingError.dataCorruptedError(
                    forKey: .createTime,
                    in: rootContainer,
                    debugDescription: "Date string does not match expected format: \(createTimeString)"
                )
            }
            self.createTime = createTime
            
            let updateTimeString = try rootContainer.decode(String.self, forKey: .updateTime)
            guard let updateTime = DateFormatter.iso8601Full.date(from: updateTimeString) else {
                throw DecodingError.dataCorruptedError(
                    forKey: .updateTime,
                    in: rootContainer,
                    debugDescription: "Date string does not match expected format: \(updateTimeString)"
                )
            }
            self.updateTime = updateTime
        
        
            }
    
    private static func decodeStringValue(
        from container: KeyedDecodingContainer<NestedCodingKeys>,
        forKey key: NestedCodingKeys
    ) throws -> String {
        let stringValueContainer = try container.nestedContainer(keyedBy: StringValueCodingKeys.self, forKey: key)
        return try stringValueContainer.decode(String.self, forKey: .stringValue)
    }
}

nonisolated struct DocumentsContainer: Decodable{
    var documents: [Country]
}


private enum RootCodingKeys: String, CodingKey {
        case ID = "name"
        case createTime
        case updateTime
        case fields
}

private enum NestedCodingKeys: String, CodingKey {
    case name
    case currency
    case capital
    case native
    case continent
    case phone
    case languages
}

private enum StringValueCodingKeys: String, CodingKey {
    case stringValue
}

private enum ArrayValueCodingKeys: String, CodingKey {
    case arrayValue
}

private enum ArrayValueNestedCodingKeys: String, CodingKey {
    case values
}

extension DateFormatter {
    nonisolated static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

nonisolated struct CountriesAPIError: Decodable{
    let code: Int
    let message: String
    let status: String
}
