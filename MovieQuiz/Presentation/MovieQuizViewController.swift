import UIKit

final class MovieQuizViewController: UIViewController, AlertPresenterDelegate {
    // меняем цвет текста в статус баре, т.к. фон приложения темный
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private var presenter: MovieQuizPresenter!
    
    // инициализация сервиса статистики
    var statisticsService: StatisticsServiceProtocol?
    
    // инициализация алерт презентера
    private var alertPresenter: AlertPresenterProtocol?
    
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
        
        // задаем закругление границ картинки
        imageView.layer.cornerRadius = 20
        
        // инициализация презентера
        presenter = MovieQuizPresenter(viewController: self)
        
        // создаем экземпляр сервиса статистики
        statisticsService = StatisticsService()
        
        // создаем объект алерт презентера
        alertPresenter = AlertPresenter()
        alertPresenter?.setDelegate(self)
        
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
    
    // метод подсвечивания рамки изображения в зависимости от правильности ответа
    // и перехода к следующему вопросу/показу результатов
    func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
//            self.presenter.questionFactory = self.questionFactory
            self.presenter.alertPresenter = self.alertPresenter
            self.showLoadingIndicator()
            self.presenter.showNextQuestionOrResults()
        }
    }
    
    // метод отображения алерта
    func presentAlert(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let errorInfo = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз") { [weak self] in
                guard let self = self else { return }
                
                self.presenter.resetQuiz()
//                self.questionFactory?.requestNextQuestion()
            }
        
        // Создаем и выводим алерт
        self.alertPresenter?.show(quiz: errorInfo)
    }
    
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
