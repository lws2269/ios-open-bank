//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by 스톤, 로빈 on 2022/11/15.
//

import UIKit

struct NetworkManager {
    let baseURL: String
    var session: URLSessionProtocol
    
    static let indentifier = "f5948cd0-6940-11ed-a917-15417865aa81"
    static let secretKey = "snnq45ezg2tn9amy"
    
    init(urlString: String = "https://openmarket.yagom-academy.kr/",
         session: URLSessionProtocol = URLSession(configuration: .default)) {
        self.baseURL = urlString
        self.session = session
    }
    
    func checkAPIHealth(completion: @escaping (Bool) -> Void) {
        let urlString = "\(baseURL)healthChecker"
        
        guard let url: URL = URL(string: urlString) else { return }
        
        let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                return completion(false)
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return completion(false)
            }
            
            return completion(httpResponse.statusCode == 200)
        }
        
        dataTask.resume()
    }
    
    func fetchItemList(pageNo: Int, pageCount: Int, completion: @escaping (Result<ItemList, NetworkError>) -> Void) {
        let urlString = "\(baseURL)api/products?page_no=\(pageNo)&items_per_page=\(pageCount)"
        
        guard let url: URL = URL(string: urlString) else { return }
        
        let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                return completion(.failure(.invalidError))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                return completion(.failure(.responseError))
            }
            
            guard let data = data else { return completion(.failure(.dataError))}
            
            do {
                let itemList: ItemList = try JSONDecoder().decode(ItemList.self, from: data)
                completion(.success(itemList))
            } catch {
                completion(.failure(.parseError))
            }
        }
        
        dataTask.resume()
    }
    
    func fetchItem(productId: Int, completion: @escaping (Result<Item, NetworkError>) -> ()) {
        let urlString = "\(baseURL)api/products/\(productId)"
        
        guard let url: URL = URL(string: urlString) else { return }
        
        let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                return completion(.failure(.invalidError))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                return completion(.failure(.responseError))
            }
            
            guard let data = data else { return completion(.failure(.dataError))}
            
            do {
                let item: Item = try JSONDecoder().decode(Item.self, from: data)
                completion(.success(item))
            } catch {
                completion(.failure(.parseError))
            }
        }
        
        dataTask.resume()
    }
    
    func fetchImage(url: URL, completion: @escaping (UIImage) -> ()) {
        let cachedKey = NSString(string: "\(url)")
        
        if let cachedImage = ImageCacheManager.shared.object(forKey: cachedKey) {
            return completion(cachedImage)
        }
        
        DispatchQueue.global(qos: .utility).async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                ImageCacheManager.shared.setObject(image, forKey: cachedKey)
                completion(image)
            }
        }
    }
}

extension NetworkManager {
    func addItem() {
        let boundary = "Boundary-\(UUID().uuidString)"
        
        var request = URLRequest(url: URL(string: "\(baseURL)/api/products")!)
        
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue(NetworkManager.indentifier, forHTTPHeaderField: "identifier")
        
        let jsonData = try? JSONSerialization.data(withJSONObject:
                                                    ["name": "개껌", "description": "간식", "price": 1000, "currency": "KRW", "discounted_price": 100, "stock": -231, "secret": "snnq45ezg2tn9amy"])
        request.httpBody = createRequestBody(params: ["params" : jsonData!], boundary: boundary)
//        print(String(data: request.httpBody!, encoding: .utf8)!)
    }
    
    func createRequestBody(params: [String: Data], boundary: String) -> Data {
        let boundaryPrefix = "--\(boundary)\r\n"
        
        var body = Data()
        
        for (key, value) in params {
            body.append(boundaryPrefix.data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append(value)
            body.append("\r\n".data(using: .utf8)!)
        }
        let imgDataKey = "images"
        let filename = "dogdog123.jpg"
        let mimeType = "image/jpg"
        guard let imageData = UIImage(named: "DogChe")?.jpegData(compressionQuality: 0.2) else { return Data() }
        
        
        body.append(boundaryPrefix.data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(imgDataKey)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        print("=============================================")
        print(String(data: body, encoding: .utf8)!)
        print("=============================================")
        body.append(imageData)
        print("===================시마이=======================")
        print(String(data: body, encoding: .utf8))
        print("===================시마이=======================")
        body.append("--".appending(boundary.appending("--")).data(using: .utf8)!)
        return body
    }
}
