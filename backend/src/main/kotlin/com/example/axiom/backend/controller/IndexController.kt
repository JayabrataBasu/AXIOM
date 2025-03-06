// IndexController.kt
package com.example.axiom.backend.controller

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

@RestController
class IndexController {

    @GetMapping("/")
    fun index(): Map<String, Any> {
        return mapOf(
            "status" to "UP",
            "message" to "Axiom Backend API is running",
            "endpoints" to listOf(
                "/api/users",
                "/api/insurance",
                "/api/appointments",
                "/api/medications",
                "/api/triage"
            ),
            "version" to "1.0.0"
        )
    }
}