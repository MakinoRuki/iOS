//
//  DataModel.swift
//  testmaps
//
//  Created by Makino Ruki on 1/19/22.
//

import Foundation
import GoogleMaps

enum TopicError:Error {
    case noDataAvailable
    case canNotProcessData
}

struct TopicStatus:Decodable {
    var status:String
}

struct Topic:Decodable {
    var topicId: Int = 0
    var title:String
    var content:String
    var latitude:CLLocationDegrees
    var longitude:CLLocationDegrees
    var replies: [String] = [String]()
    
    init(topicId: Int, title: String, content: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.topicId = topicId
        self.title = title
        self.content = content
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func getTopic(completion: @escaping(Result<Topic, TopicError>) -> Void) {
        let objs: [String: Any] = [
            "type":"topic",
            "topic_id":self.topicId
        ]
        let resourceURL:URL = URL(string: "http://ec2-3-133-137-222.us-east-2.compute.amazonaws.com:8090/")!
        var request = URLRequest(url: resourceURL)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: objs, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let dataTask = URLSession.shared.dataTask(with: request) {data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            do {
                let decoder = JSONDecoder()
                let topic = try decoder.decode(Topic.self, from:jsonData)
                completion(.success(topic))
            } catch {
                completion(.failure(.canNotProcessData))
            }
            
        }
        dataTask.resume()
    }
    
    func postTopic(completion: @escaping(Result<String, TopicError>) -> Void) {
        let objs: [String: Any] = [
            "user_id":123,
            "type":"add",
            "title":self.title,
            "content":self.content,
            "latitude":self.latitude,
            "longitude":self.longitude
        ]
        let resourceURL:URL = URL(string: "http://ec2-3-133-137-222.us-east-2.compute.amazonaws.com:8090/")!
        var request = URLRequest(url: resourceURL)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: objs, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let dataTask = URLSession.shared.dataTask(with: request) {data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            do {
                let decoder = JSONDecoder()
                let topicStatus = try decoder.decode(TopicStatus.self, from:jsonData)
                let status = topicStatus.status
                completion(.success(status))
            } catch {
                completion(.failure(.canNotProcessData))
            }
            
        }
        dataTask.resume()
    }
}

struct TopicList:Decodable {
    var topics:[Topic]
}

struct GetTopics {
    var keyword: String = ""
    var latitude:CLLocationDegrees
    var longitude:CLLocationDegrees
    
    init(keyword: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.keyword = keyword
        self.latitude = latitude
        self.longitude = longitude
    }
    func searchTopics(completion: @escaping(Result<[Topic], TopicError>) -> Void) {
        let objs: [String: Any] = [
            "user_id":123,
            "type":"get",
            "keyword":self.keyword,
            "latitude":self.latitude,
            "longitude":self.longitude
        ]
        let resourceURL:URL = URL(string: "http://ec2-3-133-137-222.us-east-2.compute.amazonaws.com:8090/")!
        var request = URLRequest(url: resourceURL)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: objs, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let dataTask = URLSession.shared.dataTask(with: request) {data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            do {
                let decoder = JSONDecoder()
             //   let topicStatus = try decoder.decode(TopicStatus.self, from:jsonData)
               // let status = topicStatus.status
                print(jsonData)
                let topicList = try decoder.decode(TopicList.self, from:jsonData)
                print(topicList.topics.count)
                print(topicList.topics[0])
                completion(.success(topicList.topics))
            } catch {
                completion(.failure(.canNotProcessData))
            }
            
        }
        dataTask.resume()
    }
}

struct Reply {
    var topicId : Int
    var content: String
    init(topicId: Int, content:String) {
        self.topicId = topicId
        self.content = content
    }
    
    func postReply(completion: @escaping(Result<String, TopicError>) -> Void) {
        let objs: [String: Any] = [
            "type":"reply",
            "topic_id":self.topicId,
            "content":self.content
        ]
        let resourceURL:URL = URL(string: "http://ec2-3-133-137-222.us-east-2.compute.amazonaws.com:8090/")!
        var request = URLRequest(url: resourceURL)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: objs, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let dataTask = URLSession.shared.dataTask(with: request) {data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            do {
                let decoder = JSONDecoder()
                let topicStatus = try decoder.decode(TopicStatus.self, from:jsonData)
                let status = topicStatus.status
                completion(.success(status))
            } catch {
                completion(.failure(.canNotProcessData))
            }
            
        }
        dataTask.resume()
    }
}

struct Fun: Decodable {
    var name:String
    var description:String
    var latitude:CLLocationDegrees
    var longitude:CLLocationDegrees
}

struct FunList: Decodable {
    var funs: [Fun]
}

struct GetFuns {
    var latitude:CLLocationDegrees
    var longitude:CLLocationDegrees
    
    init(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.latitude = latitude
        self.longitude = longitude
    }
    func searchFuns(completion: @escaping(Result<[Fun], TopicError>) -> Void) {
        let objs: [String: Any] = [
            "user_id":123,
            "type":"fun",
            "latitude":self.latitude,
            "longitude":self.longitude
        ]
        let resourceURL:URL = URL(string: "http://ec2-3-133-137-222.us-east-2.compute.amazonaws.com:8090/")!
        var request = URLRequest(url: resourceURL)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: objs, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let dataTask = URLSession.shared.dataTask(with: request) {data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            do {
                let decoder = JSONDecoder()
             //   let topicStatus = try decoder.decode(TopicStatus.self, from:jsonData)
               // let status = topicStatus.status
                print(jsonData)
                let funList = try decoder.decode(FunList.self, from:jsonData)
                completion(.success(funList.funs))
            } catch {
                completion(.failure(.canNotProcessData))
            }
            
        }
        dataTask.resume()
    }
}
