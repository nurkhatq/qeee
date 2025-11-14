# Настройка Google Sheets для QR Scanner

Это руководство поможет вам настроить интеграцию с Google Sheets для синхронизации данных из приложения.

## Проблема: "Requested entity was not found"

Эта ошибка означает, что приложение не может найти вашу Google Sheets таблицу. Причины:
1. Не заполнен файл `.env` с учетными данными
2. Неправильный ID таблицы
3. Service Account не имеет доступа к таблице

## Пошаговая инструкция

### Шаг 1: Создание Google Cloud проекта и Service Account

1. Перейдите на [Google Cloud Console](https://console.cloud.google.com)
2. Создайте новый проект или выберите существующий
3. В меню навигации выберите **APIs & Services** → **Library**
4. Найдите и включите следующие API:
   - **Google Sheets API**
   - **Google Drive API**

### Шаг 2: Создание Service Account

1. В меню навигации выберите **IAM & Admin** → **Service Accounts**
2. Нажмите **Create Service Account**
3. Заполните форму:
   - **Service account name**: например, `qr-scanner-app`
   - **Service account description**: например, `Service account for QR Scanner app`
4. Нажмите **Create and Continue**
5. Пропустите шаги назначения ролей (необязательно для этого приложения)
6. Нажмите **Done**

### Шаг 3: Создание ключа JSON

1. Найдите созданный Service Account в списке
2. Нажмите на email Service Account
3. Перейдите на вкладку **Keys**
4. Нажмите **Add Key** → **Create New Key**
5. Выберите тип ключа: **JSON**
6. Нажмите **Create**
7. Файл JSON будет автоматически скачан на ваш компьютер

### Шаг 4: Создание Google Sheets таблицы

1. Перейдите на [Google Sheets](https://sheets.google.com)
2. Создайте новую таблицу или откройте существующую
3. Скопируйте **ID таблицы** из URL:
   ```
   https://docs.google.com/spreadsheets/d/[ЭТОТ_ДЛИННЫЙ_ID_СКОПИРУЙТЕ]/edit
   ```

### Шаг 5: Предоставление доступа Service Account

**ВАЖНО!** Без этого шага вы получите ошибку "Requested entity was not found"

1. Откройте вашу Google Sheets таблицу
2. Нажмите кнопку **Поделиться** (Share) в правом верхнем углу
3. В поле "Добавить людей и группы" вставьте **email вашего Service Account**
   - Email находится в скачанном JSON файле: `client_email`
   - Выглядит примерно так: `qr-scanner-app@your-project.iam.gserviceaccount.com`
4. Выберите права доступа: **Редактор** (Editor)
5. **Снимите галочку** "Notify people" (не нужно отправлять уведомление)
6. Нажмите **Поделиться** (Share)

### Шаг 6: Настройка .env файла

1. В корне проекта найдите файл `.env.example`
2. Скопируйте его и переименуйте в `.env`:
   ```bash
   cp .env.example .env
   ```

3. Откройте скачанный JSON файл с ключом Service Account
4. Откройте файл `.env` в текстовом редакторе
5. Заполните следующие переменные данными из JSON файла:

   ```env
   # Из JSON файла:
   GOOGLE_PROJECT_ID=your-project-id
   GOOGLE_PRIVATE_KEY_ID=abc123def456...
   GOOGLE_PRIVATE_KEY=-----BEGIN PRIVATE KEY-----\nMIIEvQIB...\n-----END PRIVATE KEY-----\n
   GOOGLE_CLIENT_EMAIL=qr-scanner-app@your-project.iam.gserviceaccount.com
   GOOGLE_CLIENT_ID=123456789012345678901

   # ID таблицы из URL:
   GOOGLE_SPREADSHEET_ID=1a2b3c4d5e6f7g8h9i0j1k2l3m4n5o6p

   # Название листа (по умолчанию Sheet1):
   GOOGLE_WORKSHEET_NAME=Sheet1
   ```

**Важно для GOOGLE_PRIVATE_KEY:**
- Сохраните все символы переноса строки как `\n`
- Ключ должен начинаться с `-----BEGIN PRIVATE KEY-----\n`
- И заканчиваться `\n-----END PRIVATE KEY-----\n`

### Шаг 7: Установка зависимостей

```bash
flutter pub get
```

### Шаг 8: Перезапуск приложения

```bash
flutter run
```

## Проверка настройки

После настройки:

1. Запустите приложение
2. В логах вы должны увидеть:
   ```
   ✅ Переменные окружения загружены
   ✅ Конфигурация Google Sheets валидна
   ```

3. Попробуйте отсканировать QR код и отправить данные в Google Sheets
4. Данные должны появиться в вашей таблице

## Устранение неполадок

### Ошибка: "Requested entity was not found"
- Проверьте, что `GOOGLE_SPREADSHEET_ID` правильный
- Убедитесь, что вы предоставили доступ Service Account к таблице (Шаг 5)

### Ошибка: "invalid_grant" или "unauthorized"
- Проверьте правильность `GOOGLE_PRIVATE_KEY`
- Убедитесь, что `GOOGLE_CLIENT_EMAIL` правильный
- Проверьте, что Google Sheets API включен в проекте

### Ошибка: "Не заполнены переменные в .env"
- Убедитесь, что файл `.env` существует в корне проекта
- Проверьте, что все переменные заполнены
- Убедитесь, что нет значений начинающихся с "your" или "YOUR"

## Безопасность

**ВАЖНО:** Файл `.env` содержит конфиденциальные данные!

- Файл `.env` уже добавлен в `.gitignore`
- **Никогда** не коммитьте файл `.env` в репозиторий
- **Никогда** не делитесь содержимым `.env` публично
- Для работы в команде каждый разработчик должен создать свой `.env` файл

## Дополнительные ресурсы

- [Google Sheets API Documentation](https://developers.google.com/sheets/api)
- [Google Cloud Service Accounts](https://cloud.google.com/iam/docs/service-accounts)
- [flutter_dotenv Package](https://pub.dev/packages/flutter_dotenv)
