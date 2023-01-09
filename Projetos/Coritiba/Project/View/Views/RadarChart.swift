//
//  RadarChart.swift
//
//
//  Created by Roberto Oliveira on 12/04/18.
//  Copyright © 2018 SportsMatch. All rights reserved.
//

import UIKit

enum RadarChartPosition {
    case topLeft
    case topRight
    case centerLeft
    case centerRight
    case bottomLeft
    case bottomRight
}

struct RadarChartInfo {
    var topLeft:RadarChartInfoItem
    var topRight:RadarChartInfoItem
    var centerRight:RadarChartInfoItem
    var bottomRight:RadarChartInfoItem
    var bottomLeft:RadarChartInfoItem
    var centerLeft:RadarChartInfoItem
}

struct RadarChartInfoItem {
    var title:String
    var maxValue:Float
    var value:Float
    var isPercentage:Bool
}

class RadarChart: UIView {
    
    // MARK: - Options
    private let matrixPathInset:CGFloat = 20.0
    var matrixCornerRadius:CGFloat = 0.0
    var matrixOutlineReferences:Int = 4
    var matrixLastReferenceMultiplier:CGFloat = 0.3
    var matrixBorderColor:UIColor = UIColor.white
    var matrixBorderWidth:CGFloat = 1.0
    var matrixLastReferenceFillColor:UIColor = UIColor.white.withAlphaComponent(0.3)
    var progressBackgroundColor:UIColor = UIColor.clear
    var progressBorderColor:UIColor = UIColor.clear
    var progressBorderWidth:CGFloat = 2.0
    
    // MARK: - Display mode Options
    var displayLabels:Bool = true
    var displayLabelValues:Bool = true
    var displayMatrix:Bool = true
    
    
    
    
    // MARK: - DataSource Properties
    private var currentInfo:RadarChartInfo?
    private var titles:[String] = ["", "", "", "", "", ""]
    private var maxValues:[Float] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    private var values:[Float] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    
    
    
    
    // MARK: - Objects
    private let progressShapeLayer = CAShapeLayer()
    private let label0:RadarChartLabelView = RadarChartLabelView()
    private let label1:RadarChartLabelView = RadarChartLabelView()
    private let label2:RadarChartLabelView = RadarChartLabelView()
    private let label3:RadarChartLabelView = RadarChartLabelView()
    private let label4:RadarChartLabelView = RadarChartLabelView()
    private let label5:RadarChartLabelView = RadarChartLabelView()
    
    
    
    
    
    
    // MARK: - Public Methods
    func updateValues(item:RadarChartInfo, animationTime:TimeInterval) {
        self.currentInfo = item
        self.titles.removeAll()
        self.maxValues.removeAll()
        self.values.removeAll()
        self.titles = [item.topLeft.title, item.topRight.title, item.centerRight.title, item.bottomRight.title, item.bottomLeft.title, item.centerLeft.title]
        self.maxValues = [item.topLeft.maxValue, item.topRight.maxValue, item.centerRight.maxValue, item.bottomRight.maxValue, item.bottomLeft.maxValue, item.centerLeft.maxValue]
        self.values = [item.topLeft.value, item.topRight.value, item.centerRight.value, item.bottomRight.value, item.bottomLeft.value, item.centerLeft.value]
        if self.displayLabels {
            self.updateLabels()
        }
        self.updateProgressShapeLayer(duration: animationTime)
    }
    
    
    
    
    
    
    
