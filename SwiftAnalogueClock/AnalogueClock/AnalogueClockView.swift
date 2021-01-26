//
//  AnalogueClockView.swift
//  AnalogueClock
//
//  Created by Priyesh on 11/01/21.
//

import UIKit

protocol AnalogueClockProtocol: class {
    func time(hours: Int, minutes: Int, seconds: Int, ticks: Int)
}

enum ClockType {
    case roman
    case romanMinimum
    case normal
    case normalMinimum
    case stopWatch
    
    var hourMarkings: [CGFloat: String] {
        switch self {
        case .roman:
            return [-60:"I", -30:"II", 0:"III", 30:"IV", 60:"V", 90:"VI", 120:"VII", 150:"VIII", 180:"IX", -150:"X", -120:"XI", -90:"XII"]
        case .romanMinimum:
            return [0:"III", 90:"VI", 180:"IX", -90:"XII"]
        case .normalMinimum:
            return [0:"3", 90:"6", 180:"9", -90:"12"]
        default:
            return [-60:"1", -30:"2", 0:"3", 30:"4", 60:"5", 90:"6", 120:"7", 150:"8", 180:"9", -150:"10", -120:"11", -90:"12"]
        }
    }
}

final class AnalogueClockView: RoundView, CAAnimationDelegate {
    
    static let secondsHandHeightFactor: CGFloat = 1/2
    static let minutesHandDefaultHeightFactor: CGFloat = 1/3
    static let hoursHandDefaultHeightFactor: CGFloat = 1/4
    static let hourMarkingLabelDefaultFrameFactor: CGFloat = 1/8
    static let defaultClockLineWidth: CGFloat = 10
    static let defaultClockHandsWidth: CGFloat = 7
    static let defaultHoursMarkLineWidth: CGFloat = 5
    static let defaultMinutesMarkLineWidth: CGFloat = 2
    static let twoPi = 2 * CGFloat.pi
    static let secondsHandDurationForFullCircle = CFTimeInterval(60)
    static let minutesHandDurationForFullCircle = CFTimeInterval(3600)
    static let hoursHandDurationForFullCircle = CFTimeInterval(43200)
    
    //MARK:- Clock Customization
    var hideMinuteLines: Bool = false {
        didSet {
            addLayersAndSubViews()
        }
    }
    var hideHourLines: Bool = false {
        didSet {
            addLayersAndSubViews()
        }
    }
    var showOnlyQuarterHourLines: Bool = false {
        didSet {
            addLayersAndSubViews()
        }
    }
    var hideHourMarking: Bool = false {
        didSet {
            addLayersAndSubViews()
        }
    }
    var tickTickAnimationEnabled: Bool = false
    var clockFillColor: UIColor? {
        didSet {
            addLayersAndSubViews()
        }
    }
    var clockStrokeColor: UIColor? {
        didSet {
            addLayersAndSubViews()
        }
    }
    var clockLineWidth: CGFloat = AnalogueClockView.defaultClockLineWidth {
        didSet {
            addLayersAndSubViews()
        }
    }
    var secondsHandHeightFactor: CGFloat = AnalogueClockView.secondsHandHeightFactor {
        didSet {
            addLayersAndSubViews()
        }
    }
    var minutesHandHeightFactor: CGFloat = AnalogueClockView.minutesHandDefaultHeightFactor {
        didSet {
            addLayersAndSubViews()
        }
    }
    var hoursHandHeightFactor: CGFloat = AnalogueClockView.hoursHandDefaultHeightFactor {
        didSet {
            addLayersAndSubViews()
        }
    }
    var hoursMarkLineWidth: CGFloat = AnalogueClockView.defaultHoursMarkLineWidth {
        didSet {
            addLayersAndSubViews()
        }
    }
    var hoursMarkFillColor: UIColor? {
        didSet {
            addLayersAndSubViews()
        }
    }
    var hoursMarkStrokeColor: UIColor? {
        didSet {
            addLayersAndSubViews()
        }
    }
    var minutesMarkLineWidth: CGFloat = AnalogueClockView.defaultMinutesMarkLineWidth {
        didSet {
            addLayersAndSubViews()
        }
    }
    var minutesMarkFillColor: UIColor? {
        didSet {
            addLayersAndSubViews()
        }
    }
    var minutesMarkStrokeColor: UIColor? {
        didSet {
            addLayersAndSubViews()
        }
    }
    //Clock Hour Marking Customization
    var clockType: ClockType? {
        didSet {
            addLayersAndSubViews()
        }
    }
    var hourMarkingTextColor: UIColor = .black {
        didSet {
            addLayersAndSubViews()
        }
    }
    
