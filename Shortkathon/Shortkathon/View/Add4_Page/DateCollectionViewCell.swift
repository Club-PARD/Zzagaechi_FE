import UIKit


class DateCollectionViewCell : UICollectionViewCell {
    static let identifier = "DateCollectionViewCell"
    
    enum CellState{
        case normal
        case selected
        case hasTask
        var backgroundColor: UIColor {
                   switch self {
                   case .normal:
                       return #colorLiteral(red: 0.2605186105, green: 0.2605186105, blue: 0.2605186105, alpha: 1)
                   case .selected:
                       return #colorLiteral(red: 0.3019607843, green: 0.5568627451, blue: 1, alpha: 1)
                   case .hasTask:
                       return #colorLiteral(red: 0.3019607843, green: 0.5568627451, blue: 1, alpha: 0.5)
                   }
               }
               
               var textColor: UIColor {
                   switch self {
                   case .normal, .hasTask:
                       return .white
                   case .selected:
                       return .white
                   }
               }
    }
    
    
    
    
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "Pretendard-Regular", size: 20)
        return label
    }()
    
    var dayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "Pretendard-ExtraLight", size: 14)
        return label
    }()
    
    
    
    //MARK: - main
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        contentView.backgroundColor = #colorLiteral(red: 0.2605186105, green: 0.2605186105, blue: 0.2605186105, alpha: 1)
        contentView.layer.cornerRadius = 6
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    func configure(with state: CellState) {
            contentView.backgroundColor = state.backgroundColor
            dateLabel.textColor = state.textColor
            dayLabel.textColor = state.textColor
        }
    
    override var isSelected: Bool {
        
        didSet {
            // 선택 상태에 따라 셀의 외관 변경
            configure(with: isSelected ? .selected : .normal)
//            contentView.backgroundColor = isSelected ? #colorLiteral(red: 0.3019607843, green: 0.5568627451, blue: 1, alpha: 1) : #colorLiteral(red: 0.2605186105, green: 0.2605186105, blue: 0.2605186105, alpha: 1)
//            contentView.layer.borderColor = isSelected ? UIColor.clear.cgColor : #colorLiteral(red: 0.7294117647, green: 0.8117647059, blue: 0.9568627451, alpha: 1)
        }
        
    }
    
    func setUI(){
        isUserInteractionEnabled = true
        [dateLabel, dayLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 17),
            
            dayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dayLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor ,constant: -15)
        ])
    }
}


