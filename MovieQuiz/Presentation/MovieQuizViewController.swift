import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // меняем цвет текста в статус баре, т.к. фон приложения темный
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private var presenter: MovieQuizPresenter!
    
    // инициализация аутлетов элементов интерфейса
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var questionTitleLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var questionLabel: UILabel!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var noButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // устанавливаем шрифты
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        yesButton.titleLabel?.font = UIFont(name: "YSDIsplay-Medium", size: 20)
        noButton.titleLabel?.font = UIFont(name: "YSDIsplay-Medium", size: 20)
        
        questionTitleLabel.text = String(Localization.localizedString(forKey: "question", comment: "no comment"))
        yesButton.setTitle(String(Localization.localizedString(forKey: "yesButtonText", comment: "no comment")), for: .normal)
        noButton.setTitle(String(Localization.localizedString(forKey: "noButtonText", comment: "no comment")), for: .normal)
        
        // задаем закругление границ картинки
        imageView.layer.cornerRadius = 20
        
        // инициализация презентера
        presenter = MovieQuizPresenter(viewController: self)

        // загружаем данные при запуске приложения
        activityIndicator.hidesWhenStopped = true
        showLoadingIndicator()
    }
    
    // показ и скрытие индикатора загрузки
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    // функция сброса рамки картинки
    func resetBorders() {
        imageView.layer.borderColor = nil
        imageView.layer.borderWidth = 0
    }

    // метод отображения вопроса
    func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        questionLabel.text = step.question
    }
    
    // метод отображение алерта
    func showAlert(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
    
    // метод подсвечивания рамки изображения в зависимости от правильности ответа
    // и перехода к следующему вопросу/показу результатов
    func highlightImageBorder(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
    }
    
    // метод блока/анблока кнопок
    func changeButtonsEnabledState(to status: Bool) {
        noButton.isEnabled = status
        yesButton.isEnabled = status
    }
    
    // обработчик нажатия на кнопку НЕТ
    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter.noButtonClicked()
    }
    
    // обработчик нажания на кнопку ДА
    @IBAction private func yesButtonClocked(_ sender: Any) {
        presenter.yesButtonClicked()
    }
}
