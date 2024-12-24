package org.helha.be.tm2_backend.services;

import org.helha.be.tm2_backend.models.Student;
import org.helha.be.tm2_backend.models.StudentCourse;
import org.helha.be.tm2_backend.repositories.jpa.StudentCourseRepository;
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

    @Autowired
    private StudentCourseRepository studentCourseRepository;

    public List<Student> getStudents() {
        return studentRepository.findAll();
    }

    public Student addStudent(Student student) {
        // Lier chaque StudentCourse à l'étudiant
        for (StudentCourse sc : student.getStudentCourses()) {
            sc.setStudent(student);
        }

        return studentRepository.save(student);
    }

    public Student updateStudent(Student student, int id) {
        // Vérifier si l'étudiant existe
        return studentRepository.findById(id).map(existingStudent -> {
            // Mettre à jour les champs de l'étudiant
            existingStudent.setName(student.getName());
            existingStudent.setLastname(student.getLastname());
            existingStudent.setMatricule(student.getMatricule());

            // Mettre à jour les StudentCourses
            if (student.getStudentCourses() != null) {
                for (StudentCourse sc : student.getStudentCourses()) {
                    sc.setStudent(existingStudent);
                }
                existingStudent.getStudentCourses().clear();
                existingStudent.getStudentCourses().addAll(student.getStudentCourses());
            }

            // Sauvegarder les modifications
            return studentRepository.save(existingStudent);
        }).orElseThrow(() -> new RuntimeException("Student with ID " + id + " not found"));
    }

    public void deleteStudent(int id) {
        studentRepository.deleteById(id);
    }
}