    // MARK: - Matrix Methods
    private func matrixPath(size:CGSize) -> UIBezierPath {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: size.width-(self.matrixCornerRadius/3), y: (size.height/2)+self.matrixCornerRadius))
        bezierPath.addLine(to: CGPoint(x: (size.width*0.75)+(self.matrixCornerRadius*0.66), y: size.height-self.matrixCornerRadius))
        bezierPath.addCurve(to: CGPoint(x: (size.width*0.75)-self.matrixCornerRadius, y: size.height),
                            controlPoint1: CGPoint(x: (size.width*0.75)+(self.matrixCornerRadius/3), y: size.height-(self.matrixCornerRadius/3)),
                            controlPoint2: CGPoint(x: (size.width*0.75)-(self.matrixCornerRadius/3), y: size.height))
        bezierPath.addLine(to: CGPoint(x: (size.width*0.25)+self.matrixCornerRadius, y: size.height))
        bezierPath.addCurve(to: CGPoint(x: (size.width*0.25)-(self.matrixCornerRadius*0.66), y: size.height-self.matrixCornerRadius),
                            controlPoint1: CGPoint(x: (size.width*0.25)+(self.matrixCornerRadius/3), y: size.height),
                            controlPoint2: CGPoint(x: (size.width*0.25)-(self.matrixCornerRadius/3), y: size.height-(self.matrixCornerRadius/2)))
        bezierPath.addLine(to: CGPoint(x: (self.matrixCornerRadius/3), y: (size.height/2)+self.matrixCornerRadius))
        bezierPath.addCurve(to: CGPoint(x: (self.matrixCornerRadius/3), y: (size.height/2)-self.matrixCornerRadius),
                            controlPoint1: CGPoint(x: 0, y: (size.height/2)+(self.matrixCornerRadius/3)),
                            controlPoint2: CGPoint(x: 0, y: (size.height/2)-(self.matrixCornerRadius/3)))
        bezierPath.addLine(to: CGPoint(x: (size.width*0.25)-(self.matrixCornerRadius*0.66), y: self.matrixCornerRadius))
        bezierPath.addCurve(to: CGPoint(x: (size.width*0.25)+self.matrixCornerRadius, y: 0),
                            controlPoint1: CGPoint(x: (size.width*0.25)-(self.matrixCornerRadius/3), y: self.matrixCornerRadius/3),
                            controlPoint2: CGPoint(x: (size.width*0.25)+(self.matrixCornerRadius/3), y: 0))
        bezierPath.addLine(to: CGPoint(x: (size.width*0.75)-self.matrixCornerRadius, y: 0))
        bezierPath.addCurve(to: CGPoint(x: (size.width*0.75)+(self.matrixCornerRadius*0.66), y: self.matrixCornerRadius),
                            controlPoint1: CGPoint(x: (size.width*0.75)-(self.matrixCornerRadius/3), y: 0),
                            controlPoint2: CGPoint(x: (size.width*0.75)+(self.matrixCornerRadius/3), y: self.matrixCornerRadius/3))
        bezierPath.addLine(to: CGPoint(x: size.width-(self.matrixCornerRadius/3), y: (size.height/2)-self.matrixCornerRadius))
        bezierPath.addCurve(to: CGPoint(x: size.width-(self.matrixCornerRadius/3), y: (size.height/2)+self.matrixCornerRadius),
                            controlPoint1: CGPoint(x: size.width, y: (size.height/2)-(self.matrixCornerRadius/3)),
                            controlPoint2: CGPoint(x: size.width, y: (size.height/2)+(self.matrixCornerRadius/3)))
        bezierPath.close()
        return bezierPath
        
    }
    
    private func setupMatrixLayer(rect: CGRect) {
        // Remove previous Layers
        if let sublayers = self.layer.sublayers {
            for sub in sublayers {
                sub.removeFromSuperlayer()
            }
        }
        // Create a base frame by considering matrix path insets
        let baseFrame = CGRect(x: 0, y: 0, width: rect.width-(self.matrixPathInset*2), height: rect.height-(self.matrixPathInset*2))
        
        // Create multiplier values for reference outlines
        var multipliers:[CGFloat] = [1.0]
        if self.matrixOutlineReferences > 0 {
            for index in 0...self.matrixOutlineReferences {
                let value:CGFloat = (1.0-self.matrixLastReferenceMultiplier)/(CGFloat(self.matrixOutlineReferences)+1)
                multipliers.append(1.0-(value*(CGFloat(index+1))))
            }
        }
        multipliers.append(self.matrixLastReferenceMultiplier)
        
        // Create Each matrix layer based on multipliers
        for (index, multiplier) in multipliers.enumerated() {
            let currentFrame = CGRect(x: 0, y: 0, width: baseFrame.width*multiplier, height: baseFrame.height*multiplier)
            let shapeLayer = CAShapeLayer()
            shapeLayer.lineWidth = self.matrixBorderWidth
            shapeLayer.strokeColor = self.matrixBorderColor.cgColor
            shapeLayer.fillColor = nil
            if index == multipliers.count-1 {
                shapeLayer.fillColor = self.matrixLastReferenceFillColor.cgColor
            }
            shapeLayer.lineJoin = CAShapeLayerLineJoin.round
            shapeLayer.path = self.matrixPath(size: currentFrame.size).cgPath
            shapeLayer.frame = CGRect(x: (self.frame.width-currentFrame.width)/2, y: (self.frame.height-currentFrame.height)/2, width: currentFrame.width, height: currentFrame.height)
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Progress Methods
    private func updateProgressShapeLayer(duration:TimeInterval) {
        let rect = self.bounds
        let path = self.progressShapeLayerPath(in: rect).cgPath
        self.progressShapeLayer.animatePathChange(newPath: path, duration: duration)
        self.progressShapeLayer.path = path
    }
    
    private func setupProgressLayers(rect: CGRect) {
        self.updateProgressShapeLayer(duration: 0.0)
        self.progressShapeLayer.lineWidth = self.progressBorderWidth
        self.progressShapeLayer.strokeColor = self.progressBorderColor.cgColor
        self.progressShapeLayer.fillColor = self.progressBackgroundColor.cgColor
        self.progressShapeLayer.lineJoin = CAShapeLayerLineJoin.round
        self.progressShapeLayer.path = self.progressShapeLayerPath(in: rect).cgPath
        self.progressShapeLayer.frame = rect
    }
    
    private func progressShapeLayerPath(in rect:CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: self.getPointForProgress(self.calculateProgress(at: 0), at: .topLeft, in: rect))
        path.addLine(to: self.getPointForProgress(self.calculateProgress(at: 1), at: .topRight, in: rect))
        path.addLine(to: self.getPointForProgress(self.calculateProgress(at: 2), at: .centerRight, in: rect))
        path.addLine(to: self.getPointForProgress(self.calculateProgress(at: 3), at: .bottomRight, in: rect))
        path.addLine(to: self.getPointForProgress(self.calculateProgress(at: 4), at: .bottomLeft, in: rect))
        path.addLine(to: self.getPointForProgress(self.calculateProgress(at: 5), at: .centerLeft, in: rect))
        path.close()
        return path
    }
    
    private func calculateProgress(at index:Int) -> CGFloat {
        let progress = CGFloat(self.values[index]) / CGFloat(self.maxValues[index])
        let minValue = min(1.0, progress)
        return (self.maxValues[index] == 0) ? 0 : minValue
    }
    
    private func getPointForProgress(_ progress:CGFloat, at position:RadarChartPosition, in rect: CGRect) -> CGPoint {
        // Get Main matrix size
        let matrixWidth = rect.width-(self.matrixPathInset*2)
        let matrixHeight = rect.height-(self.matrixPathInset*2)
        
        // Get Key Points
        let progressOriginX = rect.width/2-(matrixWidth*0.25)
        let progressOriginY = self.matrixPathInset
        let progressFinalX = rect.width/2-((matrixWidth*self.matrixLastReferenceMultiplier)*0.25)
        let progressFinalY = rect.height/2-((matrixHeight*self.matrixLastReferenceMultiplier)*0.5)
        
        // Calculate Progress area
        var progressWidth = progressFinalX - progressOriginX
        let progressHeight = progressFinalY - progressOriginY
        
        // Calculate Final Points
        var xPoint:CGFloat = progressOriginX + (progressWidth*(1.0-progress))
        var yPoint:CGFloat = progressOriginY + (progressHeight*(1.0-progress))
        
        
        // Ajust Final Points according to chart position
        switch position {
        case .topLeft:
            // Default is topLeft, so no change is needed
            break
        case .topRight:
            xPoint = (rect.width/2) + ((matrixWidth*self.matrixLastReferenceMultiplier)*0.25) + (progressWidth*progress)
            break
        case .centerLeft:
            progressWidth = (matrixWidth-(matrixWidth*self.matrixLastReferenceMultiplier))/2
            xPoint = self.matrixPathInset + (progressWidth*(1.0-progress))
            yPoint = rect.height/2
            break
        case .centerRight:
            progressWidth = (matrixWidth-(matrixWidth*self.matrixLastReferenceMultiplier))/2
            xPoint = (rect.width-self.matrixPathInset)-(progressWidth*(1.0-progress))
            yPoint = rect.height/2
            break
        case .bottomLeft:
            yPoint = (rect.height-self.matrixPathInset)-(progressHeight*(1.0-progress))
            break
        case .bottomRight:
            xPoint = (rect.width/2) + ((matrixWidth*self.matrixLastReferenceMultiplier)*0.25) + (progressWidth*progress)
            yPoint = (rect.height-self.matrixPathInset)-(progressHeight*(1.0-progress))
            break
        }
        
        return CGPoint(x: xPoint, y: yPoint)
    }
    
    
    
    
    
    
    
    
    // MARK: - Label Methods
    private func updateLabels() {
        guard let item = self.currentInfo else {return}
        var value0:String?
        if self.displayLabelValues {
            let info = self.values[0].formattedDescription()
            if item.topLeft.isPercentage {
                value0 = "\(info)%"
            } else {
                value0 = info
            }
        }
        self.label0.updateContent(title: self.titles[0], value: value0)
        
        var value1:String?
        if self.displayLabelValues {
            let info = self.values[1].formattedDescription()
            if item.topRight.isPercentage {
                value1 = "\(info)%"
            } else {
                value1 = info
            }
        }
        self.label1.updateContent(title: self.titles[1], value: value1)
        
        var value2:String?
        if self.displayLabelValues {
            let info = self.values[2].formattedDescription()
            if item.centerRight.isPercentage {
                value2 = "\(info)%"
            } else {
                value2 = info
            }
        }
        self.label2.updateContent(title: self.titles[2], value: value2)
        
        var value3:String?
        if self.displayLabelValues {
            let info = self.values[3].formattedDescription()
            if item.bottomRight.isPercentage {
                value3 = "\(info)%"
            } else {
                value3 = info
            }
        }
        self.label3.updateContent(title: self.titles[3], value: value3)
        
        var value4:String?
        if self.displayLabelValues {
            let info = self.values[4].formattedDescription()
            if item.bottomLeft.isPercentage {
                value4 = "\(info)%"
            } else {
                value4 = info
            }
        }
        self.label4.updateContent(title: self.titles[4], value: value4)
        
        var value5:String?
        if self.displayLabelValues {
            let info = self.values[5].formattedDescription()
            if item.centerLeft.isPercentage {
                value5 = "\(info)%"
            } else {
                value5 = info
            }
        }
        self.label5.updateContent(title: self.titles[5], value: value5)
    }
    
    private func setupLabels(rect: CGRect) {
        let matrixWidth = rect.width-(self.matrixPathInset*2)
        //let matrixHeight = rect.height-(self.matrixPathInset*2)
        let defaultWidth:CGFloat = 64
        // Label 0
        self.addSubview(self.label0)
        self.addTopAlignmentConstraintTo(subView: self.label0, constant: 0)
        self.addCenterXAlignmentConstraintTo(subView: self.label0, constant: -((matrixWidth/4) + (self.matrixPathInset*0.75)))
        self.label0.addWidthConstraint(defaultWidth)
        // Label 1
        self.addSubview(self.label1)
        self.addTopAlignmentConstraintTo(subView: self.label1, constant: 0)
        self.addCenterXAlignmentConstraintTo(subView: self.label1, constant: ((matrixWidth/4) + (self.matrixPathInset*0.75)))
        self.label1.addWidthConstraint(defaultWidth)
        // Label 2
        self.addSubview(self.label2)
        //        self.addTrailingAlignmentConstraintTo(subView: self.label2, constant: 0)
        self.addConstraint(NSLayoutConstraint(item: self.label2, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -self.matrixPathInset))
        self.addCenterYAlignmentConstraintTo(subView: self.label2, constant: 0)
        self.label2.addWidthConstraint(defaultWidth)
        // Label 3
        self.addSubview(self.label3)
        //        self.addCenterYAlignmentConstraintTo(subView: self.label3, constant: (matrixHeight/2)+20)
        self.addBottomAlignmentConstraintTo(subView: self.label3, constant: 0)
        self.addCenterXAlignmentConstraintTo(subView: self.label3, constant: ((matrixWidth/4)+(self.matrixPathInset/2)))
        self.label3.addWidthConstraint(defaultWidth)
        // Label 4
        self.addSubview(self.label4)
        //        self.addCenterYAlignmentConstraintTo(subView: self.label4, constant: (matrixHeight/2)+20)
        self.addBottomAlignmentConstraintTo(subView: self.label4, constant: 0)
        self.addCenterXAlignmentConstraintTo(subView: self.label4, constant: -((matrixWidth/4)+(self.matrixPathInset/2)))
        self.label4.addWidthConstraint(defaultWidth)
        // Label 5
        self.addSubview(self.label5)
        //        self.addLeadingAlignmentConstraintTo(subView: self.label5, constant: 0)
        self.addConstraint(NSLayoutConstraint(item: self.label5, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: self.matrixPathInset))
        self.addCenterYAlignmentConstraintTo(subView: self.label5, constant: 0)
        self.label5.addWidthConstraint(defaultWidth)
    }
    
    
    
    
    
    
    
    
    
    // MARK: - Super Methods
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if self.displayMatrix {
            self.setupMatrixLayer(rect: rect)
        }
        self.setupProgressLayers(rect: rect)
        self.layer.addSublayer(progressShapeLayer)
        if self.displayLabels {
            self.setupLabels(rect: rect)
        }
    }
    
    
    
    
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
    
}






