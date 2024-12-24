package org.helha.be.tm2_backend.repositories.jpa;

import org.helha.be.tm2_backend.models.Student;
import org.helha.be.tm2_backend.models.StudentCourse;
import org.springframework.data.jpa.repository.JpaRepository;

public interface StudentCourseRepository extends JpaRepository<StudentCourse, Integer> {

    StudentCourse findByCourseNameAndStudent(String courseName, Student student);
}
