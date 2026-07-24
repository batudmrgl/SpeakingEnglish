# Asama 2: Calisan iOS Prototipi

## Olusturulan dosyalar

- `iOS/EnglishCoachApp/EnglishCoachApp/App/EnglishCoachApp.swift`
- `iOS/EnglishCoachApp/EnglishCoachApp/App/AppRootView.swift`
- `iOS/EnglishCoachApp/EnglishCoachApp/Core/`
- `iOS/EnglishCoachApp/EnglishCoachApp/Domain/`
- `iOS/EnglishCoachApp/EnglishCoachApp/Data/`
- `iOS/EnglishCoachApp/EnglishCoachApp/Services/`
- `iOS/EnglishCoachApp/EnglishCoachApp/Features/`
- `iOS/EnglishCoachApp/EnglishCoachApp/Resources/Info.plist`
- `iOS/EnglishCoachApp/EnglishCoachAppTests/`
- `iOS/EnglishCoachApp/EnglishCoachApp.xcodeproj`

## Xcode'a ekleme

Mac'te `iOS/EnglishCoachApp/EnglishCoachApp.xcodeproj` dosyasini Xcode ile acin. Signing ayarlarinda kendi Apple Developer Team degerinizi secin ve simulator/cihaz uzerinde calistirin.

## Backend

Bu asamada backend zorunlu degildir. `MockAIService` tum AI cevaplarini yerel olarak uretir. Gercek backend'e gecis icin `BackendAIService` ve Supabase Edge Function iskeletleri hazirdir.

Backend dosyalari:

- `backend/supabase/functions/conversation-message/index.ts`
- `backend/supabase/functions/exercise-evaluate/index.ts`
- `backend/supabase/functions/_shared/learning-schema.ts`
- `backend/supabase/functions/_shared/openai.ts`
- `backend/supabase/functions/_shared/cors.ts`
- `backend/supabase/migrations/202607250001_initial_schema.sql`

## Ortam degiskenleri

MVP prototipte ortam degiskeni gerekmez. Gercek backend asamasinda su degerler eklenecek:

- `OPENAI_API_KEY`
- `SUPABASE_URL`
- `SUPABASE_SERVICE_ROLE_KEY`
- `APPSTORE_SHARED_SECRET` veya App Store Server API key bilgileri

## Test yontemi

1. Uygulamayi simulator veya cihazda acin.
2. Onboarding'de seviye ve hedef secin.
3. Dort modulden birini acin.
4. Yazili cevap verip kontrol edin.
5. Cihazda mikrofon izni verip sesli cevap deneyin.
6. Canli diyalogda `Yesterday I go to shopping mall.` yazin ve duzeltme kartini kontrol edin.
7. Dersi bitirip rapor ekranini acin.
8. Ders gecmisinde raporun kaydedildigini kontrol edin.

## Calisan kontrol listesi

- [x] Turkce onboarding
- [x] Seviye ve hedef secimi
- [x] Dort modul girisi
- [x] Ingilizceden Turkceye egzersiz
- [x] Turkceden Ingilizceye egzersiz
- [x] Dinleme egzersizi
- [x] Canli AI diyalog
- [x] Kisa duzeltme karti
- [x] TTS
- [x] Speech-to-text servis entegrasyonu
- [x] Ders sonu raporu
- [x] Basit gecmis
- [x] Mock ve backend servis ayrimi
