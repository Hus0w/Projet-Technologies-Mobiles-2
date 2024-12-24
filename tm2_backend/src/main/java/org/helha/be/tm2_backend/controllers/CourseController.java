package org.helha.be.tm2_backend.controllers;

import org.helha.be.tm2_backend.models.Course;
import org.helha.be.tm2_backend.services.CourseServiceDB;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping(path="/courses")
public class CourseController {

    @Autowired
    CourseServiceDB courseServiceDB;

    @GetMapping
    public List<Course> getCourses() {
        return courseServiceDB.getCourses();
    }

    @PostMapping
    public Course addCourse(@RequestBody Course course) {
        return courseServiceDB.addCourse(course);
    }

    @PutMapping(path="/{id}")
    public Course updateCourse(@RequestBody Course course, @PathVariable int id) {
        return courseServiceDB.updateCourse(course, id);
    }

    @DeleteMapping(path="/{id}")
    public void deleteCourse(@PathVariable int id) {
        courseServiceDB.deleteCourse(id);
    }
}
