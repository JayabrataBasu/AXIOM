package com.example.axiom.ui.theme

import android.app.Activity
import android.os.Build
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.dynamicDarkColorScheme
import androidx.compose.material3.dynamicLightColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.SideEffect
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.toArgb
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalView
import androidx.core.view.WindowCompat

// Define your new color palette
private val LightColorScheme = lightColorScheme(
    primary = Color(0xFF006A4E),        // Teal green
    onPrimary = Color.White,
    primaryContainer = Color(0xFFB2DFDB),
    onPrimaryContainer = Color(0xFF004D40),
    secondary = Color(0xFF2E7D32),      // Darker green
    onSecondary = Color.White,
    secondaryContainer = Color(0xFFC8E6C9),
    onSecondaryContainer = Color(0xFF1B5E20),
    tertiary = Color(0xFF0277BD),       // Blue accent
    onTertiary = Color.White,
    background = Color(0xFFF5F5F5),     // Light gray background
    onBackground = Color(0xFF212121),
    surface = Color.White,
    onSurface = Color(0xFF212121)
)

private val DarkColorScheme = darkColorScheme(
    primary = Color(0xFF80CBC4),        // Lighter teal for dark theme
    onPrimary = Color(0xFF004D40),
    primaryContainer = Color(0xFF00796B),
    onPrimaryContainer = Color(0xFFE0F2F1),
    secondary = Color(0xFFA5D6A7),      // Lighter green for dark theme
    onSecondary = Color(0xFF1B5E20),
    secondaryContainer = Color(0xFF2E7D32),
    onSecondaryContainer = Color(0xFFE8F5E9),
    tertiary = Color(0xFF81D4FA),       // Lighter blue for dark theme
    onTertiary = Color(0xFF01579B),
    background = Color(0xFF121212),     // Dark background
    onBackground = Color.White,
    surface = Color(0xFF212121),
    onSurface = Color.White
)

@Composable
fun AxiomTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    // Dynamic color is available on Android 12+
    dynamicColor: Boolean = false, // Set to false to use our custom colors
    content: @Composable () -> Unit
) {
    val colorScheme = when {
        dynamicColor && Build.VERSION.SDK_INT >= Build.VERSION_CODES.S -> {
            val context = LocalContext.current
            if (darkTheme) dynamicDarkColorScheme(context) else dynamicLightColorScheme(context)
        }
        darkTheme -> DarkColorScheme
        else -> LightColorScheme
    }

    // Update status bar color
    val view = LocalView.current
    if (!view.isInEditMode) {
        SideEffect {
            val window = (view.context as Activity).window
            window.statusBarColor = colorScheme.primary.toArgb()
            WindowCompat.getInsetsController(window, view).isAppearanceLightStatusBars = !darkTheme
        }
    }

    MaterialTheme(
        colorScheme = colorScheme,
        typography = Typography,
        content = content
    )
}