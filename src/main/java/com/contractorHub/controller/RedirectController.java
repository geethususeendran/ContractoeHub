package com.contractorHub.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class RedirectController {

	@GetMapping("/redirect")
	private String getEdit(HttpSession session, Model model, HttpServletRequest req, @RequestParam("param") String param) {
	    switch(param) {
	        case "edit-employee-details":
	        	if (req.getParameter("id") != null) {
	        	    int userId = Integer.parseInt(req.getParameter("id"));
	        	    session.setAttribute("userId", userId);
	        	}
	            return "redirect:/edit-employee-details"; // Replace with the appropriate view name
	            
	        case "delete-employee-details":
	        	if(req.getParameter("id")!=null)
	            {
	            	int userID = Integer.parseInt(req.getParameter("id"));
	            	session.setAttribute("userID", userID);
	            }
	            return "redirect:/delete-employee-registration";

	        case "delete-home":
	        	if(req.getParameter("id")!=null)
	            {
	            	int StudDelId = Integer.parseInt(req.getParameter("id"));
	            	session.setAttribute("StudDelId", StudDelId);
	            }
	            return "redirect:/delete-home-page";
	        default:
	            return "error-page"; // Replace with the appropriate view name
	    }
	}

}
