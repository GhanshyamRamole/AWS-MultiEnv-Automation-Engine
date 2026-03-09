package com.example.demo;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.List;

@Controller
public class TaskController {
    private List<Task> taskList = new ArrayList<>();

    @GetMapping("/")
    public String index(Model model) {
        model.addAttribute("tasks", taskList);
        return "index"; 
    }

    @PostMapping("/create")
    public String createTask(@RequestParam String title, @RequestParam String description) {
        taskList.add(new Task(title, description));
        return "redirect:/"; 
    }
}
