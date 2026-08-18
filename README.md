**SummQ**
is a mobile learning companion built with Flutter that helps students turn raw study material into interactive flashcard decks. Instead of manually writing questions and answers, you can upload a lecture PDF or paste your notes directly, and let the app generate a structured deck you can review, flip through, and track your progress on.

The app is designed around a simple loop:
1. **Add material** — upload a PDF or paste text notes.
2. **Generate a deck** — the app (via an AI backend) turns the content into flashcards.
3. **Study** — flip through cards, track difficulty, and complete review sessions.
4. **Track performance** — see stats on studied cards, decks created, and overall level.

##  Features

- 🔐 **Authentication flow** — Login and Sign Up screens with form validation.
- 📄 **Create decks from a PDF** — pick a file from your device and generate a flashcard deck from it.
- 📝 **Create decks from pasted notes** — paste raw text and turn it into a deck without a file.
- 🤖 **AI processing feedback** — animated loading modal (Lottie) while your content is being processed into flashcards.
- 🃏 **Interactive flashcard study mode** — flip-card UI to review question/answer pairs, deck by deck.
- 🎉 **Session summary** — an animated "session complete" screen showing how many cards you reviewed.
- 📊 **Performance dashboard** — visual chart of activity plus a level indicator.
- 🔎 **Deck search** —  quickly filter and find existing decks by name.
- 👤 **Profile & settings** — manage account info, notifications, study reminders, and dark mode toggle.
- 🧭 **Custom animated bottom navigation** — smooth notch-style tab bar switching between Performance, Home, and Profile.

------------------------------------------

## 🛠️ Tech Stack

