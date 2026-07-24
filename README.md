# EnglishCoach iOS Prototype

Turk kullanicilar icin SwiftUI tabanli, AI destekli Ingilizce pratik prototipi.

Bu repo ilk prototip kaynaklarini icerir. `iOS/EnglishCoachApp/EnglishCoachApp.xcodeproj` Mac uzerinde Xcode ile dogrudan acilacak sekilde olusturuldu. Bu Windows ortaminda Xcode derleme araci bulunmadigi icin proje burada derlenemedi.

## MVP kapsam

- Turkce onboarding
- CEFR seviye secimi
- Hedef secimi
- Ana ekranda 4 modul
- Ingilizceden Turkceye alistirma
- Turkceden Ingilizceye alistirma
- Dinleme alistirmasi
- AI diyalog modu
- Bas-konus Speech-to-text
- AVSpeechSynthesizer ile TTS
- Mock AI servisi
- Gercek backend servisine gecis icin protokol tabani
- Ders sonu ozet
- Basit gecmis

## Xcode kurulumu

1. Mac'te `iOS/EnglishCoachApp/EnglishCoachApp.xcodeproj` dosyasini Xcode ile acin.
2. Signing ayarlarinda kendi Apple Developer Team degerinizi secin.
3. Bir iPhone simulatoru veya fiziksel cihaz secin.
4. Run tusuna basin.

## Mac olmadan build/test

Windows uzerinde yerel iOS emulatoru calistirilamaz. Bu repo icin GitHub Actions macOS runner uzerinde build/test yapan workflow eklendi:

```text
.github/workflows/ios-ci.yml
```

Detaylar icin:

```text
docs/windows-ios-development-options.md
```

## Mock / gercek servis

Varsayilan olarak mock servis aktiftir:

```swift
AppConfiguration(useMockServices: true, backendBaseURL: nil)
```

Gercek backend icin `EnglishCoachApp.swift` icinde `useMockServices` degerini `false` yapip `backendBaseURL` verin. Supabase kullanirken taban URL su formatta olmali:

```text
https://YOUR_PROJECT_REF.supabase.co/functions/v1
```
