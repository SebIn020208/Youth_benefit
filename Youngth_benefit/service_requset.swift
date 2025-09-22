import Foundation

// 구조체 정의: API에서 가져온 데이터 파싱용
struct WelfareItem: Codable {
    let id: String
    let title: String
    let description: String
}

// API 호출 함수
func fetchWelfareData(completion: @escaping ([WelfareItem]) -> Void) {
    // 인증키 (디코딩된 값 사용)
    let apiKey = "9gZz2YqPyja1Ij9KwIvHdug+uGvt34T70zxHFLlhzQ3EHJx4plGMzvkuVQ+9GYCNXdIdkc9TKxxLM5HWV5gcXg=="
    
    // URL 세팅 (예: 1페이지 10개)
    let urlString = "https://apis.data.go.kr/B554287/LocalGovernmentWelfareInformations?serviceKey=\(apiKey)&pageNo=1&numOfRows=10"
    
    guard let url = URL(string: urlString) else {
        print("잘못된 URL")
        completion([])
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            print("API 요청 실패:", error ?? "Unknown error")
            completion([])
            return
        }
        
        // XML을 JSON으로 변환하거나, XML 파싱 후 배열 생성
        // 여기서는 예제용으로 간단히 JSONDecoder 사용
        do {
            let decoder = JSONDecoder()
            let items = try decoder.decode([WelfareItem].self, from: data)
            completion(items)
        } catch {
            print("API 데이터 파싱 실패:", error)
            completion([])
        }
    }
    
    task.resume()
}
