import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    // меняем цвет текста в статус баре, т.к. фон приложения темный
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // инициализация количества правильных ответов
    private var correctAnswers: Int = 0
    
    // инициализация презентера
    private let presenter = MovieQuizPresenter()
    
    // инициализация количества вопросов для раунда, переменных фабрики вопросов, текущего вопроса, алерт презентера
    private var questionFactory: QuestionFactoryProtocol?
    
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
        
        presenter.viewController = self
        
        // создаем экземпляр сервиса статистики
        statisticsService = StatisticsService()
        
        // создаем объект алерт презентера
        alertPresenter = AlertPresenter()
        alertPresenter?.setDelegate(self)
        
        // инициализация фабирки вопросов
        let moviesLoader = MoviesLoader()
        let questionFactory = QuestionFactory(moviesLoader)
        questionFactory.setDelegate(self)
        self.questionFactory = questionFactory
        
        // загружаем данные при запуске приложения
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        questionFactory.loadData()
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }
    
    // показ и скрытие индикатора загрузки
    private func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    // метод делегата, сообщающий об успешной загрузке и показывающий первый вопрос
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
        changeButtonsEnabledState(to: true)
    }
    
    // метода делегата, сообщающий об ошибке загрузки данных
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    // функция преобразования данных вопросов в вопрос
//    private func convert(model: QuizQuestion) -> QuizStepViewModel {
//        return QuizStepViewModel(
//            image: model.image,
//            question: model.text,
//            questionNumber: currentQuestionIndex,
//            questionsAmount: questionsAmount
//        )
//    }
    
    // функция сброса рамки картинки
    func resetBorders() {
        imageView.layer.borderColor = nil
        imageView.layer.borderWidth = 0
    }
    
    // функция сброса данных квиза
    func resetQuiz() {
        presenter.resetQuestionIndex()
        correctAnswers = 0
        resetBorders()
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
            correctAnswers += 1
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.presenter.correctAnswers = self.correctAnswers
            self.presenter.questionFactory = self.questionFactory
            self.presenter.alertPresenter = self.alertPresenter
            self.showLoadingIndicator()
            self.showNextQuestionOrResults()
        }
    }
    
    // метод отображения алерта
    func presentAlert(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
    
    // функция отображения результатов квиза либо следующего вопроса
    private func showNextQuestionOrResults() {
        if presenter.isLastQuestion() {
            
            // формирование и сохранение данных для результата
            let currentGameResult = GameResult(correct: correctAnswers, total: presenter.questionsAmount, date: Date().dateTimeString)
            
            self.statisticsService?.store(correct: currentGameResult.correct, total: currentGameResult.total)
        
            let result = String(currentGameResult.correct) + "/" + String(currentGameResult.total)
            
            let totalGamesCount = String((self.statisticsService?.gamesCount ?? 0))

            let record = "\(self.statisticsService?.bestGame.correct ?? currentGameResult.correct)/\(self.statisticsService?.bestGame.total ?? currentGameResult.total) (\(self.statisticsService?.bestGame.date ?? "date not found"))"
            
            var currentAccuracy: String = "146" // просто не придумал, что возвращать в случае ошибки
            if let accuracy = self.statisticsService?.totalAccuracy {
                currentAccuracy = String(format: "%.2f", accuracy) + " %"
            }

            let quizResult = AlertModel(
                title: "Раунд окончен",
                message: "Ваш результат: \(result),\nКоличество сыгранных квизов: \(totalGamesCount)\nРекорд: \(record)\nСредняя точность: \(currentAccuracy)",
                buttonText: "Сыграть еще раз") { [weak self] in
                    guard let self = self else { return }
                    
                    self.resetQuiz()
                    self.questionFactory?.requestNextQuestion()
                }
                
            // Выводим алерт
            self.alertPresenter?.show(quiz: quizResult)
            
        } else {
            resetBorders()
            presenter.switchToNextQuestion()

            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let errorInfo = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз") { [weak self] in
                guard let self = self else { return }
                
                self.resetQuiz()
                self.questionFactory?.requestNextQuestion()
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
