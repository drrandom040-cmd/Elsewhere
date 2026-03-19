# Elsewhere — Writing Companion App

A Flutter Android app for writers. Novels, short stories, articles — all in one place, with a built-in audio library, visual gallery, and focus lock mode.

---

## Project Structure

```
lib/
├── main.dart                          # App entry, routes
├── theme/
│   └── app_theme.dart                 # All color schemes per section
├── screens/
│   ├── login_screen.dart              # Google Auth login
│   ├── home_screen.dart               # Dashboard (3 section cards)
│   ├── novels_screen.dart             # Novels section (blue theme)
│   ├── short_stories_screen.dart      # Short stories section
│   ├── articles_screen.dart           # Articles section (brown theme)
│   ├── create_project_screen.dart     # New project flow (type → word count → details)
│   ├── novel_workspace_screen.dart    # Novel dashboard + chapter editor + scenes + characters
│   ├── audio_player_screen.dart       # Audio library + full player UI
│   └── gallery_screen.dart            # Visual inspiration gallery
└── widgets/
    ├── persistent_audio_bar.dart      # Mini audio bar shown on all screens
    └── app_drawer.dart                # Side navigation drawer
```

---

## Color Schemes (Per Section)

| Section | Background | Accent |
|---|---|---|
| Home / Login | `#312C51` deep purple | `#F0C38E` warm gold + `#F1AA9B` blush |
| Novels | `#080F1A` dark navy | `#52E8FF` electric blue |
| Short Stories | `#1A1220` dark plum | `#E8A87C` amber + `#B06ABE` violet |
| Articles | `#F5ECD7` warm cream | `#5C3D2E` dark brown |
| Audio / Gallery | `#090820` near black | `#7030EF` purple + `#DB1FFF` neon magenta |

---

## Features Built

- [x] Google Auth login screen
- [x] Home dashboard with section cards
- [x] Side drawer navigation
- [x] Novels section with past projects
- [x] Short Stories section
- [x] Articles section
- [x] Create New Project flow (Novel → word count → details / Short Story → details / Article → details)
- [x] Novel workspace (Chapters, Scenes Planner, Characters, World Map, Locations, Word Count)
- [x] Chapter editor with Bold, Italic, Image insertion toolbar
- [x] Scenes Planner
- [x] Character Data screen (with role: main/supporting/minor)
- [x] Focus Mode (Soft Lock + Hard Lock, user chooses)
- [x] Persistent audio mini-bar across all screens
- [x] Full audio player (cover art, blurred bg, progress bar, queue)
- [x] Audio library (add local files + YouTube URL)
- [x] Gallery (manual image upload only, tagging, pin to scenes)

---

## Setup

1. Push this folder to your GitHub repo (`drrandom040-cmd`)
2. GitHub Actions will auto-build the APK on every push
3. Download the APK from the Actions tab → Artifacts

### To add Google Sign-In (real auth):
1. Create a project at [console.firebase.google.com](https://console.firebase.google.com)
2. Add Android app with your package name
3. Download `google-services.json` → place in `android/app/`
4. Follow `google_sign_in` package setup in `android/build.gradle`

### Font:
Download **General Sans** from [fontshare.com](https://www.fontshare.com/fonts/general-sans) and add to `assets/fonts/`. Then uncomment the font section in `pubspec.yaml`.

---

## Dependencies

- `google_sign_in` — Google authentication
- `just_audio` — Audio playback
- `file_picker` — Import audio from device
- `image_picker` — Import images from device
- `youtube_player_flutter` — YouTube audio/video streaming
- `shared_preferences` — Local data persistence
