import Foundation

class BaseballGame {
    private let recordManager = RecordManager()

    func run() {
        var isRunning = true

        while isRunning {
            displayMenu()

            guard let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                print("입력 오류입니다.")
                continue
            }

            switch input {
            case "1":
                startGame()
            case "2":
                recordManager.showRecords()
            case "3":
                print("\n< 숫자 야구 게임을 종료합니다 >")
                recordManager.resetRecords()
                isRunning = false
            default:
                print("올바른 숫자를 입력해주세요!")
            }
        }
    }

    private func displayMenu() {
        print("\n환영합니다! 원하시는 번호를 입력해주세요")
        print("1. 게임 시작하기  2. 게임 기록 보기  3. 종료하기")
    }

    private func startGame() {
        let answer = generateAnswer()
        var attempts = 0

        print("\n< 게임을 시작합니다 >")

        while true {
            print("숫자를 입력하세요 : ", terminator: "")
            guard let input = readLine(), isValidGuess(input) else {
                print("올바르지 않은 입력값입니다")
                continue
            }

            attempts += 1
            let guess = input.compactMap { Int(String($0)) }
            let (strike, ball) = checkGuess(guess, against: answer)

            if strike == 3 {
                print("정답!")
                break
            } else if strike == 0 && ball == 0 {
                print("Nothing")
            } else {
                print("\(strike)스트라이크 \(ball)볼")
            }
        }

        recordManager.add(trialCount: attempts)
    }

    private func generateAnswer() -> [Int] {
        var digits = Array(0...9).shuffled()
        guard let firstDigit = digits.first(where: { $0 != 0 }) else {
            fatalError("유효한 첫 숫자를 찾을 수 없습니다.")
        }

        digits.removeAll { $0 == firstDigit }
        let remainingDigits = digits.prefix(2)

        return [firstDigit] + remainingDigits
    }

    private func isValidGuess(_ input: String) -> Bool {
        let digits = input.compactMap { Int(String($0)) }
        let uniqueDigits = Set(digits)

        return input.count == 3 &&
               digits.count == 3 &&
               input.first != "0" &&
               uniqueDigits.count == 3
    }

    private func checkGuess(_ guess: [Int], against answer: [Int]) -> (strike: Int, ball: Int) {
        var strike = 0
        var ball = 0

        for i in 0..<3 {
            if guess[i] == answer[i] {
                strike += 1
            } else if answer.contains(guess[i]) {
                ball += 1
            }
        }

        return (strike, ball)
    }
}
