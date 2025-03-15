// Create file: app/src/main/java/com/example/axiom/api/ApiService.kt
package com.example.axiom.api

import com.example.axiom.model.*
import retrofit2.Call
import retrofit2.http.*

interface ApiService {
    // User endpoints
    @GET("api/users")
    fun getUsers(): Call<List<UserDto>>

    @POST("api/users")
    fun createUser(@Body user: UserDto): Call<UserDto>

    // Insurance endpoints
    @GET("api/insurance/{userId}")
    fun getUserInsurance(@Path("userId") userId: Long): Call<InsuranceDto>

    @POST("api/insurance/{userId}")
    fun createInsurance(@Path("userId") userId: Long, @Body insurance: InsuranceDto): Call<InsuranceDto>

    // Appointment endpoints
    @GET("api/appointments/{userId}")
    fun getUserAppointments(@Path("userId") userId: Long): Call<List<AppointmentDto>>

    @POST("api/appointments/{userId}")
    fun createAppointment(@Path("userId") userId: Long, @Body appointment: AppointmentDto): Call<AppointmentDto>

    @DELETE("api/appointments/{id}")
    fun deleteAppointment(@Path("id") id: Long): Call<Void>

    // Medication endpoints
    @GET("api/medications/{userId}")
    fun getUserMedications(@Path("userId") userId: Long): Call<List<MedicationDto>>

    @POST("api/medications/{userId}")
    fun createMedication(@Path("userId") userId: Long, @Body medication: MedicationDto): Call<MedicationDto>

    @DELETE("api/medications/{id}")
    fun deleteMedication(@Path("id") id: Long): Call<Void>

    // Triage endpoints
    @GET("api/triage/{userId}")
    fun getUserTriageRecords(@Path("userId") userId: Long): Call<List<TriageDto>>

    @POST("api/triage/{userId}")
    fun createTriageRecord(@Path("userId") userId: Long, @Body triage: TriageDto): Call<TriageDto>
}