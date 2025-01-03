package org.helha.be.tm2_backend.services;

import org.helha.be.tm2_backend.models.Student;
import org.helha.be.tm2_backend.repositories.jpa.StudentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@Primary
public class StudentServiceDB implements IStudentService {

    @Autowired
    private StudentRepository studentRepository;

    public List<Student> getStudents() {
        return studentRepository.findAll();
    }

    public Optional<Student> getStudentById(int id) {
        return studentRepository.findById(id);
    }

    public Student addStudent(Student student) {
        return studentRepository.save(student);
    }

    public Student updateStudent(Student student, int id) {
        // Vérifier si l'étudiant existe
        return studentRepository.findById(id).map(existingStudent -> {
            // Mettre à jour les champs de l'étudiant
            existingStudent.setName(student.getName());
            existingStudent.setLastname(student.getLastname());
            existingStudent.setMatricule(student.getMatricule());

            // Sauvegarder les modifications
            return studentRepository.save(existingStudent);
        }).orElseThrow(() -> new RuntimeException("Etudiant avec l'ID " + id + " n'a pas été trouvé."));
    }

    public void deleteStudent(int id) {
        studentRepository.deleteById(id);
    }
}
