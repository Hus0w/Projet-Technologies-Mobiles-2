package org.helha.be.tm2_backend.models;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;
import jakarta.persistence.*;
import lombok.Data;

import java.util.HashMap;
import java.util.Map;

@Entity
@Data
@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonPropertyOrder({"id", "name", "grades"})
public class Course {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    private String name;

    @ElementCollection
    @CollectionTable(name = "course_grades", joinColumns = @JoinColumn(name = "course_id"))
    @MapKeyJoinColumn(name = "student_id")
    @Column(name = "note")
    private Map<Integer, Double> grades = new HashMap<>();

    public Map<Integer, Double> getGrades() {
        return grades;
    }

    public void setGrades(Map<Integer, Double> grades) {
        this.grades = grades;
    }
}