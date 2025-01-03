package org.helha.be.tm2_backend.controllers;

import org.helha.be.tm2_backend.models.Student;
import org.helha.be.tm2_backend.services.StudentServiceDB;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/students")
public class StudentController {

    @Autowired
    StudentServiceDB studentServiceDB;

    @GetMapping
    public List<Student> getStudents() {
        return studentServiceDB.getStudents();
    }

    @GetMapping("/{id}")
    public Optional<Student> getStudentById(@PathVariable int id) {
        return studentServiceDB.getStudentById(id);
    }

    @PostMapping
    public Student addStudent(@RequestBody Student student) {
        return studentServiceDB.addStudent(student);
    }

    @PutMapping(path="/{id}")
    public Student updateStudent(@RequestBody Student student, @PathVariable int id) {
        return studentServiceDB.updateStudent(student, id);
    }

    @DeleteMapping(path="/{id}")
    public void deleteStudent(@PathVariable int id) {
        studentServiceDB.deleteStudent(id);
    }
}
