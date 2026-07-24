# Windows'ta iOS Gelistirme Secenekleri

## Kisa cevap

Windows uzerinde BlueStacks benzeri, gercek iOS Simulator calistiran yasal ve pratik bir emulator yoktur. iOS Simulator, Xcode'un bir parcasidir ve macOS uzerinde calisir.

Microsoft'un "Windows icin Uzak iOS Simulatoru" cozumunde de iOS uygulamasi Windows'ta yerel olarak calismaz. Visual Studio Windows arayuzu kullanilir, fakat derleme ve iOS Simulator tarafinda yine bagli bir Mac build host gerekir.

## Bu projede secilen cozum

Bu repo icin Mac satin almadan ilerleyebilmek adina GitHub Actions tabanli iOS CI akisi eklendi:

- `.github/workflows/ios-ci.yml`

Bu workflow, GitHub'in macOS runner makinesinde Xcode ile projeyi build eder ve iOS Simulator uzerinde testleri calistirir.

## Nasil kullanilir

1. Bu klasoru bir GitHub reposuna yukleyin.
2. GitHub repo sayfasinda `Actions` sekmesini acin.
3. `iOS CI` workflow'unu secin.
4. `Run workflow` ile manuel calistirin veya main/master branch'e push edin.
5. Basarisiz olursa loglarda Xcode derleme hatalarini gorebilirsiniz.
6. Test sonucu artifact olarak `EnglishCoachApp-xcresult` adiyla yuklenir.

## Repoya otomatik yukleme

Bu ortamda `git` ve `gh` CLI yoksa GitHub REST API ile branch ve pull request olusturmak icin su script kullanilabilir:

```powershell
.\scripts\push_to_github.ps1 `
  -Owner "batudmrgl" `
  -Repo "SpeakingEnglish" `
  -Token "FINE_GRAINED_TOKEN"
```

Token icin GitHub kullanici sifresi paylasmayin. Fine-grained personal access token olusturup yalnizca bu repoya izin verin. Gerekli izinler:

- Contents: Read and write
- Pull requests: Read and write
- Workflows: Read and write

## Sinirlar

Bu cozum build ve otomatik test icin uygundur. Windows ekraninda interaktif iPhone Simulator penceresi acmaz.

Interaktif simulator gormek icin pratik secenekler:

- Kiralik cloud Mac + uzak masaustu
- MacStadium / MacinCloud benzeri Mac kiralama servisleri
- Kisa sureli Apple Silicon Mac mini kiralama
- Fiziksel iPhone'a TestFlight ile yukleme

## Tavsiye edilen yol

MVP gelistirmede en verimli yol:

1. Kod ve mimariyi bu Windows ortaminda hazirla.
2. Her degisikligi GitHub Actions macOS runner ile derlet.
3. UI davranisi icin SwiftUI Preview yerine otomatik UI testleri ekle.
4. Daha sonra TestFlight icin bir cloud Mac veya macOS CI servisi kullan.
