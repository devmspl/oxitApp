//
//  HomeCell.swift
//  AATA
//
//  Created by Uday Patel on 25/10/21.
//

import UIKit
import Charts
import DropDown
//import Lottie

enum DisplayLineChart: Int {
    case yOnly = 0
    case ZOnly = 1
    case all = 2
}

///
class HomeCell: UITableViewCell {
   
    // MARK: - IBOutlet
    ///
    @IBOutlet weak var lineChart: LineChartView!
    ///
    @IBOutlet weak var deviceDropDownButton: UIButton!
    ///
    @IBOutlet weak var filterButton: UIButton!
    ///
    @IBOutlet weak var deviceLabel: UILabel!
    ///
    @IBOutlet weak var treeImage: UIImageView!

    
    var lineDataY: LineChartDataSet?
    var lineDataZ: LineChartDataSet?
    var displayChartLine: DisplayLineChart = .all
    
    // MARK: - Variable
    ///
    var deviceViewModal: DeviceViewModel = DeviceViewModel()
    ///
    var dataSource2: DeviceCategoryDataSource?
    ///
    var timeSeries: [TimeSeries] = []
    ///
    let deviceDropDown = DropDown()
    ///
    var delegate: HomeDelegate?
    ///
    var endDeviceList: [EndDevice] = []
    
