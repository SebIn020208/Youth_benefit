// main.swift
import Foundation

// -------------------------------
// Models
// -------------------------------
struct User: Codable, Identifiable {
    let id: UUID
    var name: String
    var email: String
    var password: String   // 연습용: 실제 배포시 평문 저장 금지 (해시 사용)
    var age: Int
    var region: String
    var disability: Bool
    var chronicDisease: Bool
}

struct Benefit {
    let id: String
    let title: String
    let description: String
    let condition: (User) -> Bool
}

// -------------------------------
// Persistence (simple JSON file in current directory)
// -------------------------------
let usersFileName = "users.json"

func usersFileURL() -> URL {
    URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent(usersFileName)
}

func loadUsers() -> [User] {
    let url = usersFileURL()
    guard FileManager.default.fileExists(atPath: url.path) else { return [] }
    do {
        let data = try Data(contentsOf: url)
        let arr = try JSONDecoder().decode([User].self, from: data)
        return arr
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
// Benefits (hard-coded for practice)
// -------------------------------
let allBenefits: [Benefit] = [
    Benefit(id: "senior", title: "시니어 지원", description: "65세 이상을 위한 생활비 / 건강검진 지원", condition: { $0.age >= 65 }),
    Benefit(id: "disability", title: "장애인 지원", description: "장애 여부에 따른 복지 혜택", condition: { $0.disability }),
    Benefit(id: "chronic", title: "만성질환 의료지원", description: "만성질환 보유자 대상 의료비 지원", condition: { $0.chronicDisease }),
    Benefit(id: "seoul_local", title: "서울시 지역지원", description: "서울시 거주자를 위한 시차별 맞춤 지원", condition: { $0.region.lowercased().contains("seoul") || $0.region.lowercased().contains("서울") }),
    Benefit(id: "youth", title: "청년 지원", description: "만 19~34세 청년 대상 취업·주거 지원", condition: { (19...34).contains($0.age) })
]

// -------------------------------
// Input helpers
// -------------------------------
func readNonEmptyLine(prompt: String) -> String {
    while true {
        print(prompt, terminator: " ")
        if let s = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines), !s.isEmpty {
            return s
        }
        print("값을 입력해주세요.")
    }
}

func readInt(prompt: String, default defaultValue: Int? = nil) -> Int {
    while true {
        print(prompt, terminator: " ")
        if let s = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines), !s.isEmpty, let v = Int(s) {
            return v
        } else if let def = defaultValue {
            return def
        }
        print("숫자를 입력해주세요.")
    }
}

func readBoolYN(prompt: String) -> Bool {
    while true {
        print(prompt + " (y/n):", terminator: " ")
        if let s = readLine()?.lowercased() {
            if s == "y" || s == "yes" { return true }
            if s == "n" || s == "no" { return false }
        }
        print("y 또는 n 을 입력하세요.")
    }
}

// -------------------------------
// Auth: register / login
// -------------------------------
func registerUser(users: inout [User]) {
    print("\n== 회원가입 ==")
    let name = readNonEmptyLine(prompt: "이름:")
    let email = readNonEmptyLine(prompt: "이메일(로그인 ID):")
    if users.contains(where: { $0.email.lowercased() == email.lowercased() }) {
        print("이미 존재하는 이메일입니다.")
        return
    }
    print("비밀번호:")
    let password = readNonEmptyLine(prompt: "(입력)")
    let age = readInt(prompt: "나이:")
    let region = readNonEmptyLine(prompt: "지역(예: Seoul 또는 서울):")
    let disability = readBoolYN(prompt: "장애 여부가 있습니까?")
    let chronic = readBoolYN(prompt: "만성질환(고혈압·당뇨 등) 보유 여부?")
    
    let user = User(id: UUID(), name: name, email: email, password: password, age: age, region: region, disability: disability, chronicDisease: chronic)
    users.append(user)
    saveUsers(users)
    print("회원가입 완료! 로그인 해주세요.\n")
}

func loginUser(users: [User]) -> User? {
    print("\n== 로그인 ==")
    let email = readNonEmptyLine(prompt: "이메일:")
    let pw = readNonEmptyLine(prompt: "비밀번호:")
    if let u = users.first(where: { $0.email.lowercased() == email.lowercased() && $0.password == pw }) {
        print("로그인 성공: \(u.name)\n")
        return u
    } else {
        print("로그인 실패(이메일 또는 비밀번호 확인)\n")
        return nil
    }
}

// -------------------------------
// Matching & slide UI (console)
// -------------------------------
func matchedBenefits(for user: User) -> [Benefit] {
    allBenefits.filter { $0.condition(user) }
}

func showBenefitsAsPages(_ list: [Benefit]) {
    guard !list.isEmpty else {
        print("해당 조건에 맞는 혜택이 없습니다.")
        return
    }
    var idx = 0
    while true {
        let b = list[idx]
        print("\n========================")
        print("(\(idx+1)/\(list.count)) \(b.title)")
        print("------------------------")
        print(b.description)
        print("------------------------")
        print("[n] 다음  [p] 이전  [q] 종료")
        print("========================")
        print("입력:", terminator: " ")
        guard let c = readLine()?.lowercased() else { break }
        if c == "n" {
            if idx < list.count - 1 { idx += 1 } else { print("마지막 페이지입니다.") }
        } else if c == "p" {
            if idx > 0 { idx -= 1 } else { print("첫 페이지입니다.") }
        } else if c == "q" {
            break
        } else {
            print("n/p/q 중 하나를 입력하세요.")
        }
    }
}

// -------------------------------
// Main loop
// -------------------------------
func main() {
    var users = loadUsers()
    while true {
        print("\n==== 혜택 매칭 앱 (콘솔 연습용) ====")
        print("1) 회원가입  2) 로그인  3) 종료")
        print("선택:", terminator: " ")
        guard let sel = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else { continue }
        if sel == "1" {
            registerUser(users: &users)
        } else if sel == "2" {
            if let user = loginUser(users: users) {
                // 로그인 후 혜택 보기
                let matched = matchedBenefits(for: user)
                print("맞춤 혜택 \(matched.count)개 발견.")
                showBenefitsAsPages(matched)
            }
        } else if sel == "3" || sel.lowercased() == "q" {
            print("앱을 종료합니다.")
            break
        } else {
            print("올바른 선택을 입력하세요.")
        }
    }
}

main()