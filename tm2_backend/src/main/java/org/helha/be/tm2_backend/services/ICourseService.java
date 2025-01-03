package org.helha.be.tm2_backend.services;

import org.helha.be.tm2_backend.models.Course;

import java.util.List;
import java.util.Map;
import java.util.Optional;

public interface ICourseService {
    public List<Course> getCourses();
    public Optional<Course> getCourseById(int id);
    public List<Map<String, Object>> getCoursesWithStudents();
    public Course addCourse(Course course);
    public Course updateCourse(int id, String newName);
    public void deleteCourse(int id);
}
