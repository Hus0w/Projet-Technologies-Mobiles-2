package org.helha.be.tm2_backend.services;

import org.helha.be.tm2_backend.models.Course;
import org.helha.be.tm2_backend.models.Student;
import org.helha.be.tm2_backend.models.StudentCourse;
import org.helha.be.tm2_backend.repositories.jpa.CourseRepository;
import org.helha.be.tm2_backend.repositories.jpa.StudentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Primary
public class StudentServiceDB implements IStudentService {

    @Autowired
    private StudentRepository studentRepository;

    public List<Student> getStudents() {
        return studentRepository.findAll();
    }

    public Student addStudent(Student student) {
        return studentRepository.save(student);
    }

    public Student updateStudent(Student student, int id) {
        return studentRepository.save(student);
    }

    public void deleteStudent(int id) {
        studentRepository.deleteById(id);
    }
}