    //Seconds Hand Customization
    var hideSecondsHand: Bool = false {
        didSet {
            addLayersAndSubViews()
        }
    }
    var secondsHandFillColor: UIColor? {
        didSet {
            addLayersAndSubViews()
        }
    }
    var secondsHandStrokeColor: UIColor? {
        didSet {
            addLayersAndSubViews()
        }
    }
    var secondsHandLineWidth: CGFloat = 1 {
        didSet {
            addLayersAndSubViews()
        }
    }
    var secondsHandCustomPath: UIBezierPath? {
        didSet {
            addLayersAndSubViews()
        }
    }
    var secondsHandWidth: CGFloat = AnalogueClockView.defaultClockHandsWidth {
        didSet {
            addLayersAndSubViews()
        }
    }
    
    //Minutes Hand Customization
    var minutesHandFillColor: UIColor? {
        didSet {
            addLayersAndSubViews()
        }
    }
    var minutesHandStrokeColor: UIColor? {
        didSet {
            addLayersAndSubViews()
        }
    }
    var minutesHandLineWidth: CGFloat = 1 {
        didSet {
            addLayersAndSubViews()
        }
    }
    var minutesHandCustomPath: UIBezierPath? {
        didSet {
            addLayersAndSubViews()
        }
    }
    var minutesHandWidth: CGFloat = AnalogueClockView.defaultClockHandsWidth {
        didSet {
            addLayersAndSubViews()
        }
    }
    
    //Hours Hand Customization
    var hoursHandFillColor: UIColor? {
        didSet {
            addLayersAndSubViews()
        }
    }
    var hoursHandStrokeColor: UIColor? {
        didSet {
            addLayersAndSubViews()
        }
    }
    var hoursHandLineWidth: CGFloat = 1 {
        didSet {
            addLayersAndSubViews()
        }
    }
    var hoursHandCustomPath: UIBezierPath? {
        didSet {
            addLayersAndSubViews()
        }
    }
    var hoursHandWidth: CGFloat = AnalogueClockView.defaultClockHandsWidth {
        didSet {
            addLayersAndSubViews()
        }
    }
    weak var delegate: AnalogueClockProtocol?
    
    //MARK:- Private Vars
    private var stopWatchStartDate: Date?
    private var secondsHandView: SecondHandView?
    private var minuteHandView: ClockHandView?
    private var hoursHandView: ClockHandView?
    private var animationArray: [CAAnimation]?
    private var customLayers = [CALayer]()
    private var secondHandAnimationCount = 0
    private var timer: Timer?
    private var runCount = 0
    