// MARK: - RadarChartLabelView
class RadarChartLabelView: UIView {
    
    // MARK: - Objects
    private let stackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .vertical
        vw.alignment = .center
        vw.distribution = .fill
        vw.spacing = 0.0
        return vw
    }()
    private let lblValue:PaddingLabel = {
        let lbl = PaddingLabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 16)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.1
        lbl.textColor = Theme.color(.AlternativeCardElements)
        lbl.clipsToBounds = true
        lbl.isHidden = true
        return lbl
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 3
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Medium, size: 9)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        lbl.textColor = Theme.color(Theme.Color.AlternativeCardElements)
        return lbl
    }()
    private let ivFlag:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.backgroundColor = UIColor.clear
        iv.image = UIImage(named: "chart_flag")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = Theme.color(Theme.Color.AlternativeCardBackground)
        return iv
    }()
    
    
    
    // MARK: - Methods
    func updateContent(title:String, value:String?) {
        self.lblTitle.text = title
        self.lblTitle.setSpaceBetweenLines(space: 3)
        self.lblValue.text = value
        self.lblValue.isHidden = value == nil
    }
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSize.zero
        // Stack
        self.addSubview(self.stackView)
        self.addBoundsConstraintsTo(subView: self.stackView, leading: 0, trailing: 0, top: 12, bottom: nil)
        self.stackView.addArrangedSubview(self.lblTitle)
        self.stackView.addArrangedSubview(self.lblValue)
        // flag
        self.insertSubview(self.ivFlag, belowSubview: self.stackView)
