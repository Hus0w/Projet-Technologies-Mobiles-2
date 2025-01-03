package org.helha.be.tm2_backend.services;

import org.helha.be.tm2_backend.models.Course;
import org.helha.be.tm2_backend.repositories.jpa.CourseRepository;
import org.helha.be.tm2_backend.repositories.jpa.StudentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Service;

import java.util.*;
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

    public Map<String, Object> getCourseStatistics(int courseId) {
        Course course = courseRepository.findById(courseId)
                .orElseThrow(() -> new RuntimeException("Cours non trouvé"));

        List<Double> grades = new ArrayList<>(course.getGrades().values());
        double average = grades.stream().mapToDouble(Double::doubleValue).average().orElse(0.0);
        double minGrade = grades.stream().mapToDouble(Double::doubleValue).min().orElse(0.0);
        double maxGrade = grades.stream().mapToDouble(Double::doubleValue).max().orElse(0.0);

        return Map.of(
                "courseName", course.getName(),
                "averageGrade", average,
                "minGrade", minGrade,
                "maxGrade", maxGrade
        );
    }


    public List<Map<String, Object>> getAllCoursesStatistics() {
        return courseRepository.findAll().stream().map(course -> {
            List<Double> grades = new ArrayList<>(course.getGrades().values());
            double average = grades.stream().mapToDouble(Double::doubleValue).average().orElse(0.0);

            Map<String, Object> courseStats = new HashMap<>();
            courseStats.put("courseId", course.getId());
            courseStats.put("courseName", course.getName());
            courseStats.put("averageGrade", average);
            courseStats.put("studentCount", course.getGrades().size());

            return courseStats;
        }).collect(Collectors.toList());
    }

    public double getStudentAverageGrade(int studentId) {
        // Obtenir tous les cours
        List<Course> courses = courseRepository.findAll();

        // Récupérer toutes les notes de cet étudiant dans tous les cours
        List<Double> grades = courses.stream()
                .map(course -> course.getGrades().get(studentId)) // Récupérer la note de l'élève pour chaque cours
                .filter(Objects::nonNull) // Supprimer les null si l'élève n'a pas de note dans certains cours
                .collect(Collectors.toList());

        // Calculer la moyenne
        return grades.stream().mapToDouble(Double::doubleValue).average().orElse(0.0);
    }

}