// AppointmentController.kt
package com.example.axiom.backend.controller

import com.example.axiom.backend.model.Appointment
import com.example.axiom.backend.repository.AppointmentRepository
import com.example.axiom.backend.repository.UserRepository
import org.springframework.format.annotation.DateTimeFormat
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import java.time.LocalDateTime

@RestController
@RequestMapping("/api/appointments")
class AppointmentController(
    private val appointmentRepository: AppointmentRepository,
    private val userRepository: UserRepository
) {

    @GetMapping("/{userId}")
    fun getUserAppointments(@PathVariable userId: Long): List<Appointment> {
        return appointmentRepository.findByUserId(userId)
    }

    @GetMapping("/{userId}/upcoming")
    fun getUpcomingAppointments(@PathVariable userId: Long): List<Appointment> {
        return appointmentRepository.findUpcomingAppointments(userId, LocalDateTime.now())
    }

    @GetMapping("/{userId}/past")
    fun getPastAppointments(@PathVariable userId: Long): List<Appointment> {
        return appointmentRepository.findPastAppointments(userId, LocalDateTime.now())
    }

    @PostMapping("/{userId}")
    fun createAppointment(
        @PathVariable userId: Long,
        @RequestBody appointment: Appointment
    ): ResponseEntity<Appointment> {
        val user = userRepository.findById(userId)
        return if (user.isPresent) {
            val savedAppointment = appointmentRepository.save(appointment.copy(user = user.get()))
            ResponseEntity.status(HttpStatus.CREATED).body(savedAppointment)
        } else {
            ResponseEntity.notFound().build()
        }
    }

    @PutMapping("/{id}")
    fun updateAppointment(
        @PathVariable id: Long,
        @RequestBody appointment: Appointment
    ): ResponseEntity<Appointment> {
        return if (appointmentRepository.existsById(id)) {
            val updatedAppointment = appointmentRepository.save(appointment.copy(id = id))
            ResponseEntity.ok(updatedAppointment)
        } else {
            ResponseEntity.notFound().build()
        }
    }

    @DeleteMapping("/{id}")
    fun deleteAppointment(@PathVariable id: Long): ResponseEntity<Void> {
        return if (appointmentRepository.existsById(id)) {
            appointmentRepository.deleteById(id)
            ResponseEntity.noContent().build()
        } else {
            ResponseEntity.notFound().build()
        }
    }
}