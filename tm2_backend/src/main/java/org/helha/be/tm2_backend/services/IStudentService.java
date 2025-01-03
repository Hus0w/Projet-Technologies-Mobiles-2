package org.helha.be.tm2_backend.services;

import org.helha.be.tm2_backend.models.Student;

import java.util.List;

public interface IStudentService {
    public List<Student> getStudents();
    public Student addStudent(Student student);
    public Student updateStudent(Student student, int id);
    public void deleteStudent(int id);
}