import Foundation
import Alamofire

struct APIResponse: Codable {
    let check: Int?
}

struct CompletedTasks: Codable {
    let planIds: [Int]
    let planSubDetailIds: [Int]
}

class APIService {
    static let shared = APIService()
    let urlInstance = URLClass()
    private lazy var baseURL = urlInstance.baseURL
    
    private init() {}
    
    func postData<T: Codable>(endpoint: String, jsonData: Data, completion: @escaping (Result<T, Error>) -> Void) {
        let urlString = "\(baseURL)\(endpoint)"
        
        print("📡 POST 요청 시작 (JSON 데이터) ===============")
        print("URL: \(urlString)")
        
        // JSON 데이터를 Dictionary로 변환
        guard let jsonObject = try? JSONSerialization.jsonObject(with: jsonData),
              let parameters = jsonObject as? [String: Any] else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "JSON 변환 실패"])))
            return
        }
        
        AF.request(urlString,
                   method: .post,
                   parameters: parameters,  // 변환된 parameters 사용
                   encoding: JSONEncoding.default,
                   headers: ["Content-Type": "application/json",
                            "accept": "application/json"])
            .validate()
            .responseDecodable(of: T.self) { response in
                self.handleResponse(response, completion: completion)
            }
    }
    // GET 요청
    func get<T: Codable>(endpoint: String, completion: @escaping (Result<T, Error>) -> Void) {
        let urlString = "\(baseURL)\(endpoint)"
            
        print("📡 GET 요청 시작 ===============")
//        print("URL: \(urlString)")
        
        AF.request(urlString,
                  method: .get,
                  headers: ["accept": "application/json"])
        .validate()
        .responseDecodable(of: T.self) { response in
            self.handleResponse(response, completion: completion)
        }
    }
    
    // POST 요청
    func post<T: Codable>(endpoint: String, parameters: [String: Any], completion: @escaping (Result<T, Error>) -> Void) {
        let urlString = "\(baseURL)\(endpoint)"
        
        print("📡 POST 요청 시작 ===============")
        print("URL: \(urlString)")
        print("Parameters: \(parameters)")
        
        AF.request(urlString,
                  method: .post,
                  parameters: parameters,
                  encoding: JSONEncoding.default,
                  headers: ["Content-Type": "application/json",
                           "accept": "application/json"])
        .validate()
        .responseDecodable(of: T.self) { response in
            self.handleResponse(response, completion: completion)
        }
    }
    
    // PUT 요청
    func put<T: Codable>(endpoint: String, parameters: [String: Any], completion: @escaping (Result<T, Error>) -> Void) {
        let urlString = "\(baseURL)\(endpoint)"
        
        print("📡 PUT 요청 시작 ===============")
        print("URL: \(urlString)")
        print("Parameters: \(parameters)")
        
        AF.request(urlString,
                  method: .put,
                  parameters: parameters,
                  encoding: JSONEncoding.default,
                  headers: ["Content-Type": "application/json",
                           "accept": "application/json"])
        .validate()
        .responseDecodable(of: T.self) { response in
            self.handleResponse(response, completion: completion)
        }
    }
    
    // DELETE 요청
    func delete<T: Codable>(endpoint: String, completion: @escaping (Result<T, Error>) -> Void) {
        let urlString = "\(baseURL)\(endpoint)"
        
        print("📡 DELETE 요청 시작 ===============")
        print("URL: \(urlString)")
        
        AF.request(urlString,
                  method: .delete,
                  headers: ["accept": "application/json"])
        .validate()
        .responseDecodable(of: T.self) { response in
            self.handleResponse(response, completion: completion)
        }
    }
    
    //patch 
    func patch<T: Codable>(endpoint: String, parameters: [String: Any], completion: @escaping (Result<T, Error>) -> Void) {
        let urlString = "\(baseURL)\(endpoint)"
        
        print("📡 PATCH 요청 시작 ===============")
        print("URL: \(urlString)")
        print("Parameters: \(parameters)")
        
        AF.request(urlString,
                  method: .patch,
                  parameters: parameters,
                  encoding: JSONEncoding.default,
                  headers: ["Content-Type": "application/json",
                           "accept": "application/json"])
        .validate()
        .response { response in  // .responseDecodable 대신 .response 사용
            // 응답이 비어있어도 성공으로 처리
            if response.error == nil {
                // 빈 APIResponse 생성
                if let emptyResponse = APIResponse(check: 1) as? T {
                    completion(.success(emptyResponse))
                } else {
                    completion(.failure(NSError(domain: "", code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "응답 변환 실패"])))
                }
            } else {
                completion(.failure(response.error!))
            }
        }
    }
    
    
    
    
    // 응답 처리 헬퍼 메서드
    private func handleResponse<T: Codable>(_ response: DataResponse<T, AFError>, completion: @escaping (Result<T, Error>) -> Void) {
        print("\n📡 서버 응답 ===============")
        
        if let statusCode = response.response?.statusCode {
            print("상태 코드: \(statusCode)")
        }
        
        if let headers = response.response?.allHeaderFields {
            print("헤더 필드:")
            headers.forEach { key, value in
                print("\(key): \(value)")
            }
        }
        
        if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
            print("\n📦 응답 데이터:")
            print(jsonString)
        }
         
        switch response.result {
        case .success(let value):
            print("✅ 요청 성공")
            completion(.success(value))
        case .failure(let error):
            print("❌ 요청 실패: \(error.localizedDescription)")
            completion(.failure(error))
        }
        
        print("===============================\n")
    }
}
