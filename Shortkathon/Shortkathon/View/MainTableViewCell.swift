import UIKit


protocol MainTableViewCellDelegate: AnyObject {
    func didToggleCheckbox(for task: Any, isSelected: Bool)
}

class MainTableViewCell : UITableViewCell {
    //MARK: - property
    enum CellType {
        case plan
        case detail
    }
    
    weak var delegate: MainTableViewCellDelegate?
    private var currentTask: Any?
    
    private var strikethroughLayer: CAShapeLayer?
    
    private var emitter: CAEmitterLayer?
    
    
    private let clapLabel: UILabel = {
        let label = UILabel()
        label.text = "👏"
        label.font = .systemFont(ofSize: 40)
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    
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
        setupClapLabel()
        checkButton.addTarget(self, action: #selector(checkButtonTapped(_:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 레이아웃이 변경될 때마다 줄의 위치 업데이트
        if checkButton.isSelected {
            //            addStrikethrough()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCell()
        emitter?.removeFromSuperlayer()
        emitter = nil
        
        clapLabel.alpha = 0
        clapLabel.transform = .identity
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
    
    
    private func setupClapLabel() {
        contentView.addSubview(clapLabel)
        NSLayoutConstraint.activate([
            clapLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor),
            clapLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor)
        ])
    }
    
    
    // 셀 초기화
    private func resetCell() {
        taskLabel.removeFromSuperview()
        titleTaskLabel.removeFromSuperview()
        timeLabel.removeFromSuperview()
        
        taskLabel.text = nil
        titleTaskLabel.text = nil
        timeLabel.text = nil
        checkButton.isSelected = false
        currentTask = nil
        
        taskLabel.font = UIFont(name: "Pretendard-Regular", size: 17)
        taskLabel.textColor = #colorLiteral(red: 0.6606984735, green: 0.6606983542, blue: 0.6606983542, alpha: 1)
        cellView.layer.borderColor = #colorLiteral(red: 0.7294117647, green: 0.8117647059, blue: 0.9568627451, alpha: 1).cgColor
    }
    
    
    @objc private func checkButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        //        if let task = currentTask {
        //            delegate?.didToggleCheckbox(for: task, isSelected: sender.isSelected)
        //        }
        if sender.isSelected {
            showClapAnimation()
        }
        if let task = currentTask {
            delegate?.didToggleCheckbox(for: task, isSelected: sender.isSelected)
        }
    }
    
    
    func configure(with plan: Plan, type: CellType) {
        resetCell()
        taskLabel.text = plan.plantitle
        timeLabel.isHidden = true
        currentTask = plan
        
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
        resetCell()
        taskLabel.text = detail.plansubtitle
        titleTaskLabel.text = detail.content
        currentTask = detail
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
    
    
    private func showClapAnimation() {
        startParticleAnimation()
    }
    
    private func startParticleAnimation() {
        emitter?.removeFromSuperlayer()
        
        // 현재 셀의 절대 위치를 window 좌표계로 변환
        guard let window = UIApplication.shared.windows.first,
              let absolutePosition = checkButton.superview?.convert(checkButton.center, to: window) else {
            return
        }
        
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = absolutePosition
        emitter.emitterSize = CGSize(width: 100, height: 100)
        emitter.emitterShape = .point
        
        let emojiStrings = ["🎉", "⭐️", "👏🏻", "🌼", "🔸"]
        
        var emitterCells: [CAEmitterCell] = []
        for emoji in emojiStrings {
            let cell = CAEmitterCell()
            cell.contents = {
                let font = UIFont.systemFont(ofSize: 20)
                let size = emoji.size(withAttributes: [.font: font])
                let renderer = UIGraphicsImageRenderer(size: size)
                let image = renderer.image { context in
                    emoji.draw(at: .zero, withAttributes: [.font: font])
                }
                return image.cgImage
            }()
            
            cell.birthRate = 30 / Float(emojiStrings.count)
            cell.lifetime = 1.5
            cell.velocity = 300
            cell.velocityRange = 50
            cell.emissionRange = .pi / 5
            cell.emissionLongitude = .pi / -2
            cell.scale = 0.4
            cell.scaleRange = 0.2
            cell.scaleSpeed = -0.1
            cell.alphaRange = 0.3
            cell.alphaSpeed = -0.5
            
            emitterCells.append(cell)
        }
        
        emitter.emitterCells = emitterCells
        // window의 layer에 추가
        window.layer.addSublayer(emitter)
        self.emitter = emitter
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            emitter.birthRate = 0
        }
        
        // 파티클 효과가 끝나면 제거
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.emitter?.removeFromSuperlayer()
            self.emitter = nil
        }
    }
    
}


