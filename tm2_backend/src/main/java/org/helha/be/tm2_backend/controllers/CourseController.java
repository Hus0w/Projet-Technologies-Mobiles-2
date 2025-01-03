package org.helha.be.tm2_backend.controllers;

import org.helha.be.tm2_backend.models.Course;
import org.helha.be.tm2_backend.services.CourseServiceDB;
import org.springframework.beans.factory.annotation.Autowired;
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
        return courseServiceDB.addOrUpdateCourse(course);
    }

    @DeleteMapping("/{id}")
    public void deleteCourse(@PathVariable int id) {
        courseServiceDB.deleteCourse(id);
    }

    @PostMapping("/{courseId}/grades")
    public void addGrade(@PathVariable int courseId, @RequestBody Map<String, Object> payload) {
        int studentId = Integer.parseInt(payload.get("studentId").toString());
        Double note = Double.valueOf(payload.get("note").toString());

        courseServiceDB.addGrade(courseId, studentId, note);
    }

    @DeleteMapping("/{courseId}/grades")
    public void removeGrade(@PathVariable int courseId, @RequestBody Map<String, Object> payload) {
        int studentId = Integer.parseInt(payload.get("studentId").toString());
        courseServiceDB.removeGrade(courseId, studentId);
    }
}