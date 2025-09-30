# 📱 Flutter Calculator App

Простое приложение **Калькулятор**, созданное на Flutter.
Проект сделан для практики базовых навыков: работа с виджетами, состоянием (`StatefulWidget`), кнопками и макетами (`Row`, `Column`, `Expanded`).

## 🚀 Функции

* Отображение текущего ввода на экране.
* Поддержка операций: ➕ сложение, ➖ вычитание, ✖️ умножение, ➗ деление.
* Кнопка `C` очищает экран.
* Красивый интерфейс с использованием Material Design.

## 🛠️ Технологии

* **Flutter** (Dart)
* Виджеты: `Scaffold`, `SafeArea`, `Column`, `Row`, `Container`, `Expanded`, `ElevatedButton`
* Управление состоянием через `setState`

## 📂 Структура проекта

lib/
 └── main.dart   # Основной файл приложения


## 📸 Скриншот
lib/ assets/scr.png

## ▶️ Запуск проекта

1. Установить [Flutter SDK](https://docs.flutter.dev/get-started/install)
2. Склонировать проект или создать новый:

   ```bash
   flutter create calculator_app
   ```
3. Заменить содержимое `lib/main.dart` на код калькулятора.
4. Запустить проект:

   ```bash
   flutter run
   ```

## 💡 Что изучаешь в этом проекте

* Как устроен каркас экрана (`Scaffold`)
* Как работать с кнопками (`ElevatedButton`)
* Как делить экран на части (`Row`, `Column`, `Expanded`)
* Как обновлять интерфейс с помощью `setState`
