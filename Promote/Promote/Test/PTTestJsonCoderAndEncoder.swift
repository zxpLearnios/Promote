//
//  PTTestJsonCoderAndEncoder.swift
//  Promote
//
//  Created by 张净南 on 2018/7/26.
//  测试系统自带json解析类

import UIKit

class PTTestJsonCoderAndEncoder {

}


struct PTTestJsonCoderAndEncoderModel: Codable {
    
    /// 百度返回的json字段
    let content = ""
    /// 百度返回的json字段， 没有任何意义
    let addressDic = [String: Any]()
    
    let country: String
    let province: String
    let city: String
    var county = ""
    var town = ""
    var village = ""
    
    init() {
        country = "中国"
        province = ""
        city = ""
    }
    
    init(with country: String, province: String, city: String) {
        self.country = country
        self.province = province
        self.city = city
    }
    
    mutating func append(county: String, town: String, village: String) {
        self.county = county
        self.town = town
        self.village = village
    }
    
    enum TLAreaModelAddressDicCodingKeyMap: String, CodingKey {
        case addressDickey = "address_detail"
    }
    
    /**
     city_code: 131,    #百度城市代码
     province: "北京市",    #省份
     city: "北京市",    #城市
     district: "",    #区县
     street: "",    #街道
     street_number: ""    #门牌号
     */
    enum TLAreaModelCodingKeyMap: String, CodingKey {
        case country, province, city
        case county = "district"
        case town = "street"
        case village = "street_number"
    }
    
    func encode(to encoder: Encoder) throws {
        // 第一级
        var container = encoder.container(keyedBy: TLAreaModelAddressDicCodingKeyMap.self)
        // 第二级
        var addressContainer = container.nestedContainer(keyedBy: TLAreaModelCodingKeyMap.self, forKey: .addressDickey)
        do {
            // 字典里的详细信息
            try addressContainer.encode(country, forKey: .country)
            try addressContainer.encode(province, forKey: .province)
            try addressContainer.encode(city, forKey: .city)
            try addressContainer.encode(county, forKey: .county)
            try addressContainer.encode(town, forKey: .town)
            try addressContainer.encode(village, forKey: .village)
        } catch {
            
        }
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TLAreaModelAddressDicCodingKeyMap.self)
        let addressContainer = try container.nestedContainer(keyedBy: TLAreaModelCodingKeyMap.self, forKey: .addressDickey)
        
        country = try addressContainer.decode(String.self, forKey: .country)
        province = try addressContainer.decode(String.self, forKey: .province)
        city = try addressContainer.decode(String.self, forKey: .city)
        county = try addressContainer.decode(String.self, forKey: .county)
        town = try addressContainer.decode(String.self, forKey: .town)
        village = try addressContainer.decode(String.self, forKey: .village)
    }
    
}
