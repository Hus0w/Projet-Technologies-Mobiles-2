package org.helha.be.tm2_backend.repositories.jpa;

import org.helha.be.tm2_backend.models.Course;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CourseRepository extends JpaRepository<Course, Integer> {}
