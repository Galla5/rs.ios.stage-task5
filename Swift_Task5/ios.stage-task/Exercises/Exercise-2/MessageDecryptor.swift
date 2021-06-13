import UIKit

class MessageDecryptor: NSObject {
    
    func decryptMessage(_ message: String) -> String {
        var resultString = ""
        let query = "[0-9]{1,3}\\[[a-z]{1,}"

        let ranges = message.ranges(of: query, options: .regularExpression)
        let matches = ranges.map { message[$0] }
//
        for match in matches {
            let result = match.split(separator: "[")
            if result.count == 2 {
                var repeatCount = Int(result[0]) ?? 1
                if repeatCount == 0 {
                    repeatCount = 1
                }
                for _ in 1...repeatCount {
                    resultString.append(contentsOf: result[1])
                }
            }
        }


        
        return resultString
    }
}

//[0-9]{1,3}\[

extension StringProtocol {
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...].range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}
