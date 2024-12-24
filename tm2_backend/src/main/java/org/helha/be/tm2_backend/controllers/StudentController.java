package org.helha.be.tm2_backend.controllers;

import org.helha.be.tm2_backend.models.Student;
import org.helha.be.tm2_backend.services.StudentServiceDB;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping(path="/students")
public class StudentController {

    @Autowired
    StudentServiceDB studentServiceDB;

    @GetMapping
    public List<Student> getStudents() {
        return studentServiceDB.getStudents();
    }

    @PostMapping
    public Student addUser(@RequestBody Student student) {
        return studentServiceDB.addStudent(student);
    }

    @PutMapping(path="/{id}")
    public Student updateUser(@RequestBody Student student, @PathVariable int id) {
        return studentServiceDB.updateStudent(student, id);
    }

    @DeleteMapping(path="/{id}")
    public void deleteUser(@PathVariable int id) {
        studentServiceDB.deleteStudent(id);
    }
}
