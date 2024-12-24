package org.helha.be.tm2_backend.repositories.jpa;

import org.helha.be.tm2_backend.models.Student;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface StudentRepository extends JpaRepository<Student, Integer> {}
