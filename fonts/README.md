# AXIOM Fonts

This directory contains the custom fonts used in AXIOM's Stitch UI design system.

## Required Fonts

### Space Grotesk (Display Font)
Used for headings, titles, and prominent UI elements.

**Weights needed:**
- Light (300)
- Regular (400)
- Medium (500)
- SemiBold (600)
- Bold (700)

**Download from:** https://fonts.google.com/specimen/Space+Grotesk

### Manrope (Body Font)
Used for body text, labels, and general content.

**Weights needed:**
- Light (300)
- Regular (400)
- Medium (500)
- SemiBold (600)
- Bold (700)

**Download from:** https://fonts.google.com/specimen/Manrope

## Installation Instructions

1. Download both font families from Google Fonts
2. Extract the TTF files
3. Rename them to match the names in `pubspec.yaml`:
   - `SpaceGrotesk-Light.ttf`
   - `SpaceGrotesk-Regular.ttf`
   - `SpaceGrotesk-Medium.ttf`
   - `SpaceGrotesk-SemiBold.ttf`
   - `SpaceGrotesk-Bold.ttf`
   - `Manrope-Light.ttf`
   - `Manrope-Regular.ttf`
   - `Manrope-Medium.ttf`
   - `Manrope-SemiBold.ttf`
   - `Manrope-Bold.ttf`
4. Place them in this `fonts/` directory
5. Run `flutter pub get` and restart your app

## Fallback

If fonts are not installed, Flutter will fall back to system fonts. The design tokens in `lib/theme/design_tokens.dart` specify the font families.
