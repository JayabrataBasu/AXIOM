// InsuranceController.kt
package com.example.axiom.backend.controller

import com.example.axiom.backend.model.Insurance
import com.example.axiom.backend.repository.InsuranceRepository
import com.example.axiom.backend.repository.UserRepository
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/insurance")
class InsuranceController(
    private val insuranceRepository: InsuranceRepository,
    private val userRepository: UserRepository
) {

    @GetMapping("/{userId}")
    fun getUserInsurance(@PathVariable userId: Long): ResponseEntity<Insurance> {
        val insurance = insuranceRepository.findTopByUserIdOrderByIdDesc(userId)
        return if (insurance != null) {
            ResponseEntity.ok(insurance)
        } else {
            ResponseEntity.notFound().build()
        }
    }

    @PostMapping("/{userId}")
    fun createInsurance(
        @PathVariable userId: Long,
        @RequestBody insurance: Insurance
    ): ResponseEntity<Insurance> {
        val user = userRepository.findById(userId)
        return if (user.isPresent) {
            val savedInsurance = insuranceRepository.save(insurance.copy(user = user.get()))
            ResponseEntity.status(HttpStatus.CREATED).body(savedInsurance)
        } else {
            ResponseEntity.notFound().build()
        }
    }

    @PutMapping("/{id}")
    fun updateInsurance(
        @PathVariable id: Long,
        @RequestBody insurance: Insurance
    ): ResponseEntity<Insurance> {
        return if (insuranceRepository.existsById(id)) {
            val updatedInsurance = insuranceRepository.save(insurance.copy(id = id))
            ResponseEntity.ok(updatedInsurance)
        } else {
            ResponseEntity.notFound().build()
        }
    }
}