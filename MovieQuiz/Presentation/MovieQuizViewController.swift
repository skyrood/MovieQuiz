import UIKit

final class MovieQuizViewController: UIViewController {
    
    // модель даты для вопросов
    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    // модель вопроса
    struct QuizStepViewModel {
        let image: UIImage?
        let question: String
        let questionNumber: String
        
        init(imageName: String, question: String, questionNumber: Int) {
            self.image = UIImage(named: imageName) ?? UIImage()
            self.question = question
            self.questionNumber = String(questionNumber + 1) + "/10"
        }
    }
    
    // модель результата квиза
    struct QuizResultViewModel {
        let title: String
        let text: String
        let buttonText: String
    }

    // мок дата для квиза
    var QuizQuestions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
    ]
    
    // инициализация номера вопроса и количества правильных ответов
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
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
    
        // показываем первый вопрос при запуске приложения
        let currentQuestion = convert(model: QuizQuestions[currentQuestionIndex])
        show(quiz: currentQuestion)
    }
    
    // меняем цвет текста в статус баре, т.к. фон приложения темный
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
    private func resetQuiz() {
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
    
    // метод отображения результата квиза
    private func show(quiz result: QuizResultViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.resetQuiz()
            
            let firstQuestion = self.QuizQuestions[self.currentQuestionIndex] // 2
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
           self.showNextQuestionOrResults()
        }
    }
    
    // функция отображения результатов квиза либо следующего вопроса
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == QuizQuestions.count - 1 {
            let quizResult = QuizResultViewModel(
                title: "Раунд окончен",
                text: "Ваш результат: \(correctAnswers)/10",
                buttonText: "Сыграть еще раз")
            show(quiz: quizResult)
        } else {
            resetBorders()
            currentQuestionIndex += 1
            let nextQuestion = convert(model: QuizQuestions[currentQuestionIndex])
            show(quiz: nextQuestion)
        }
    }
    
    // обработчик нажатия на кнопку НЕТ
    @IBAction private func noButtonClicked(_ sender: Any) {
        let currentQuestion = QuizQuestions[currentQuestionIndex]
        let answer = false
        let result = (answer == currentQuestion.correctAnswer)
        
        showAnswerResult(isCorrect: result)
    }
    
    // обработчик нажания на кнопку ДА
    @IBAction private func yesButtonClocked(_ sender: Any) {
        let currentQuestion = QuizQuestions[currentQuestionIndex]
        let answer = true
        let result = (answer == currentQuestion.correctAnswer)
                
        showAnswerResult(isCorrect: result)
    }
}
