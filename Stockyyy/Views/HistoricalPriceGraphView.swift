import Charts
import UIKit

final class HistoricalPriceGraphView: UIView {
    
    lazy var lineChartView = LineChartView()
    
    var historicalPrices: CompanyHistoricalPriceJSON? {
        didSet {
            guard let historicalPrices = historicalPrices, let prices = historicalPrices.historical else { return }
            let numberOfWorkDaysToInclude = 261 * 5 //261 workdays in a year x 5 years
            let filteredPrices = prices.count > numberOfWorkDaysToInclude ? Array(prices[0..<numberOfWorkDaysToInclude]) : prices
            let chartDataEntries = createDataEntries(priceData: filteredPrices.sorted(by: { $0.date ?? "" < $1.date ?? "" }))
            createDataSet(with: chartDataEntries)
            
            animateChart()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        
        addChartToView()
        customizeChartView()
    }
    
    //Not using SB
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func addChartToView() {
        self.addSubview(lineChartView)
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            lineChartView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            lineChartView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            lineChartView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            lineChartView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        ])
    }
    
    //MARK: Create ChartDataEntry items
    private func createDataEntries(priceData: [CompanyHistoricalPriceJSON.Historical]) -> [ChartDataEntry] {
        var chartDataEntries = [ChartDataEntry]()
        for (index, historicalPrice) in priceData.enumerated() {
            let chartDataEntry = ChartDataEntry(x: Double(index), y: Double(historicalPrice.close ?? 0.0))
            chartDataEntries.append(chartDataEntry)
        }
        
        return chartDataEntries
    }
    
    private func createDataSet(with chartDataEntries: [ChartDataEntry]) {
        let dataSet = LineChartDataSet(entries: chartDataEntries, label: nil)
        dataSet.circleRadius = 0    //managers the data point circles
        dataSet.colors = [.systemGreen]
        dataSet.lineWidth = 2
        dataSet.drawValuesEnabled = false   //turns off data point labels
        dataSet.mode = .cubicBezier //makes the line round at the data point
        
        //MARK: Fill customization
        dataSet.drawFilledEnabled = true    //Turn on and off fill
        dataSet.fillAlpha = 0.2
        dataSet.fillColor = .systemGreen
        
        //MARK: Assign the dataSet to a LineChartData instance
        let data = LineChartData()
        data.addDataSet(dataSet)
        lineChartView.data = data
    }
    
    private func customizeChartView() {
        lineChartView.delegate = self
        lineChartView.backgroundColor = .systemBackground
        lineChartView.xAxis.gridColor = .systemGray
        
        lineChartView.borderLineWidth = 0.5  //use values < 1
        lineChartView.chartDescription?.text = ""
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.drawLabelsEnabled = false   //turns off xAxis labels
        lineChartView.drawBordersEnabled = false
        lineChartView.legend.enabled = false
        lineChartView.leftAxis.drawLabelsEnabled = true //turn on and off leftAxis labels
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
    }
    
    private func animateChart() {
        lineChartView.animate(xAxisDuration: 1)
    }
}

extension HistoricalPriceGraphView: ChartViewDelegate {}