//        self.addLeadingAlignmentRelatedConstraintTo(subView: self.ivFlag, reference: self.lblValue, constant: 0)
//        self.addTrailingAlignmentRelatedConstraintTo(subView: self.ivFlag, reference: self.lblValue, constant: 0)
//        self.addTopAlignmentConstraintTo(subView: self.ivFlag, constant: 0)
//        self.addConstraint(NSLayoutConstraint(item: self.ivFlag, attribute: .width, relatedBy: .equal, toItem: self.ivFlag, attribute: .height, multiplier: 1.0, constant: 0))
//        self.addBottomAlignmentConstraintTo(subView: self.ivFlag, constant: 0)
        self.addBoundsConstraintsTo(subView: self.ivFlag, leading: nil, trailing: nil, top: 0, bottom: 0)
        self.addCenterXAlignmentRelatedConstraintTo(subView: self.ivFlag, reference: self.lblTitle, constant: 0)
        self.addWidthRelatedConstraintTo(subView: self.ivFlag, reference: self.lblTitle, relatedBy: .equal, multiplier: 1.0, constant: 6.0, priority: 999)
        
//        self.backgroundColor = UIColor.black
//        self.ivFlag.backgroundColor = UIColor.yellow
//        self.lblTitle.backgroundColor = UIColor.green
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
    
}




