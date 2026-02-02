# Cyan Website

Marketing website for Cyan - the collaboration platform.

## Live Site

https://blockxaero.io

## Development

```bash
# Get dependencies
flutter pub get

# Run locally
flutter run -d chrome

# Build for production
flutter build web --release --web-renderer html
```

## Deployment

Automatic deployment via GitHub Actions on push to `main`.

The workflow:
1. Builds Flutter web with HTML renderer
2. Copies CNAME for custom domain
3. Deploys to GitHub Pages

## Structure

```
lib/
  main.dart          # Full website (single file)
assets/
  cyan-wordmark.png  # Logo
  constellation.svg  # Animated Y constellation
web/
  index.html         # Entry point with loading screen
  manifest.json      # PWA manifest
```

## Theme

Uses exact Monokai colors from the Cyan app (ThemeManager.swift):

| Color | Hex |
|-------|-----|
| background | #272822 |
| surface | #3E3D32 |
| foreground | #F8F8F2 |
| comment | #75715E |
| cyan | #66D9EF |
| green | #A6E22E |
| purple | #AE81FF |
| orange | #FD971F |
| yellow | #E6DB74 |
| red/pink | #F92672 |

## Email Signup

Currently logs to console. To wire up:

### Option A: Buttondown
1. Create account at buttondown.email
2. Get your form action URL
3. Update `_submitEmail()` in main.dart

### Option B: Custom API
1. Deploy an endpoint that accepts `{ email: string }`
2. Update `_submitEmail()` to POST to your endpoint

## License

Proprietary - Block Xaero

