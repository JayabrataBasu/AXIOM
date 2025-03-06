package com.example.axiom.backend.service

import com.example.axiom.backend.model.User
import com.example.axiom.backend.repository.UserRepository
import org.springframework.stereotype.Service

@Service
class UserService(private val userRepository: UserRepository) {
    fun createUser(user: User): User = userRepository.save(user)
    fun getAllUsers(): List<User> = userRepository.findAll()
}
