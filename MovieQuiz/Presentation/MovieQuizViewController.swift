import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    // меняем цвет текста в статус баре, т.к. фон приложения темный
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // инициализация номера вопроса и количества правильных ответов
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    // инициализация количества вопросов для раунда, переменных фабрики вопросов, текущего вопроса, алерт презентера
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    // инициализация аутлетов элементов интерфейса
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
        
        // инициализация фабирки вопросов
        let questionFactory = QuestionFactory()
        questionFactory.setDelegate(self)
        self.questionFactory = questionFactory
        
        // показываем первый вопрос при запуске приложения
        questionFactory.requestNextQuestion()
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // функция преобразования данных вопросов в вопрос
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            imageName: model.image,
            question: model.text,
            questionNumber: currentQuestionIndex)
    }
    
    // функция сброса рамки картинки
    private func resetBorders() {
        imageView.layer.borderColor = nil
        imageView.layer.borderWidth = 0
    }
    
    // функция сброса квиза
    func resetQuiz() {
        if let questionFactory = questionFactory {
            questionFactory.resetIndices()
        }
        
        currentQuestionIndex = 0
        correctAnswers = 0
        resetBorders()
    }

    
    // метод отображения вопроса
    private func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        questionLabel.text = step.question
    }
    
    // метод подсвечивания рамки изображения в зависимости от правильности ответа
    // и перехода к следующему вопросу/показу результатов
    private func showAnswerResult(isCorrect: Bool) {
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
            self.showNextQuestionOrResults()
        }
    }
    
    // метод отображения алерта
    func presentAlert(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
    
    // функция отображения результатов квиза либо следующего вопроса
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            let quizResult = AlertModel(
                title: "Раунд окончен",
                message: "Ваш результат: \(correctAnswers)/\(questionsAmount)",
                buttonText: "Сыграть еще раз") {
                    self.resetQuiz()
                    self.questionFactory?.requestNextQuestion()
                }
                
            // Создаем и выводим алерт
            let alertPresenter = AlertPresenter()
            alertPresenter.setDelegate(self)
            alertPresenter.show(quiz: quizResult)
            
        } else {
            resetBorders()
            currentQuestionIndex += 1

            questionFactory?.requestNextQuestion()
        }
    }
    
    // блок кнопок с ответами на 1 с
    private func blockButtons() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            // Check if self still exists
            guard let self = self else { return }
                
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
        }
    }
    
    // обработчик нажатия на кнопку НЕТ
    @IBAction private func noButtonClicked(_ sender: Any) {
        blockButtons()
        guard let currentQuestion = currentQuestion else { return }
        let answer = false
        let result = (answer == currentQuestion.correctAnswer)
        
        showAnswerResult(isCorrect: result)
    }
    
    // обработчик нажания на кнопку ДА
    @IBAction private func yesButtonClocked(_ sender: Any) {
        blockButtons()
        guard let currentQuestion = currentQuestion else { return }
        let answer = true
        let result = (answer == currentQuestion.correctAnswer)
                
        showAnswerResult(isCorrect: result)
    }
}
