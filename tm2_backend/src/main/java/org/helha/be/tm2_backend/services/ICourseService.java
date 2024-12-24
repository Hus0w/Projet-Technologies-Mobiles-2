package org.helha.be.tm2_backend.services;

import org.helha.be.tm2_backend.models.Course;

import java.util.List;

public interface ICourseService {
    public List<Course> getCourses();
    public Course addCourse(Course course);
    public Course updateCourse(Course course, int id);
    public void deleteCourse(int id);
}
