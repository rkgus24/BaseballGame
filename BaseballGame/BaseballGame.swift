import Foundation

class BaseballGame {
    let recordManager = RecordManager()

    func run() {
        var isRunning = true

        while isRunning {
            printMenu()

            guard let input = readLine() else {
                print("입력 오류입니다")
                continue
            }

            switch input {
            case "1":
                let trialCount = startGame()
                recordManager.add(trialCount: trialCount)

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

    func printMenu() {
        print("\n환영합니다! 원하시는 번호를 입력해주세요")
        print("1. 게임 시작하기  2. 게임 기록 보기  3. 종료하기")
    }

    func startGame() -> Int {
        let answer = makeAnswer()
        print("\n< 게임을 시작합니다 >")

        var trialCount = 0

        while true {
            print("숫자를 입력하세요 :")
            guard let input = readLine(), validate(input) else {
                print("올바르지 않은 입력값입니다")
                continue
            }

            trialCount += 1
            let guess = input.compactMap { Int(String($0)) }
            let (strike, ball) = check(guess: guess, answer: answer)

            if strike == 3 {
                print("정답!")
                break
            } else if strike == 0 && ball == 0 {
                print("Nothing")
            } else {
                print("\(strike)스트라이크 \(ball)볼")
            }
        }

        return trialCount
    }

    func makeAnswer() -> [Int] {
        var numbers = Array(0...9).shuffled()

        guard let first = numbers.first(where: { $0 != 0 }) else {
            fatalError("숫자 생성 실패")
        }

        numbers.removeAll(where: { $0 == first })
        let rest = numbers.shuffled()
        let answer = [first] + rest.prefix(2)

        return answer
    }

    func validate(_ input: String) -> Bool {
        let digits = input.compactMap { Int(String($0)) }
        let unique = Set(digits)

        return input.count == 3 &&
               digits.count == 3 &&
               !input.hasPrefix("0") &&
               unique.count == 3
    }

    func check(guess: [Int], answer: [Int]) -> (strike: Int, ball: Int) {
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