    //MARK:- View Cycle
    override var bounds: CGRect {
        didSet {
            addLayersAndSubViews()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addLayersAndSubViews()
    }
    
    override func draw(_ rect: CGRect) {
        addLayersAndSubViews()
    }
    
    func runClockOn(date: Date?) {
        if self.clockType != .stopWatch {
            let timeComponents = DateUtil.timeComponents(date: date)
            let secondsStartRadian = CGFloat(timeComponents.seconds)*CGFloat.pi/30
            let minuteStartRadian = CGFloat(timeComponents.minutes)*CGFloat.pi/30
            let hourStartRadian =  CGFloat(timeComponents.hour)*CGFloat.pi/6 +  CGFloat(timeComponents.minutes)*CGFloat.pi/360
            setAnchorPoints()
            minuteHandView?.addLayerAnimation(startAngle: minuteStartRadian, endAngle: AnalogueClockView.twoPi + minuteStartRadian, duration: AnalogueClockView.minutesHandDurationForFullCircle, repeatAnimation: true)
            hoursHandView?.addLayerAnimation(startAngle: hourStartRadian, endAngle: AnalogueClockView.twoPi + hourStartRadian, duration: AnalogueClockView.hoursHandDurationForFullCircle, repeatAnimation: true)
            if tickTickAnimationEnabled {
                addTickTickSecondsHandViewAnimation(startRadian: secondsStartRadian)
            } else {
                secondsHandView?.addLayerAnimation(startAngle: secondsStartRadian, endAngle: AnalogueClockView.twoPi + secondsStartRadian, duration: AnalogueClockView.secondsHandDurationForFullCircle, repeatAnimation: true)
            }
        }
    }
    
    func start() {
        if self.clockType == .stopWatch {
            setAnchorPoints()
            stopWatchStartDate = Date()
            if timer == nil {
                DispatchQueue.main.async {
                    self.timer = Timer.scheduledTimer(timeInterval: 1/60, target: self, selector: #selector(self.fireTimer), userInfo: nil, repeats: true)
                }
            }
            minuteHandView?.addLayerAnimation(startAngle: 0, endAngle: AnalogueClockView.twoPi, duration: AnalogueClockView.minutesHandDurationForFullCircle, repeatAnimation: true)
            secondsHandView?.addLayerAnimation(startAngle: 0, endAngle: AnalogueClockView.twoPi, duration: AnalogueClockView.secondsHandDurationForFullCircle, repeatAnimation: true)
        }
    }
    
    func stop() {
        secondsHandView?.pause()
        minuteHandView?.pause()
        if self.clockType == .stopWatch {
            invalidateTimer()
        }
    }
    
    @objc func fireTimer() {
        runCount += 1
        if runCount == 60 {
            runCount = 0
        }
        let date = Date()
        delegate?.time(hours: date.hours(from: stopWatchStartDate ?? date), minutes: date.minutes(from: stopWatchStartDate ?? date), seconds: date.seconds(from: stopWatchStartDate ?? date)%60, ticks: runCount)
    }
    
    private func invalidateTimer() {
        if timer != nil {
            DispatchQueue.main.async {
                self.timer?.invalidate()
                self.timer = nil
            }
            runCount = 0
        }
    }
    
    private func addLayersAndSubViews() {
        addBaseLayers()
        addHands()
    }
    
    private func addBaseLayers() {
        self.customLayers.forEach { $0.removeFromSuperlayer() }
        self.customLayers.removeAll()
        customLayers.append(LayerUtil.arcLayer(arcCenter: CGPoint(x: bounds.width/2, y: bounds.height/2), radius: bounds.height/2, startAngle: 0, endAngle: 2 * CGFloat.pi, strokeColor: clockStrokeColor ?? .black, lineWidth: clockLineWidth, fillColor: clockFillColor ?? .clear, clockWise: true))
        addMinuteAndHourLines()
        if !hideHourMarking {
            addHourHandMarkLayers()
        }
        self.customLayers.forEach { self.layer.addSublayer($0) }
    }
    
    private func addHourHandMarkLayers() {
        let hourMarkingWidth =  bounds.width*AnalogueClockView.hourMarkingLabelDefaultFrameFactor
        let hourMarkingHeight = bounds.height*AnalogueClockView.hourMarkingLabelDefaultFrameFactor
        let diagonalMiddlePointDistance = ((hourMarkingWidth*hourMarkingWidth + hourMarkingHeight*hourMarkingHeight).squareRoot()/2).rounded() * 1.5 // Adjusting
        for (angle, markingString) in clockType?.hourMarkings ?? ClockType.normal.hourMarkings {
            let textLayer = CATextLayer()
            textLayer.string = markingString
            textLayer.alignmentMode = .center
            textLayer.foregroundColor = hourMarkingTextColor.cgColor
            textLayer.backgroundColor = UIColor.clear.cgColor
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.fontSize = hourMarkingWidth*3/4
            textLayer.frame = CGRect(x: 0,y: 0, width: hourMarkingWidth, height: hourMarkingHeight)
            // Place the label's centre as a point on a circle with centre (bounds.width/2, bounds.height/2) and radius (bounds.width/2  - diagonalMiddlePointDistance)
            textLayer.position = CGPoint(x: (bounds.width/2) + (bounds.width/2  - diagonalMiddlePointDistance)*cos(CGFloat(angle).degreesToRadians), y: (bounds.height/2) + (bounds.height/2 - diagonalMiddlePointDistance)*sin(CGFloat(angle).degreesToRadians))
            textLayer.isWrapped = true
            customLayers.append(textLayer)
        }
    }
    
    private func addHands() {
        self.hoursHandView?.removeFromSuperview()
        self.minuteHandView?.removeFromSuperview()
        self.secondsHandView?.removeFromSuperview()
        if clockType != .stopWatch {
            let hoursHandView = ClockHandView()
            self.hoursHandView = hoursHandView
            hoursHandView.strokeColor = hoursHandStrokeColor
            hoursHandView.lineWidth = hoursHandLineWidth
            hoursHandView.fillColor = hoursHandFillColor
            hoursHandView.customPath = hoursHandCustomPath
            self.addSubview(hoursHandView)
            hoursHandView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                hoursHandView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                hoursHandView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -(bounds.height * hoursHandHeightFactor)/2),
                hoursHandView.heightAnchor.constraint(equalToConstant: bounds.height * hoursHandHeightFactor),
                hoursHandView.widthAnchor.constraint(equalToConstant: hoursHandWidth)
            ])
        }
        