    ///
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if deviceDropDownButton != nil {
            setupDropDown()
        }
    }
    
    private func shakeWith(duration: Double, angle: CGFloat, yOffset: CGFloat) {
        print("duration: \(duration) angle: \(angle) offset: \(yOffset)")
        
        self.treeImage.layer.removeAllAnimations()
        
        let numberOfFrames: Double = 1 // 2
        let frameDuration = Double(1/numberOfFrames)
        
        treeImage.layer.anchorPoint = CGPoint(x: 0.5, y: yOffset)

        UIView.animateKeyframes(withDuration: duration, delay: 0, options: [],
          animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0,
                               relativeDuration: frameDuration) {
                self.treeImage.transform = CGAffineTransform(rotationAngle: angle)
            }
//            UIView.addKeyframe(withRelativeStartTime: frameDuration,
//                               relativeDuration: frameDuration) {
//                self.treeImage.transform = CGAffineTransform.identity
//            }
          },
          completion: nil
        )
    }
    
    func setupAnimation(startAngle: CGFloat, endAngle: CGFloat) {
        treeImage.transform = CGAffineTransform.identity
        shakeWith(duration: 5, angle: .pi/2 * endAngle / 90.0, yOffset: 0.9)
        
        /*
        if animationView.isAnimationPlaying {
            animationView.stop()
        }
        
        let animation = Animation.named("tree")
        animationView.animation = animation
        
        // let fillKeypathRotation = AnimationKeypath(keypath: "Layer 1/new.ai.Transform.Rotation")
        // print("Animation details: ", animationView.logHierarchyKeypaths())
        // animationView.setValueProvider(rotationValueProvider, keypath: fillKeypathRotation)

        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 1
        animationView!.play()
        */
    }
    
    ///
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    ///
    @IBAction func onDeviceTap(_ sender: Any) {
        reloadZoneDropDown(deviceList: endDeviceList)
    }
    
    ///
    func setupDropDown() {
        let arrDropDown: [DropDown] = [deviceDropDown]
        arrDropDown.forEach { $0.direction = .any }
        arrDropDown.forEach {
            $0.backgroundColor = UIColor.white
            $0.layer.cornerRadius = 5.0
            $0.clipsToBounds = true
        }
        configureAddressDropdown()
    }
    
    ///
    func configureAddressDropdown() {
        deviceDropDown.direction = .any
        deviceDropDown.anchorView = deviceDropDownButton
        deviceDropDown.width = deviceDropDownButton.frame.width
        deviceDropDown.bottomOffset = CGPoint(x: 0, y: deviceDropDownButton.bounds.height)
        deviceDropDown.selectionAction = { [unowned self] (index, item) in
            self.deviceLabel.text = item.trim() != "Select Device" ? "  " + item : "  " + "Select Device"
            self.deviceLabel.textColor = item.trim() != "Select Device" ? .black : .lightGray
            if item.trim() != "Select Device" && self.delegate != nil{
                self.delegate?.selectedDeviceId(item.trim())
            }
        }
    }
    
    ///
    func reloadZoneDropDown(deviceList: [EndDevice]) {
        var list: [String] = []
        list.append(contentsOf: deviceList.map { $0.deviceId })
        deviceDropDown.dataSource = list
        deviceDropDown.show()
    }
    
    ///
    func configureChart() {
        // lineChart.delegate = self
        // lineChart.chartDescription.enabled = false
        guard lineChart != nil else { return }
        lineChart.dragEnabled = true
        lineChart.setScaleEnabled(true)
        lineChart.pinchZoomEnabled = true
        lineChart.fitScreen()
        // x-axis limit line
        let llXAxis = ChartLimitLine(limit: 10, label: "Index 10")
        llXAxis.lineWidth = 4
        // llXAxis.lineDashLengths = [10, 10, 0]
        llXAxis.labelPosition = .bottomRight
        llXAxis.valueFont = .systemFont(ofSize: 10)
        
        // lineChart.xAxis.gridLineDashLengths = [10, 10]
        // lineChart.xAxis.gridLineDashPhase = 0
        
        // let ll1 = ChartLimitLine(limit: 150, label: "Upper Limit")
        // ll1.lineWidth = 4
        // ll1.lineDashLengths = [5, 5]
        // ll1.labelPosition = .topRight
        // ll1.valueFont = .systemFont(ofSize: 10)
        //
        // let ll2 = ChartLimitLine(limit: -30, label: "Lower Limit")
        // ll2.lineWidth = 4
        // ll2.lineDashLengths = [5,5]
        // ll2.labelPosition = .bottomRight
        // ll2.valueFont = .systemFont(ofSize: 10)
        var xList: [String] = []
        for date in self.timeSeries {
            let dateString = date.timestamp.convertDate(currentDateFormatter: "yyyy-MM-dd HH:mm:ss.SSSS", requiredDateFormatter: "MM/dd,h:mm a")
            let formatteddateList = dateString.hasSuffix("AM") ? date.timestamp.convertDate(currentDateFormatter: "yyyy-MM-dd HH:mm:ss.SSSS", requiredDateFormatter: "MM/dd,h:mm'a") : date.timestamp.convertDate(currentDateFormatter: "yyyy-MM-dd HH:mm:ss.SSSS", requiredDateFormatter: "MM/dd,h:mm'p")
            xList.append(formatteddateList)
        }

        let xAxis = lineChart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 4 // 3
        xAxis.valueFormatter = IndexAxisValueFormatter.init(values: xList)
        
        let leftAxis = lineChart.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.granularity = 45
        leftAxis.labelCount = 5
        // leftAxis.addLimitLine(ll1)
        // leftAxis.addLimitLine(ll2)
        leftAxis.axisMaximum = 90
        leftAxis.axisMinimum = -90
        // leftAxis.gridLineDashLengths = [5, 5]
        leftAxis.drawLimitLinesBehindDataEnabled = true
        
        lineChart.rightAxis.enabled = false
        lineChart.xAxis.drawGridLinesEnabled = false
        lineChart.xAxis.labelPosition = .bottom
        //[_lineChart.viewPortHandler setMaximumScaleY: 2.f];
        //[_lineChart.viewPortHandler setMaximumScaleX: 2.f];
        
        // let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1),
        //       font: .systemFont(ofSize: 12),
        //       textColor: .white,
        //       insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        // marker.lineChart = lineChart
        // marker.minimumSize = CGSize(width: 80, height: 40)
        // lineChart.marker = marker
        
        let customMarker = CustomMakerView(frame: CGRect(x: 0, y: 0, width: 200, height: 80), timeSeries: self.timeSeries)
        lineChart.marker = customMarker
        customMarker.chartView = lineChart
        
        lineChart.legend.form = .line
        // lineChart.legend.enabled = false
        
        // sliderX.value = 45
        // sliderY.value = 100
        // slidersValueChanged(nil)
        
        lineChart.animate(xAxisDuration: 1.0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.setDataCount(self.timeSeries.count)
        }
    }
    
    ///
    func setDataCount(_ count: Int) {
        let values1 = (0..<count).map { (i) -> ChartDataEntry in
            let val = self.timeSeries[i].realZ
            return ChartDataEntry(x: Double(i), y: Double(val))
        }
        lineDataZ = LineChartDataSet(entries: values1, label: "")
        setup(lineDataZ)
        lineDataZ?.setColor(UIColor.init(named: "clr_light_bg") ?? .black)
        lineDataZ?.setCircleColor(UIColor.init(named: "clr_light_bg") ?? .black)
        // lineDataZ?.label = "Z- Front/Back"
        
        let values2 = (0..<count).map { (i) -> ChartDataEntry in
            let val = self.timeSeries[i].realY
            return ChartDataEntry(x: Double(i), y: Double(val))
        }
        lineDataY = LineChartDataSet(entries: values2, label: "")
        setup(lineDataY)
        lineDataY?.setColor(UIColor.init(named: "clr_dark_bg") ?? .blue)
        lineDataY?.setCircleColor(UIColor.init(named: "clr_dark_bg") ?? .blue)
        // lineDataY?.label = "Y- Left/Right"
        
        
        let data = LineChartData()
        if let line1 = lineDataZ, (displayChartLine == .all || displayChartLine == .ZOnly) {
            data.addDataSet(line1)
        }
        if let line2 = lineDataY, (displayChartLine == .all || displayChartLine == .yOnly) {
            data.addDataSet(line2)
        }
        
        lineChart.data = data
    }
    
    private func setup(_ lineDataSet: LineChartDataSet?) {
        guard let dataSet = lineDataSet else { return }
        dataSet.drawIconsEnabled = false
        dataSet.drawValuesEnabled = true
        dataSet.fillAlpha = 1
        dataSet.lineWidth = 1
        dataSet.circleRadius = 5
        dataSet.drawCircleHoleEnabled = true
        dataSet.valueFont = .systemFont(ofSize: 9)
        dataSet.formLineWidth = 1
        dataSet.formSize = 15
        dataSet.drawValuesEnabled = false
        dataSet.mode = .linear
        // dataSet.drawVerticalHighlightIndicatorEnabled = false
        // dataSet.drawHorizontalHighlightIndicatorEnabled = false
    }

    @IBAction func showAllChartline(_ sender: Any) {
        let data = LineChartData()
        if let line1 = lineDataZ {
            data.addDataSet(line1)
        }
        if let line2 = lineDataY {
            data.addDataSet(line2)
        }
        lineChart.data = data
    }
    
    @IBAction func showYChartline(_ sender: Any) {
        let data = LineChartData()
        if let line2 = lineDataY {
            data.addDataSet(line2)
        }
        lineChart.data = data
    }
    
    @IBAction func showZChartline(_ sender: Any) {
        let data = LineChartData()
        if let line1 = lineDataZ {
            data.addDataSet(line1)
        }
        lineChart.data = data
    }
}
