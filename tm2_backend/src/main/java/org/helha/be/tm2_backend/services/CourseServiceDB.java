package org.helha.be.tm2_backend.services;

import org.helha.be.tm2_backend.models.Course;
import org.helha.be.tm2_backend.repositories.jpa.CourseRepository;
import org.helha.be.tm2_backend.repositories.jpa.StudentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Primary
public class CourseServiceDB implements ICourseService {

    @Autowired
    private CourseRepository courseRepository;

    @Autowired
    private StudentRepository studentRepository;


    public List<Course> getCourses() {
        return courseRepository.findAll();
    }

    public Optional<Course> getCourseById(int id) {
        return courseRepository.findById(id);
    }

    public List<Map<String, Object>> getCoursesWithStudents() {
        List<Course> courses = courseRepository.findAll();

        return courses.stream().map(course -> {
            Map<String, Object> courseData = Map.of(
                    "id", course.getId(),
                    "name", course.getName(),
                    "grades", course.getGrades(),
                    "students", course.getGrades().keySet().stream()
                            .map(studentId -> studentRepository.findById(studentId)
                                    .orElse(null)) // Recherchez les informations des étudiants
                            .filter(student -> student != null) // Supprimez les valeurs null si un étudiant n'existe pas
                            .map(student -> Map.of(
                                    "id", student.getId(),
                                    "name", student.getName(),
                                    "lastname", student.getLastname(),
                                    "matricule", student.getMatricule()
                            ))
                            .collect(Collectors.toList())
            );
            return courseData;
        }).collect(Collectors.toList());
    }

    public Course addCourse(Course course) {
        return courseRepository.save(course);
    }

    public Course updateCourse(int id, String newName) {
        // Recherche du cours par son ID
        Course existingCourse = courseRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Cours non trouvé avec l'ID : " + id));

        // Mise à jour du nom uniquement
        existingCourse.setName(newName);

        // Sauvegarde des modifications
        return courseRepository.save(existingCourse);
    }

    public void deleteCourse(int id) {
        courseRepository.deleteById(id);
    }

    public void addGrade(int courseId, int studentId, Double note) {
        Course course = courseRepository.findById(courseId)
                .orElseThrow(() -> new RuntimeException("Cours non trouvé"));

        course.getGrades().put(studentId, note);
        courseRepository.save(course);
    }

    public void removeGrade(int courseId, int studentId) {
        Course course = courseRepository.findById(courseId)
                .orElseThrow(() -> new RuntimeException("Cours non trouvé"));

        course.getGrades().remove(studentId);
        courseRepository.save(course);
    }
}
