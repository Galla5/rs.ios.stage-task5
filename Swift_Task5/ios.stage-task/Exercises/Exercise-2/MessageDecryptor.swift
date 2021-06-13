import UIKit

class MessageDecryptor: NSObject {
    
    func decryptMessage(_ message: String) -> String {
        guard message.contains("[") else { return message }
        let numbersRange = message.rangeOfCharacter(from: .decimalDigits)
        guard numbersRange != nil else {
            return message
                .replacingOccurrences(of: "[", with: "")
                .replacingOccurrences(of: "]", with: "")
        }
        var resultString = ""
        let query = "[a-z]{0,}[0-9]{1,3}\\[[a-z]{1,}\\][a-z]{0,}"

        let ranges = message.ranges(of: query, options: .regularExpression)
        let matches = ranges.map { message[$0] }
        
        let text = "abc"
        let index2 = text.index(text.startIndex, offsetBy: 2) //will call succ 2 times
        let lastChar: Character = text[index2]

        for match in matches {
            let openBreketsIndex = match.firstIndex(of: "[")
            let prefix = match[..<openBreketsIndex!]
            
            let prefixWithoutDigit = prefix.components(separatedBy: CharacterSet.decimalDigits).joined()
            resultString.append(contentsOf: prefixWithoutDigit)
            
            let closeBreketsIndex = match.firstIndex(of: "]")
            
            let repeatMessage = match[openBreketsIndex!...closeBreketsIndex!]
                .replacingOccurrences(of: "[", with: "")
                .replacingOccurrences(of: "]", with: "")
            var repeatCount = Int(String(prefix).westernArabicNumeralsOnly) ?? 0
            if repeatCount == 0 {
                break
            }
            for _ in 1...repeatCount {
                resultString.append(contentsOf: repeatMessage)
            }
            
            let postfix = match[closeBreketsIndex!...].replacingOccurrences(of: "]", with: "")
            resultString.append(contentsOf: postfix)
        }


        
        return resultString
    }
}

private extension StringProtocol {
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

private extension String {
    var westernArabicNumeralsOnly: String {
        let pattern = UnicodeScalar("0")..."9"
        return String(unicodeScalars
            .flatMap { pattern ~= $0 ? Character($0) : nil })
    }
}
