package org.helha.be.tm2_backend.controllers;

import org.helha.be.tm2_backend.models.Course;
import org.helha.be.tm2_backend.services.CourseServiceDB;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/courses")
public class CourseController {

    @Autowired
    private CourseServiceDB courseServiceDB;

    /*
    @GetMapping
    public List<Course> getAllCourses() {
        return courseServiceDB.getCourses();
    }
    */

    @GetMapping
    public List<Map<String, Object>> getAllCourses() {
        return courseServiceDB.getCoursesWithStudents();
    }

    @GetMapping("/{id}")
    public Course getCourseById(@PathVariable int id) {
        return courseServiceDB.getCourseById(id)
                .orElseThrow(() -> new RuntimeException("Cours non trouvé"));
    }

    @PostMapping
    public Course createOrUpdateCourse(@RequestBody Course course) {
        System.out.println("Cours reçu : " + course);
        return courseServiceDB.addCourse(course);
    }

    @PutMapping("/{id}")
    public Course updateCours(@PathVariable int id, @RequestBody Map<String, String> payload) {
        // Validation pour vérifier que le champ "name" est présent
        if (!payload.containsKey("name")) {
            throw new RuntimeException("Le champ 'name' est obligatoire.");
        }

        String newName = payload.get("name");

        // Appel au service pour mettre à jour le nom
        return courseServiceDB.updateCourse(id, newName);
    }


    @DeleteMapping("/{id}")
    public void deleteCourse(@PathVariable int id) {
        courseServiceDB.deleteCourse(id);
    }

    @PostMapping("/{id}/grades")
    public void addGrade(@PathVariable int id, @RequestBody Map<String, Object> payload) {
        int studentId = Integer.parseInt(payload.get("studentId").toString());
        Double note = Double.valueOf(payload.get("note").toString());

        courseServiceDB.addGrade(id, studentId, note);
    }

    @DeleteMapping("/{id}/grades")
    public void removeGrade(@PathVariable int id, @RequestBody Map<String, Object> payload) {
        int studentId = Integer.parseInt(payload.get("studentId").toString());
        courseServiceDB.removeGrade(id, studentId);
    }

    @GetMapping("/{id}/statistics")
    public ResponseEntity<?> getCourseStatistics(@PathVariable int id) {
        Map<String, Object> statistics = courseServiceDB.getCourseStatistics(id);
        return ResponseEntity.ok(statistics);
    }

    @GetMapping("/statistics")
    public ResponseEntity<?> getAllCoursesStatistics() {
        List<Map<String, Object>> statistics = courseServiceDB.getAllCoursesStatistics();
        return ResponseEntity.ok(statistics);
    }
}