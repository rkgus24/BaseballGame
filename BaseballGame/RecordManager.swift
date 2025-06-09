import Foundation

class RecordManager {
    private var records: [Int] = []

    func add(trialCount: Int) {
        records.append(trialCount)
    }

    func showRecords() {
        print("\n< 게임 기록 보기 >")
        if records.isEmpty {
            print("아직 완료한 게임이 없습니다.")
        } else {
            for (index, count) in records.enumerated() {
                print("\(index + 1)번째 게임 : 시도 횟수 - \(count)")
            }
        }
    }

    func resetRecords() {
        records.removeAll()
    }
}
