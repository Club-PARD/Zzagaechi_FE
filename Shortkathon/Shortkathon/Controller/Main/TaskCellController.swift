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
    
    var isTaskCompleted: Bool = false {
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
        contentView.backgroundColor = .black.withAlphaComponent(0)
        contentView.layer.cornerRadius = 22
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = #colorLiteral(red: 0.7760145068, green: 0.8501827121, blue: 0.9661260247, alpha: 1)
        
        contentView.addSubview(checkImageView)
        contentView.addSubview(taskLabel)
        contentView.addSubview(timeLabel)
        
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
            timeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
        
        updateAppearance()
    }
    
    private func updateAppearance() {
        let imageName = isTaskCompleted ? "yesCheck" : "noCheck"
        checkImageView.image = UIImage(named: imageName)
        contentView.backgroundColor = isTaskCompleted ? #colorLiteral(red: 0.7760145068, green: 0.8501827121, blue: 0.9661260247, alpha: 1) : #colorLiteral(red: 0.1607843137, green: 0.1607843137, blue: 0.1607843137, alpha: 1)
        taskLabel.textColor = isTaskCompleted ? #colorLiteral(red: 0.1607843137, green: 0.1607843137, blue: 0.1607843137, alpha: 1) : .white
        timeLabel.textColor = isTaskCompleted ? #colorLiteral(red: 0.1607843137, green: 0.1607843137, blue: 0.1607843137, alpha: 1) : .white
    }
    
    func configure(with text: String, startTime: Date? = nil, endTime: Date? = nil) {
        taskLabel.text = text
        
        if let start = startTime, let end = endTime {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let startString = formatter.string(from: start)
            let endString = formatter.string(from: end)
            timeLabel.text = "\(startString)~\(endString)"
        } else {
            timeLabel.text = ""
        }
    }
} 
