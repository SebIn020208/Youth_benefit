import Foundation

// User 구조체 정의
struct User: Codable, Identifiable {
    let id: UUID
    var name: String
    var email: String
    var password: String
    var age: Int
    var region: String
    var disability: Bool
    var chronicDisease: Bool
}

// 간단한 console input helper
func readNonEmptyLine(prompt: String) -> String {
    while true {
        print(prompt, terminator: " ")
        if let s = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines), !s.isEmpty {
            return s
        }
        print("값을 입력해주세요.")
    }
}

// 사용자 저장/로드 (JSON)
let usersFileName = "users.json"
func usersFileURL() -> URL {
    URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent(usersFileName)
}

func loadUsers() -> [User] {
    let url = usersFileURL()
    guard FileManager.default.fileExists(atPath: url.path) else { return [] }
    do {
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([User].self, from: data)
    } catch {
        print("사용자 로드 오류:", error)
        return []
    }
}

func saveUsers(_ users: [User]) {
    let url = usersFileURL()
    do {
        let data = try JSONEncoder().encode(users)
        try data.write(to: url)
    } catch {
        print("사용자 저장 오류:", error)
    }
}

// -------------------------------
// 회원가입 / 로그인
// -------------------------------
func registerUser(users: inout [User]) {
    let name = readNonEmptyLine(prompt: "이름:")
    let email = readNonEmptyLine(prompt: "이메일:")
    if users.contains(where: { $0.email.lowercased() == email.lowercased() }) {
        print("이미 존재하는 이메일입니다.")
        return
    }
    let password = readNonEmptyLine(prompt: "비밀번호:")
    let age = Int(readNonEmptyLine(prompt: "나이:")) ?? 0
    let region = readNonEmptyLine(prompt: "지역:")
    let disability = readNonEmptyLine(prompt: "장애 여부(y/n):").lowercased() == "y"
    let chronic = readNonEmptyLine(prompt: "만성질환 여부(y/n):").lowercased() == "y"
    
    let user = User(id: UUID(), name: name, email: email, password: password, age: age, region: region, disability: disability, chronicDisease: chronic)
    users.append(user)
    saveUsers(users)
    print("회원가입 완료!\n")
}

func loginUser(users: [User]) -> User? {
    let email = readNonEmptyLine(prompt: "이메일:")
    let password = readNonEmptyLine(prompt: "비밀번호:")
    return users.first(where: { $0.email.lowercased() == email.lowercased() && $0.password == password })
}

// -------------------------------
// Main loop
// -------------------------------
func main() {
    var users = loadUsers()
    
    while true {
        print("\n1) 회원가입 2) 로그인 3) 종료")
        let sel = readNonEmptyLine(prompt: "선택:")
        if sel == "1" {
            registerUser(users: &users)
        } else if sel == "2" {
            if let user = loginUser(users: users) {
                print("로그인 성공: \(user.name)")
                
                // API 호출
                print("혜택 데이터를 가져오는 중...")
                fetchWelfareData { items in
                    print("\n=== 추천 혜택 ===")
                    for item in items {
                        print("- \(item.title): \(item.description)")
                    }
                    print("=================\n")
                }
                
                // API 호출은 비동기이므로, 잠시 기다림 (실습용)
                sleep(3)
            } else {
                print("로그인 실패")
            }
        } else if sel == "3" {
            break
        }
    }
}

main()
