package com.example.axiom.backend.controller

import com.example.axiom.backend.model.User
import com.example.axiom.backend.repository.UserRepository
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/users")
class UserController(private val userRepository: UserRepository) {

    @GetMapping
    fun getAllUsers(): List<User> {
        return userRepository.findAll()
    }

    @GetMapping("/{id}")
    fun getUserById(@PathVariable id: Long): User {
        return userRepository.findById(id).orElseThrow { RuntimeException("User not found") }
    }

    @PostMapping
    fun createUser(@RequestBody user: User): User {
        return userRepository.save(user)
    }
}