| Category            | Technology                                                                       |
|---------------------|----------------------------------------------------------------------------------|
| Framework            | [Flutter](https://flutter.dev) (Dart SDK ^3.11.0)                                |
| State Management     | `Provider`                             |
| Networking           | [`dio`](https://pub.dev/packages/dio)                                            |
| Local Storage        | [`shared_preferences`](https://pub.dev/packages/shared_preferences)              |
| File Picking         | [`file_picker`](https://pub.dev/packages/file_picker)                            |
| Animations           | [`lottie`](https://pub.dev/packages/lottie)                                      |
| Flashcard UI         | [`flip_card`](https://pub.dev/packages/flip_card)                                |
| Bottom Navigation    | [`animated_notch_bottom_bar`](https://pub.dev/packages/animated_notch_bottom_bar) |
| Typography           | [`google_fonts`](https://pub.dev/packages/google_fonts)                          |
| App Icons            | [`icons_launcher`](https://pub.dev/packages/icons_launcher)                      |
| Linting              | [`flutter_lints`](https://pub.dev/packages/flutter_lints)                        |

---

## 📂 Project Structure

```
SummQ-Mobile/
├── android/                # Android platform project
├── ios/                    # iOS platform project
├── images/
│   └── logo.png            # App logo / branding
├── lib/
│   ├── main.dart             # App entry point
│   ├── theme.dart            # Colors, text styles & app theme
│   ├── bottom_nav.dart        # Custom animated bottom navigation bar
│   ├── AiLoading_Modal.dart   # "AI is processing" loading dialog
│   │
│   ├── cubit/
│   │   └── stats_controller.dart   # Tracks studied cards & decks created
│   │
│   ├── models/
│   │   ├── Decks_model.dart        # Deck data model
│   │   ├── flashcard_model.dart    # Flashcard data model
│   │   └── user_model.dart         # User data model
│   │
│   ├── screens/
│   │   ├── login_screen.dart       # Login screen
│   │   ├── signup_screen.dart      # Sign up screen
│   │   ├── main_screen.dart        # Hosts the bottom-nav tabs
│   │   ├── home_screen.dart        # Home tab: deck list & entry points
│   │   ├── Deck_fromPDF.dart       # "Create deck from PDF" modal
│   │   ├── paste_note.dart         # "Create deck from pasted notes" screen
│   │   ├── searchDeck_screen.dart  # Search/filter decks
│   │   ├── study_flashcards.dart   # Flip-card study session
│   │   ├── session_complete.dart   # Post-session summary screen
│   │   ├── performance_screen.dart # Performance/analytics tab
│   │   ├── profile_screen.dart     # Profile tab
│   │   └── setting_screen.dart     # App settings
│   │
│   ├── server/
│   │   └── Api.dart                # API client (Dio-based)
│   │
│   ├── utils/
│   │   ├── page_transitions.dart   # Custom route transitions
│   │   └── validator.dart          # Form input validators
│   │
│   └── widgets/
│       ├── buildSettingRows.dart   # Reusable settings-row widgets
│       ├── level_indicator.dart    # Level/progress indicator widget
│       └── repeted_button.dart     # Reusable styled button
│
├── test/
│   └── widget_test.dart
├── pubspec.yaml              # Dependencies & app metadata
└── README.md
```

---

## 🚀 Getting Started

Follow these steps to get a local copy up and running.

### Prerequisites

Make sure you have the following installed:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (compatible with Dart SDK `^3.11.0`)
- A configured emulator/simulator, or a physical Android/iOS device
- [Git](https://git-scm.com/)

Verify your setup with:

```bash
flutter doctor
```

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Summ-Q/SummQ-Mobile.git
   cd SummQ-Mobile
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

4. **(Optional) Generate app launcher icons**
   ```bash
   dart run icons_launcher:create
   ```

---

## ⚙️ Backend / API

SummQ is powered by a dedicated [Laravel API](https://github.com/Summ-Q/SummQ-Laraval-API), deployed on Vercel, which itself forwards AI generation and spaced-repetition scheduling to an internal Python service. The mobile app talks to this API through `lib/server/Api.dart` using `dio`.

- **Backend repo:** [Summ-Q/SummQ-Laraval-API](https://github.com/Summ-Q/SummQ-Laraval-API)
- **API docs (SwaggerHub):** [SummQ API — v1.0.0](https://app.swaggerhub.com/apis/ieee-9b4/SummQ/1.0.0)
- **Auth:** Laravel Sanctum, token-based (`Authorization: Bearer <token>`)

### Endpoints overview

| Method | Endpoint | Auth | Description |
|--------|----------|:---:|--------------|
| `GET`    | `/api/test` | ✅ | Health check |
| `POST`   | `/api/register` | ✅ | Create a new account, returns a Sanctum token |
| `POST`   | `/api/login` | ✅ | Log in, returns a Sanctum token |
| `POST`   | `/api/logout` | ✅ | Revoke the current access token |
| `GET`    | `/api/decks` | ✅ | List the authenticated user's decks |
| `POST`   | `/api/decks` | ✅ | Create a new (empty) deck |
| `DELETE` | `/api/decks/{deck}` | ✅ | Delete a deck |
| `GET`    | `/api/decks/{deck}/cards` | ✅ | List all flashcards in a deck |
| `POST`   | `/api/decks/{deck}/generate` | ✅ | Generate flashcards for a deck from pasted `notes` **or** an uploaded `file` (PDF) |
| `GET`    | `/api/decks/{deck}/study` | ✅ | Get the cards currently due for review in a deck |
| `POST`   | `/api/reviews/{flashcard}` | ✅ | Log a review (`score`: `1` or `4`) and get the next due date back |

### Example — generate a deck from pasted notes

```http
POST /api/decks/{deck}/generate
Authorization: Bearer <token>
Content-Type: application/json

{
  "notes": "Paste your lecture notes here..."
}
```

### Example — generate a deck from a PDF

```http
POST /api/decks/{deck}/generate
Authorization: Bearer <token>
Content-Type: multipart/form-data

file: <lecture.pdf>   (max 10MB, .pdf only)
```

Both return:

```json
{
  "message": "Cards generated successfully",
  "data": {
    "deck_id": 12,
    "cards": [
      { "id": 1, "deck_id": 12, "question": "...", "answer": "..." }
    ]
  }
}
```

### Pointing the app at the API

Update the base URL used in `lib/server/Api.dart` (and any related endpoint calls) to your deployed instance, e.g.:

```dart
// lib/server/Api.dart
final dio = Dio(BaseOptions(
  baseUrl: 'https://summ-q-laraval-api.vercel.app/api',
));
```

> ℹ️ Some screens (deck listing, flashcard content) still use mock/sample data via `DeckRepository` in `home_screen.dart` while the real endpoints above are being wired into the UI.

### AI & Data Science engine

The Laravel API doesn't generate flashcards or schedule reviews itself — it forwards that work to a separate [Python service](https://github.com/Summ-Q/SummQ-Python-API) (FastAPI) via the `PYTHON_API_URL` / `INTERNAL_API_TOKEN` config.

**Flashcard generation** — `POST /generate-flashcards/`
Accepts either a `file` (PDF) or `text` field (multipart form data). PDFs are parsed with PyMuPDF in 3-page chunks — extracted text *and* any embedded images are sent to Google's Gemini model, which returns a JSON array of `{question, answer}` pairs. Images are only used as context for the AI and are never shown to the user or returned in the response.

```json
{
  "status": "success",
  "message": "Flashcards extracted successfully",
  "data": [
    { "question": "...", "answer": "..." }
  ]
}
```

**Review scheduling (spaced repetition)** — `ds_engine/predictor.py`
A scikit-learn **Random Forest** classifier (`retention_model.pkl`) predicts the probability a user will forget a card, given `past_reviews_count`, `avg_score`, `days_since_last_review`, and a derived `overdue_ratio` feature. Based on that probability it returns a suggested next-review interval (1 day if a review is needed now, otherwise the current interval multiplied by an empirically-tuned growth factor, capped at 60 days). Model selection and tuning are documented in [`ds_model_development/model_experiments.md`](https://github.com/Summ-Q/SummQ-Python-API/blob/main/ds_model_development/model_experiments.md).

> ⚠️ At the time of writing, the Laravel `StudyController` calls this logic at `{PYTHON_API_URL}/ds/review-interval`, but the Python repo only exposes `/generate-flashcards/` as a FastAPI route — `predictor.py` isn't wired into an endpoint yet. This is worth confirming/fixing before relying on review scheduling end-to-end.

---

## 🗺️ Roadmap

- [ ] Wire up `login_screen.dart` / `signup_screen.dart` to the real `/api/login` and `/api/register` endpoints (currently a local mock flow)
- [ ] Replace mock deck data in `DeckRepository` with real `/api/decks` calls
- [ ] Connect "Create from PDF" / "Paste notes" screens to `/api/decks/{deck}/generate`
- [ ] Wire the study session screen to `/api/decks/{deck}/study` and log reviews via `/api/reviews/{flashcard}`
- [ ] Persist the Sanctum auth token securely on-device (e.g. via `shared_preferences` / secure storage)
- [ ] Push notifications for study reminders
- [ ] Light theme support (toggle currently in Settings)

> ✅ The spaced-repetition scheduling and AI flashcard generation are already implemented server-side — see [Backend / API](#️-backend--api) above.

---



## 📄 License

No license has been specified for this project yet. All rights reserved by the author(s) unless stated otherwise.

---

## 📬 Contact

Project maintained under the [Summ-Q](https://github.com/Summ-Q) organization.
Repository: [github.com/Summ-Q/SummQ-Mobile](https://github.com/Summ-Q/SummQ-Mobile)