        let minutesHandView = ClockHandView()
        self.minuteHandView = minutesHandView
        minutesHandView.strokeColor = minutesHandStrokeColor
        minutesHandView.lineWidth = minutesHandLineWidth
        minutesHandView.fillColor = minutesHandFillColor
        minutesHandView.customPath = minutesHandCustomPath
        self.addSubview(minutesHandView)
        minutesHandView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            minutesHandView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            minutesHandView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -(bounds.height * minutesHandHeightFactor)/2),
            minutesHandView.heightAnchor.constraint(equalToConstant: bounds.height * minutesHandHeightFactor),
            minutesHandView.widthAnchor.constraint(equalToConstant: minutesHandWidth)
        ])
        
        if !hideSecondsHand {
            let secondsHandView = SecondHandView()
            self.secondsHandView = secondsHandView
            secondsHandView.strokeColor = secondsHandStrokeColor
            secondsHandView.lineWidth = secondsHandLineWidth
            secondsHandView.fillColor = secondsHandFillColor
            secondsHandView.customPath = secondsHandCustomPath
            self.addSubview(secondsHandView)
            secondsHandView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                secondsHandView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                secondsHandView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -(bounds.height * secondsHandHeightFactor)/4),
                secondsHandView.heightAnchor.constraint(equalToConstant: bounds.height * secondsHandHeightFactor),
                secondsHandView.widthAnchor.constraint(equalToConstant: secondsHandWidth)
            ])
        }
    }
    
    private func setAnchorPoints() {
        secondsHandView?.setAnchorPoint(CGPoint(x: 0.5, y: 3/4))
        minuteHandView?.setAnchorPoint(CGPoint(x: 0.5, y: 1))
        hoursHandView?.setAnchorPoint(CGPoint(x: 0.5, y: 1))
    }
    
    private func addTickTickSecondsHandViewAnimation(startRadian: CGFloat) {
        animationArray = [CAAnimation]()
        for angle in stride(from: startRadian, to: 2*CGFloat.pi + startRadian, by: CGFloat.pi/30)  {
            let animation = LayerUtil.rotateLayerAnimation(startAngle: angle, endAngle: angle + CGFloat.pi/30, duration: 0.1)
            animation.delegate = self
            animationArray?.append(animation)
        }
        if let nextAnimation = animationArray?.first {
            secondHandAnimationCount = 1
            secondsHandView?.addLayerAnimation(animation: nextAnimation)
        }
    }
    
    private func addMinuteAndHourLines() {
        if !hideMinuteLines {
            addMinuteLines()
            customLayers.append(LayerUtil.arcLayer(arcCenter:  CGPoint(x: bounds.width/2, y: bounds.height/2), radius: bounds.height/2 - (hideHourMarking ? (bounds.height/12) :(bounds.height/18)), startAngle: 0, endAngle: 2 * CGFloat.pi, strokeColor: .clear, lineWidth: 0, fillColor: clockFillColor ?? .white, clockWise: true))
        }
        if !hideHourLines {
            addHourLines()
            customLayers.append(LayerUtil.arcLayer(arcCenter:  CGPoint(x: bounds.width/2, y: bounds.height/2), radius: bounds.height/2 - (hideHourMarking ? (bounds.height/8) :(bounds.height/12)), startAngle: 0, endAngle: 2 * CGFloat.pi, strokeColor: .clear, lineWidth: 0, fillColor: clockFillColor ?? .white, clockWise: true))
        }
    }
    
    private func addHourLines() {
        for angle in stride(from: 0, to: CGFloat(360), by: 30) where showOnlyQuarterHourLines ? angle.truncatingRemainder(dividingBy: 90) == 0 : true {
            let points = startAndEndPointsInCircle(angle: angle)
            customLayers.append(LayerUtil.lineLayer(startPoint: CGPoint(x: points.startX, y: points.startY), endPoint:  CGPoint(x: points.endX, y: points.endY), lineWidth: hoursMarkLineWidth, fillColor: hoursMarkFillColor ?? .black, strokeColor: hoursMarkStrokeColor ?? .black))
        }
    }
    
    private func addMinuteLines() {
        for angle in stride(from: 0, to: CGFloat(360), by: 6) {
            let points = startAndEndPointsInCircle(angle: angle)
            customLayers.append(LayerUtil.lineLayer(startPoint: CGPoint(x: points.startX, y: points.startY), endPoint:  CGPoint(x: points.endX, y: points.endY), lineWidth: minutesMarkLineWidth, fillColor: minutesMarkFillColor ?? .black, strokeColor: minutesMarkStrokeColor ?? .black))
        }
    }
    
    private func startAndEndPointsInCircle(angle: CGFloat) -> (startX: CGFloat, startY: CGFloat, endX: CGFloat, endY: CGFloat) {
        return ((bounds.width/2) + (bounds.width/2)*cos(angle.degreesToRadians), (bounds.width/2) + (bounds.width/2)*sin(angle.degreesToRadians),(bounds.width/2) + (bounds.width/2)*cos((180+angle).degreesToRadians), (bounds.width/2) + (bounds.width/2)*sin((180+angle).degreesToRadians))
    }
    
    //MARK:- CAAnimationDelegate
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        secondHandAnimationCount += 1
        guard let handViewAnimationArray = animationArray else { return }
        if handViewAnimationArray.count > secondHandAnimationCount {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                self.secondsHandView?.addLayerAnimation(animation: handViewAnimationArray[self.secondHandAnimationCount - 1])
            }
        } else if handViewAnimationArray.count > 0 {
            secondHandAnimationCount = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                self.secondsHandView?.addLayerAnimation(animation: handViewAnimationArray[0])
            }
        }
    }
}
