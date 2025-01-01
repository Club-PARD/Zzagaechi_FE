import UIKit

class MainTableViewCell : UITableViewCell {
    //MARK: - property
    enum CellType {
        case plan
        case detail
    }
    
    
    private var strikethroughLayer: CAShapeLayer?
    
    let titleTaskLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        return label
    }()
    
    let taskLabel : UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.6606984735, green: 0.6606983542, blue: 0.6606983542, alpha: 1)
        label.font = UIFont(name: "Pretendard-Regular", size: 17)
        return label
    }()
    
    let timeLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Pretendard-Regular", size: 17)
        return label
    }()
    
    
    
    let clearView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let cellView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 25.5
        view.layer.borderColor = #colorLiteral(red: 0.7294117647, green: 0.8117647059, blue: 0.9568627451, alpha: 1)
        return view
    }()
    
    let checkButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "noCheck"), for: .normal)
        button.setImage(UIImage(named: "yesCheck"), for: .selected)
        return button
    }()
    
    
    
    
    
    
    //MARK: - main
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "mainTableViewCell")
        self.backgroundColor = .clear
        
        setUI()
        checkButton.addTarget(self, action: #selector(toggleButtonState), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 레이아웃이 변경될 때마다 줄의 위치 업데이트
        if checkButton.isSelected {
            addStrikethrough()
        }
    }
    //MARK: - function
    func setUI(){
        [taskLabel,clearView,cellView,checkButton,timeLabel,titleTaskLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        contentView.addSubview(clearView)
        clearView.addSubview(cellView)
        cellView.addSubview(taskLabel)
        cellView.addSubview(checkButton)
        cellView.addSubview(titleTaskLabel)
        
        
        NSLayoutConstraint.activate([
            clearView.topAnchor.constraint(equalTo: contentView.topAnchor),
            clearView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            clearView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            clearView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            cellView.leadingAnchor.constraint(equalTo:  clearView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: clearView.trailingAnchor),
            cellView.topAnchor.constraint(equalTo: clearView.topAnchor, constant: 5),
            cellView.bottomAnchor.constraint(equalTo: clearView.bottomAnchor,constant: -5),
            
            checkButton.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 20),
            checkButton.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 34),
            
            
            
            
        ])
        
        
    }
    
    @objc func toggleButtonState(){
        checkButton.isSelected.toggle()
        if checkButton.isSelected {
            addStrikethrough()
        } else {
            removeStrikethrough()
        }
    }
    
    private func addStrikethrough() {
        // 기존 줄이 있다면 제거
        removeStrikethrough()
        
        // 새로운 CAShapeLayer 생성
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = #colorLiteral(red: 0.3019607843, green: 0.5568627451, blue: 1, alpha: 1).cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.lineCap = .round
        
        // UIBezierPath로 줄 그리기
        let path = UIBezierPath()
        let startPoint = CGPoint(x: taskLabel.frame.minX, y: taskLabel.frame.midY)
        let endPoint = CGPoint(x: taskLabel.frame.maxX, y: taskLabel.frame.midY)
        
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        // 애니메이션 설정
        shapeLayer.path = path.cgPath
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.2
        
        shapeLayer.add(animation, forKey: "lineAnimation")
        
        // 레이어 저장 및 추가
        strikethroughLayer = shapeLayer
        cellView.layer.addSublayer(shapeLayer)
        
        // 텍스트 색상 변경
        taskLabel.textColor = UIColor.gray
    }
    
    private func removeStrikethrough() {
        strikethroughLayer?.removeFromSuperlayer()
        strikethroughLayer = nil
        taskLabel.textColor = .white
    }
    
    func configure(with plan: Plan, type: CellType) {
        taskLabel.text = plan.plantitle
        timeLabel.isHidden = true
        
        titleTaskLabel.isHidden = true
        taskLabel.removeFromSuperview()
        checkButton.setImage(UIImage(named: "noCheckPlan"), for: .normal)
        checkButton.setImage(UIImage(named: "yesCheck"), for: .selected)
        
        taskLabel.textColor = .white
        
        cellView.addSubview(taskLabel)
        NSLayoutConstraint.activate([
            taskLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 57),
            taskLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor)
        ])
        // 노란색 테마 적용
        cellView.layer.borderColor = #colorLiteral(red: 0.9568627451, green: 0.9450980392, blue: 0.7294117647, alpha: 1).cgColor  // 노란색
        checkButton.isSelected = plan.completed
    }
    
    func configure(with detail: Detail, type: CellType) {
        taskLabel.text = detail.plansubtitle
        titleTaskLabel.text = detail.content
        
        taskLabel.font = UIFont(name: "Pretendard-Regular", size: 12)
        titleTaskLabel.font = UIFont(name: "Pretendard-Regular", size: 17)
        
        
        
        let startTime = detail.startTime.prefix(5)
        let endTime = detail.endTime.prefix(5)
        timeLabel.text = "\(startTime)~\(endTime)"
        
        
        timeLabel.isHidden = false
        titleTaskLabel.isHidden = false
        checkButton.setImage(UIImage(named: "noCheck"), for: .normal)
        checkButton.setImage(UIImage(named: "yesCheck"), for: .selected)
        
        cellView.addSubview(titleTaskLabel)
        cellView.addSubview(taskLabel)
        cellView.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            taskLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 21),
            taskLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor ,constant: 57),
            
            titleTaskLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 57),
            titleTaskLabel.topAnchor.constraint(equalTo: cellView.topAnchor ,constant: 38),
            
            timeLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -26),
            timeLabel.topAnchor.constraint(equalTo:  cellView.topAnchor, constant: 38),
        ])
        
        // 파란색 테마 적용
        cellView.layer.borderColor = #colorLiteral(red: 0.7294117647, green: 0.8117647059, blue: 0.9568627451, alpha: 1).cgColor  // 파란색
        checkButton.isSelected = detail.completed
    }
    
}






