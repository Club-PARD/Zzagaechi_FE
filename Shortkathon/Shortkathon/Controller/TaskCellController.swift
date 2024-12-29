import UIKit

class TaskCellController: UITableViewCell {
    private let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let taskLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let completionLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    var isTaskCompleted: Bool = false {
        didSet {
            updateAppearance()
        }
    }
    
    var isDetailed: Bool = true {
        didSet {
            updateAppearance()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 22
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 2
        
        contentView.addSubview(checkImageView)
        contentView.addSubview(taskLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(completionLineView)
        
        NSLayoutConstraint.activate([
            checkImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            checkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkImageView.widthAnchor.constraint(equalToConstant: 24),
            checkImageView.heightAnchor.constraint(equalToConstant: 24),
            
            taskLabel.leadingAnchor.constraint(equalTo: checkImageView.trailingAnchor, constant: 15),
            taskLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            taskLabel.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -10),
            
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            timeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            timeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            completionLineView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            completionLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            completionLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            completionLineView.heightAnchor.constraint(equalToConstant: 1.5)
        ])
        
        updateAppearance()
    }
    
    private func updateAppearance() {
        let imageName: String
        if isTaskCompleted {
            imageName = "yesCheck"
            contentView.backgroundColor = isDetailed ? 
                #colorLiteral(red: 0.7760145068, green: 0.8501827121, blue: 0.9661260247, alpha: 1) : 
                #colorLiteral(red: 0.9657146335, green: 0.951303184, blue: 0.7770063281, alpha: 1)
            completionLineView.isHidden = false
        } else {
            imageName = isDetailed ? "detailCheck" : "noDetailCheck"
            contentView.backgroundColor = #colorLiteral(red: 0.1607843137, green: 0.1607843137, blue: 0.1607843137, alpha: 1)
            completionLineView.isHidden = true
        }
        
        completionLineView.backgroundColor = isTaskCompleted ? 
            #colorLiteral(red: 0.1607843137, green: 0.1607843137, blue: 0.1607843137, alpha: 1) : .white
        
        checkImageView.image = UIImage(named: imageName)
        taskLabel.textColor = isTaskCompleted ? #colorLiteral(red: 0.1607843137, green: 0.1607843137, blue: 0.1607843137, alpha: 1) : .white
        timeLabel.textColor = isTaskCompleted ? #colorLiteral(red: 0.1607843137, green: 0.1607843137, blue: 0.1607843137, alpha: 1) : .white
    }
    
    func configure(with text: String, startTime: Date? = nil, endTime: Date? = nil, isDetailed: Bool) {
        taskLabel.text = text
        self.isDetailed = isDetailed
        
        if let start = startTime, let end = endTime {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let startString = formatter.string(from: start)
            let endString = formatter.string(from: end)
            timeLabel.text = "\(startString)~\(endString)"
        } else {
            timeLabel.text = ""
        }
        
        if isDetailed {
            contentView.layer.borderColor = #colorLiteral(red: 0.7760145068, green: 0.8501827121, blue: 0.9661260247, alpha: 1)
        } else {
            contentView.layer.borderColor = #colorLiteral(red: 0.9657146335, green: 0.951303184, blue: 0.7770063281, alpha: 1)
        }
        updateAppearance()
    }
}

//F4F1BA
//BACFF4
