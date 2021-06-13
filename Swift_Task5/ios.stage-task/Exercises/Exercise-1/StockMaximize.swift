import Foundation
//[8, 2, 3, 5, 4, 5]
class StockMaximize {

    func countProfit(prices: [Int]) -> Int {
        guard !prices.isEmpty else { return 0 }
        guard Set(prices).count != 1 else { return 0 }
        var profit = 0
        let maxPrice = prices.max() ?? 0
        let maxPriceIndex = prices.firstIndex(of: maxPrice) ?? 0
        for (index, price) in prices.enumerated() {
            if let nextDayPrice = prices[safe: index + 1] {
                let nextDayProfit = nextDayPrice - price
                var maxProfit = 0
                if index < maxPriceIndex {
                    maxProfit = maxPrice - price
                }
                let maxDayProfit = maxProfit > nextDayProfit ? maxProfit : nextDayProfit
                profit += maxDayProfit
            }
        }
        return profit
    }
}

private extension Collection {

    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
