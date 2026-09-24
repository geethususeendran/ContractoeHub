package com.contractorHub.controller;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.contractorHub.pdf.ExperienceCertificates;
import com.contractorHub.pdf.PettyContractorsBillPdf;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
public class pdfController {
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/print-experience-certificate", method = RequestMethod.GET, 
	produces = MediaType.APPLICATION_PDF_VALUE)
	public ResponseEntity<InputStreamResource> generateExperienceCertificate(
	        Model model, 
	        HttpServletRequest request,
	        HttpServletResponse response, 
	        HttpSession session) throws IOException {

	    // Fetching all form parameters from the request
	    String name = safe(request.getParameter("name"));
	    String employeeId = safe(request.getParameter("employeeId"));
	    String designation = safe(request.getParameter("designation"));
	    String joinDate = safe(request.getParameter("joinDate"));
	    String releaseDate = safe(request.getParameter("releaseDate"));
	    String department = safe(request.getParameter("department"));
	    String email = safe(request.getParameter("email"));
	    String projectsWorked = safe(request.getParameter("projectsWorked"));
	    String skills = safe(request.getParameter("skills"));
	    String performance = safe(request.getParameter("performance"));
	    String certificateType = safe(request.getParameter("certificateType"));
	    String remarks = safe(request.getParameter("remarks"));

	    // Call the ExperienceCertificate.generateCertificate() method with necessary parameters
	    ByteArrayInputStream bis = ExperienceCertificates.generateCertificate(
	            request, response,
	            name, employeeId, designation,
	            joinDate, releaseDate,
	            department, email,
	            projectsWorked, skills,
	            performance, certificateType,
	            remarks
	    );

	    // Set the HTTP headers for the response
	    HttpHeaders headers = new HttpHeaders();
	    headers.add("Content-Disposition", "inline; filename=experience_certificate.pdf");

	    // Return the ResponseEntity with the PDF content
	    return ResponseEntity
	            .ok()
	            .headers(headers)
	            .contentType(MediaType.APPLICATION_PDF)
	            .body(new InputStreamResource(bis));
	}

	// Method to handle null or empty strings
	private String safe(String value) {
	    return (value == null || value.trim().isEmpty()) ? "" : value.trim();
	}
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/petty-Bill-details", method = RequestMethod.GET, 
	produces = MediaType.APPLICATION_PDF_VALUE)
	public ResponseEntity<InputStreamResource> PettyBill(Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session) 
	        throws IOException, ParseException {
	    // Retrieving parameters
String regNo = request.getParameter("regNo");
        String contractorPrefix = request.getParameter("contractorPrefix");
        String serialNo = request.getParameter("serialNo");
        String serviceCode = request.getParameter("serviceCode");
        String iomDate = request.getParameter("iomDate");
        String DateOfIssue = request.getParameter("DateOfIssue");
        String address = request.getParameter("address");
        String locationOfWork = request.getParameter("locationOfWork");
        String descriptionOfWork = request.getParameter("descriptionOfWork");
        String dateUndertaken = request.getParameter("dateUndertaken");
        String entryPassNo = request.getParameter("entryPassNo");
        String department = request.getParameter("department");
	    // Getting the bill amount as a BigDecimal
	    BigDecimal billamount = new BigDecimal(request.getParameter("billamount"));
	    String formattedBillAmount = new DecimalFormat("0.00").format(billamount);
	    String conName = request.getParameter("conName");
	    String billAmountWords = NumberToWordsConverter.convertToWords(billamount.longValue());
	    
	    // Calculating taxes
	    double percentage = 0.09;
	    BigDecimal cgst = billamount.multiply(BigDecimal.valueOf(percentage));
	    BigDecimal sgst = billamount.multiply(BigDecimal.valueOf(percentage));
	    BigDecimal roundedCgst = cgst.setScale(2, RoundingMode.HALF_UP);
	    BigDecimal roundedSgst = sgst.setScale(2, RoundingMode.HALF_UP);
	    BigDecimal total = billamount.add(roundedCgst).add(roundedSgst);
	    String totalInWords = NumberToWordsConverter.convertToWords(total.longValue());
	    
	    // Generating the PDF report
        ByteArrayInputStream bis = PettyContractorsBillPdf.pdfReport(request, response,
                regNo, contractorPrefix, serialNo, serviceCode, iomDate, DateOfIssue, address, locationOfWork, descriptionOfWork,
                dateUndertaken, entryPassNo, department, billamount.doubleValue(), 
                formattedBillAmount, conName, billAmountWords, roundedCgst, roundedSgst, total);
	    HttpHeaders headers = new HttpHeaders();
	    headers.add("Content-Disposition", "inline; filename=petty-Bill.pdf");
	    
	    return ResponseEntity
	            .ok()
	            .headers(headers)
	            .contentType(MediaType.APPLICATION_PDF)
	            .body(new InputStreamResource(bis));
	}

}
