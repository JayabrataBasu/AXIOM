// AppointmentRepository.kt
package com.example.axiom.backend.repository

import com.example.axiom.backend.model.Appointment
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.stereotype.Repository
import java.time.LocalDateTime

@Repository
interface AppointmentRepository : JpaRepository<Appointment, Long> {
    fun findByUserId(userId: Long): List<Appointment>

    @Query("SELECT a FROM Appointment a WHERE a.user.id = :userId AND a.appointmentTime > :now")
    fun findUpcomingAppointments(userId: Long, now: LocalDateTime): List<Appointment>

    @Query("SELECT a FROM Appointment a WHERE a.user.id = :userId AND a.appointmentTime < :now")
    fun findPastAppointments(userId: Long, now: LocalDateTime): List<Appointment>
}